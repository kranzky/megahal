require 'cld'
require 'sooth'
require 'tempfile'
require 'json'
require 'zip'

class MegaHAL
  attr_accessor :learning

  # Create a new MegaHAL instance, loading the :default personality.
  def initialize
    @learning = true
    @seed = Sooth::Predictor.new(0)
    @fore = Sooth::Predictor.new(0)
    @back = Sooth::Predictor.new(0)
    @case = Sooth::Predictor.new(0)
    @punc = Sooth::Predictor.new(0)
    become(:default)
  end

  def inspect
    to_s
  end

  # Wipe MegaHAL's brain. Note that this wipes the personality too, allowing you
  # to begin from a truly blank slate.
  def clear
    @seed.clear    
    @fore.clear    
    @back.clear    
    @case.clear    
    @punc.clear    
    @dictionary = { "<error>" => 0, "<fence>" => 1, "<blank>" => 2 }
    nil
  end

  def self.add_personality(name, data)
    @@personalities ||= {}
    @@personalities[name.to_sym] = data.each_line.to_a
    nil
  end

  # Returns an array of MegaHAL personalities.
  #
  # @return [Array] A list of symbols representing the available personalities.
  def self.list
    @@personalities ||= {}
    @@personalities.keys
  end

  # Loads the specified personality. Will raise an exception if the personality
  # parameter isn't one of those returned by #list. Note that this will clear
  # MegaHAL's brain first.
  #
  # @param [Symbol] name The personality to be loaded.
  def become(name=:default)
    raise ArgumentError, "no such personality" unless @@personalities.key?(name)
    clear
    _train(@@personalities[name])
  end

  # Generate a reply to the user's input. If the learning attribute is set to true,
  # MegaHAL will also learn from what the user said.  Note that it takes MegaHAL
  # about one second to generate about 500 replies.
  # 
  # @param [String] input A string that represents the user's input. If this is
  #                       nil, MegaHAL will attempt to reply with a greeting,
  #                       suitable for beginning a conversation.
  # @param [String] error The default reply, which will be used when no
  #                       suitable reply can be formed.
  #
  # @return [String] MegaHAL's reply to the user's input, or the error
  #                  string if no reply could be formed.
  def reply(input, error="...")
    puncs, norms, words = _decompose(input ? input.strip : nil)

    keyword_symbols =
      MegaHAL.extract(norms)
          .map { |keyword| @dictionary[keyword] }
          .compact

    input_symbols = (norms || []).map { |norm| @dictionary[norm] }

    # create candidate utterances
    utterances = []
    9.times { utterances << _generate(keyword_symbols) }
    utterances << _generate([])
    utterances.delete_if { |utterance| utterance == input_symbols }
    utterances.compact!

    # select the best utterance, and handle _rewrite failure
    reply = nil
    while reply.nil? && utterances.length > 0
      break unless utterance = _select_utterance(utterances, keyword_symbols)
      reply = _rewrite(utterance)
      utterances.delete(utterance)
    end

    # learn from what the user said _after_ generating the reply
    _learn(puncs, norms, words) if @learning && norms

    return reply || error
  end

  # Save MegaHAL's brain to the specified binary file.
  #
  # @param [String] filename The brain file to be saved.
  # @param [ProgressBar] bar An optional progress bar instance.
  def save(filename, bar = nil)
    bar.total = 6 unless bar.nil?
    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream("dictionary") do |file|
        file.write({
          version: 'MH10',
          learning: @learning,
          dictionary: @dictionary
        }.to_json)
      end
      bar.increment unless bar.nil?
      [:seed, :fore, :back, :case, :punc].each do |name|
        tmp = _get_tmp_filename(name)
        instance_variable_get("@#{name}").save(tmp)
        zipfile.add(name, tmp)
        bar.increment unless bar.nil?
      end
    end
  end

  # Load a brain that has previously been saved.
  #
  # @param [String] filename The brain file to be loaded.
  # @param [ProgressBar] bar An optional progress bar instance.
  def load(filename, bar = nil)
    bar.total = 6 unless bar.nil?
    Zip::File.open(filename) do |zipfile|
      data = JSON.parse(zipfile.find_entry("dictionary").get_input_stream.read)
      raise "bad version" unless data['version'] == "MH10"
      @learning = data['learning']
      @dictionary = data['dictionary']
      bar.increment unless bar.nil?
      [:seed, :fore, :back, :case, :punc].each do |name|
        tmp = _get_tmp_filename(name)
        zipfile.find_entry(name.to_s).extract(tmp)      
        instance_variable_get("@#{name}").load(tmp)
        bar.increment unless bar.nil?
      end
    end
  end

  # Train MegaHAL with the contents of the specified file, which should be plain
  # text with one sentence per line.  Note that it takes MegaHAL about one
  # second to process about 500 lines, so large files may cause the process to
  # block for a while. Lines that are too long will be skipped.
  #
  # @param [String] filename The text file to be used for training.
  # @param [ProgressBar] bar An optional progress bar instance.
  def train(filename, bar = nil)
    lines = File.read(filename).each_line.to_a
    bar.total = lines.length unless bar.nil?
    _train(lines, bar)
  end

  private

  def _train(data, bar = nil)
    data.map!(&:strip)
    data.each do |line|
      _learn(*_decompose(line))
      bar.increment unless bar.nil?
    end
    nil
  end

  # Train each of the five models based on a sentence decomposed into a list of
  # word separators (puncs), capitalised words (norms) and words as they were
  # observed (in mixed case).
  def _learn(puncs, norms, words)
    return if words.length == 0

    # Convert the three lists of strings into three lists of symbols so that we
    # can use the Sooth::Predictor. This is done by finding the ID of each of
    # the strings in the @dictionary, allowing us to easily rewrite each symbol
    # back to a string later.
    punc_symbols = puncs.map { |punc| @dictionary[punc] ||= @dictionary.length }
    norm_symbols = norms.map { |norm| @dictionary[norm] ||= @dictionary.length }
    word_symbols = words.map { |word| @dictionary[word] ||= @dictionary.length }

    # The @seed model is used to start the forwards-backwards reply generation.
    # Given a keyword, we want to find a word that has been observed adjacent to
    # it. Each context here is a bigram where one symbol is the keyword and the
    # other is the special <blank> symbol (which has ID 2). The model learns
    # which words can fill the blank.
    prev = 1
    (norm_symbols + [1]).each do |norm|
      context = [prev, 2]
      @seed.observe(context, norm)  
      context = [2, norm]
      @seed.observe(context, prev)  
      prev = norm
    end

    # The @fore model is a classic second-order Markov model that can be used to
    # generate an utterance in a random-walk fashion. For each adjacent pair of
    # symbols the model learns which symbols can come next. Note that the
    # special <fence> symbol (which has ID 1) is used to delimit the utterance.
    context = [1, 1]
    norm_symbols.each do |norm|
      @fore.observe(context, norm)  
      context << norm
      context.shift
    end
    @fore.observe(context, 1)

    # The @back model is similar to the @fore model; it simply operates in the
    # opposite direction. This is how the original MegaHAL was able to generate
    # a random sentence guaranteed to contain a keyword; the @fore model filled
    # in the gaps towards the end of the sentence, and the @back model filled in
    # the gaps towards the beginning of the sentence.
    context = [1, 1]
    norm_symbols.reverse.each do |norm|
      @back.observe(context, norm)  
      context << norm
      context.shift
    end
    @back.observe(context, 1)

    # The previous three models were all learning the sequence of norms, which
    # are capitalised words. When we generate a reply, we want to rewrite it so
    # MegaHAL doesn't speak in ALL CAPS. The @case model achieves this. For the
    # previous word and the current norm it learns what the next word should be.
    context = [1, 1]
    word_symbols.zip(norm_symbols).each do |word, norm|
      context[1] = norm
      @case.observe(context, word)  
      context[0] = word
    end

    # After generating a list of words, we need to join them together with
    # word-separators (whitespace and punctuation) in-between. The @punc model
    # is used to do this; here it learns for two adjacent words which
    # word-separators can be used to join them together.
    context = [1, 1]
    punc_symbols.zip(word_symbols + [1]).each do |punc, word|
      context << word
      context.shift
      @punc.observe(context, punc)  
    end
  end

  # This takes a string and decomposes it into three arrays representing
  # word-separators, capitalised words and the original words.
  def _decompose(line, maximum_length=1024)
    return [nil, nil, nil] if line.nil?
    line = "" if line.length > maximum_length
    return [[], [], []] if line.length == 0
    puncs, words = _segment(line)
    norms = words.map(&:upcase)
    [puncs, norms, words]
  end

  # This segments a sentence into two arrays representing word-separators and
  # the original words themselves/
  def _segment(line)
    # split the sentence into an array of alternating words and word-separators
    sequence =
      if _character_segmentation(line)
        line.split(/([[:word:]])/)
      else
        line.split(/([[:word:]]+)/)
      end
    # ensure the array starts with and ends with a word-separator, even if it's the blank one
    sequence << "" if sequence.last =~ /[[:word:]]+/
    sequence.unshift("") if sequence.first =~ /[[:word:]]+/
    # join trigrams of word-separator-word if the separator is a single ' or -
    # this means "don't" and "hob-goblin" become single words
    while index = sequence[1..-2].index { |item| item =~ /^['-]$/ } do
      sequence[index+1] = sequence[index, 3].join
      sequence[index] = nil
      sequence[index+2] = nil
      sequence.compact!
    end
    # split the alternating sequence into two arrays of word-separators and words
    sequence.partition.with_index { |symbol, index| index.even? }
  end

  # Given an array of keyword symbols, generate an array of norms that hopefully
  # contain at least one of the keywords. All the symbols given as keywords must
  # have been observed in the past, othewise this will raise an exception.
  def _generate(keyword_symbols)
    results = 
      if keyword = _select_keyword(keyword_symbols)
        # Use the @seed model to find two contexts that contain the keyword.
        contexts = [[2, keyword], [keyword, 2]]
        contexts.map! do |context|
          count = @seed.count(context)
          if count > 0
            limit = @seed.count(context)
            context[context.index(2)] = @seed.select(context, limit)
            context
          else
            nil
          end
        end
        # Select one of the contexts at random
        context = contexts.compact.shuffle.first
        raise unless context
        # Here we glue the generations of the @back and @fore models together
        glue = context.select { |symbol| symbol != 1 }
        _random_walk(@back, context.reverse, keyword_symbols).reverse + glue + _random_walk(@fore, context, keyword_symbols)
      else
        # we weren't given any keywords, so do a normal markovian generation
        context = [1, 1]
        _random_walk(@fore, context, keyword_symbols)
      end
    results.length == 0 ? nil : results
  end

  # Remove auxilliary words and select at random from what remains
  def _select_keyword(keyword_symbols)
    (keyword_symbols - AUXILIARY.map { |word| @dictionary[word] }).shuffle.first
  end

  # This is classic Markovian generation; using a model, start with a context
  # and continue until we hit a <fence> symbol. The only addition here is that
  # we roll the dice several times, and prefer generations that elicit a
  # keyword.
  def _random_walk(model, static_context, keyword_symbols)
    context = static_context.dup
    results = []
    return [] if model.count(context) == 0
    local_keywords = keyword_symbols.dup
    loop do
      symbol = 0
      10.times do
        limit = rand(model.count(context)) + 1
        symbol = model.select(context, limit)
        if local_keywords.include?(symbol)
          local_keywords.delete(symbol)
          break
        end
      end
      raise if symbol == 0
      break if symbol == 1
      results << symbol
      context << symbol
      context.shift
    end
    results
  end

  # Given an array of utterances and an array of keywords, select the best
  # utterance (returning nil for none at all).
  def _select_utterance(utterances, keyword_symbols)
    best_score = -1
    best_utterance = nil

    utterances.each do |utterance|
      score = _calculate_score(utterance, keyword_symbols)
      next unless score > best_score
      best_score = score
      best_utterance = utterance
    end

    return best_utterance
  end

  # Calculate the score of a particular utterance
  def _calculate_score(utterance, keyword_symbols)
    score = 0

    context = [1, 1]
    utterance.each do |norm|
      if keyword_symbols.include?(norm)
        surprise = @fore.surprise(context, norm)
        score += surprise unless surprise.nil?
      end
      context << norm
      context.shift
    end

    context = [1, 1]
    utterance.reverse.each do |norm|
      if keyword_symbols.include?(norm)
        surprise = @back.surprise(context, norm)
        score += surprise unless surprise.nil?
      end
      context << norm
      context.shift
    end

    if utterance.length >= 8
      score /= Math.sqrt(utterance.length - 1)
    end

    if utterance.length >= 16
      score /= utterance.length
    end

    score
  end

  # Here we take a generated sequence of norms and convert them back to a string
  # that may be displayed to the user as output. This involves using the @case
  # model to rewrite each norm as a word, and then using the @punc model to
  # insert appropriate word separators.
  def _rewrite(norm_symbols)
    decode = Hash[@dictionary.to_a.map(&:reverse)]

    # Here we generate the sequence of words. This is slightly tricky, because
    # it is possible to generate a word (based on the context of the previous
    # word and the current norm) such that it is impossible to generate the next
    # word in the sequence (because we may generate a word of a different case
    # than what we have observed in the past). So we keep trying until we
    # stumble upon a combination that works, or until we've tried too many
    # times. Note that backtracking would need to go back an arbitrary number of
    # steps, and is therefore too messy to implement.
    word_symbols = []
    context = [1, 1]
    i = 0
    retries = 0
    while word_symbols.length != norm_symbols.length
      return nil if retries > 9
      # We're trying to rewrite norms to words, so build a context for the @case
      # model, of the previous word and the current norm.  This may fail if the
      # previous word hasn't been observed adjacent to the current norm, which
      # will happen if the rewrote the previous norm to a different case that
      # what was observed previously.
      context[0] = (i == 0) ? 1 : word_symbols[i-1]
      context[1] = norm_symbols[i]
      count = @case.count(context)
      unless failed = (count == 0)
        limit = rand(count) + 1
        word_symbols << @case.select(context, limit)
      end
      if (word_symbols.length == norm_symbols.length)
        # We need to check that the final word has been previously observed.
        context[0] = word_symbols.last
        context[1] = 1
        failed = (@punc.count(context) == 0)
      end
      if failed
        raise if i == 0
        retries += 1
        word_symbols.clear
        i = 0
        next
      end
      i += 1
    end

    # We've used the case model to rewrite the norms to a words in a way that
    # guarantees that each adjacent pair of words has been previously observed.
    # Now we use the @punc model to generate the word-separators to be inserted
    # between the words in the reply.
    punc_symbols = []
    context = [1, 1]
    (word_symbols + [1]).each do |word|
      context << word
      context.shift
      limit = rand(@punc.count(context)) + 1
      punc_symbols << @punc.select(context, limit)
    end

    # Finally we zip the word-separators and the words together, decode the
    # symbols to their string representations (as stored in the @dictionary),
    # and join everything together to give the final reply.
    punc_symbols.zip(word_symbols).flatten.map { |word| decode[word] }.join
  end

  # this is used when saving and loading; we do this by creating and immediately
  # removing a temporary file, then returning it's path (yech)
  def _get_tmp_filename(name)
    file = Tempfile.new(name.to_s)
    retval = file.path
    file.close
    file.unlink
    return retval
  end

  # by default the user's input is segmented into words; for languages that
  # don't use whitespace to delimit words, MegaHAL falls back to segmenting the
  # users input into "characters"... to do this we need to guess which language
  # the user's input is in with magic
  def _character_segmentation(line)
    language = CLD.detect_language(line)[:name]
    ["Japanese", "Korean", "Chinese", "TG_UNKNOWN_LANGUAGE", "Unknown", "JAVANESE", "THAI", "ChineseT", "LAOTHIAN", "BURMESE", "KHMER", "XX"].include?(language)
  end
end
