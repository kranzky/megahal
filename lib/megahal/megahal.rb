require 'byebug'
require 'sooth'

class MegaHAL
  # Create a new MegaHAL instance, loading the :default personality.
  def initialize
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
    # TODO: new release so clear works
#   @seed.clear    
#   @fore.clear    
#   @back.clear    
#   @seed.clear
#   @case.clear    
#   @punc.clear    
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

  # Generate a reply to the user's input. If the learn parameter is set to true,
  # MegaHAL will also learn from what the user said.  Note that it takes MegaHAL
  # about one second to generate about 500 replies.
  # 
  # @param [String] input A string that represents the user's input. If this is
  #                       nil, MegaHAL will attempt to reply with a greeting,
  #                       suitable for beginning a conversation.
  # @param [Bool] learn Whether or not MegaHAL should learn the input.
  # @param [String] error The default reply, which will be used when no
  #                       suitable reply can be formed.
  #
  # @return [String] MegaHAL's reply to the user's input, or the error
  #                  string if no reply could be formed.
  def reply(input, learn=true, error="I don't know enough to answer you yet!")
    puncs, norms, words = _decompose(input ? input.strip : nil)

    _learn(puncs, norms, words) if learn && norms

    keyword_symbols =
      MegaHAL.extract(norms)
          .map { |keyword| @dictionary[keyword] }
          .compact

    100.times do
      if norm_symbols = _generate(keyword_symbols)
        if reply = _rewrite(norm_symbols)
          return reply
        end
      end
    end

    return error
  end

  # Save MegaHAL's brain to the specified binary file.
  #
  # @param [String] filename The brain file to be saved.
  def save(filename)
    # TODO: save dictionary and five models to a zip file
    raise
  end

  # Load a brain that has previously been saved.
  #
  # @param [String] filename The brain file to be loaded.
  def load(filename)
    # TODO: load dictionary and five models from a zip file
    raise
  end

  # Train MegaHAL with the contents of the specified file, which should be plain
  # text with one sentence per line.  Note that it takes MegaHAL about one
  # second to process about 500 lines, so large files may cause the process to
  # block for a while. Lines that are too long will be skipped.
  #
  # @param [String] filename The text file to be used for training.
  def train(filename)
    _train(File.read(filename).each_line.to_a)
  end

  private

  def _train(data)
    data.map!(&:strip)
    data.each { |line| _learn(*_decompose(line)) }
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
    sequence = line.split(/([[:word:]]+)/)
    # ensure the array starts with and ends with a word-separator, even if it's the blank onw
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
  # contain at least one of the keywords
  def _generate(keyword_symbols)
    results = 
      if keyword = keyword_symbols.shuffle.first
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
        decode = Hash[@dictionary.to_a.map(&:reverse)]
        glue = context.select { |symbol| symbol != 1 }
        _random_walk(@back, context.reverse).reverse + glue + _random_walk(@fore, context)
      else
        context = [1, 1]
        _random_walk(@fore, context)
      end
    results.length == 0 ? nil : results
  end

  # This is classic Markovian generation; using a model, start with a context
  # and continue until we hit a <fence> symbol.
  def _random_walk(model, static_context)
    context = static_context.dup
    results = []
    return [] if model.count(context) == 0
    loop do
      limit = rand(model.count(context)) + 1
      symbol = model.select(context, limit)
      raise if symbol == 0
      break if symbol == 1
      results << symbol
      context << symbol
      context.shift
    end
    results
  end

  # Here we take a generated sequence of norms and convert them back to a string
  # that may be displayed to the user as output. This involves using the @case
  # model to rewrite each norm as a word, and then using the @punc model to
  # insert appropriate word separators.
  def _rewrite(norm_symbols)
    decode = Hash[@dictionary.to_a.map(&:reverse)]

    # Here we generate the sequence of words and puncs. This is slightly tricky,
    # because it is possible to generate a word (based on the context of the
    # previous word and the current norm) such that it is impossible to generate
    # the next word in the sequence (because we may generate a word of a
    # different case than what we have observed in the past). So we keep trying
    # until we stumble upon a combination that works, or until we've tried too
    # many times. Note that backtracking would need to go back an arbitrary
    # number of steps, and is therefore too messy to implement.
    word_symbols = []
    punc_symbols = []
    context = [1, 1]
    i = 0
    attempts = 0
    while word_symbols.length != norm_symbols.length
      return nil if attempts >= 100
      # We're trying to rewrite norms to words, so build a context for the @case
      # model, of the previous word and the current norm.
      context[0] = (i == 0) ? 1 : word_symbols[i-1]
      context[1] = norm_symbols[i]
      count = @case.count(context)
      if count == 0
        # This may fail if the previous word hasn't been observed adjacent to
        # the current norm, which will happen if the rewrote the previous norm
        # to a different case that what was observed previously. So we retry.
        raise if i == 0
        attempts += 1
        word_symbols.clear
        punc_symbols.clear
        i = 0
        next
      end
      limit = rand(count) + 1
      word_symbols << @case.select(context, limit)
      # We've used the case model to rewrite the current norm to a word. Now we
      # build a context for the @punc model of the previous word and the current
      # word, and use that to select a word-separator to go between them.
      context[0] = (i == 0) ? 1 : word_symbols[i-1]
      context[1] = word_symbols[i]
      count = @punc.count(context)
      if count == 0
        # This may also fail if the particular form of the two adjacent words
        # have never been observed together, so retry again.
        attempts += 1
        word_symbols.clear
        punc_symbols.clear
        i = 0
        next
      end
      limit = rand(count) + 1
      punc_symbols << @punc.select(context, limit)
      # Finally, if we've finished rewriting the words, we need to generate one
      # more word-separator to end the sentence with.
      if word_symbols.length == norm_symbols.length
        context << 1
        context.shift
        count = @punc.count(context)
        if count == 0
          # And, as before, retry if the generation fails.
          attempts += 1
          word_symbols.clear
          punc_symbols.clear
          i = 0
          next
        end
        limit = rand(count) + 1
        punc_symbols << @punc.select(context, limit)
      end
      i += 1
    end

    # Finally we zip the word-separators and the words together, decode the
    # symbols to their string representations (as stored in the @dictionary),
    # and join everything together to give the final reply.
    punc_symbols.zip(word_symbols).flatten.map { |word| decode[word] }.join
  end
end
