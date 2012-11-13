# encoding: UTF-8

require 'megahal/context'
require 'megahal/dictionary'
require 'megahal/distribution'
require 'megahal/model'

class MegaHAL

  def initialize
    @_dictionary = MH::Dictionary.new
    @_markov = MH::Model.new(@_dictionary, 2)
  end
  
  def test

    dictionary = MH::Dictionary.new

    dictionary << 'the'
    dictionary << 'cat'
    dictionary << 'sat'
    dictionary << 'on'
    dictionary << 'the'
    dictionary << 'mat'

    puts dictionary[0]
    puts dictionary['cat']

    model = MH::Model.new
    model.context = MH::Context.new
    model.context << 'x'
    model.context << 'y'
    model << 'a'
    model << 'b'
    model << 'a'
    model << 'a'

  end

  def observe(sentence)
    puncs, words = _decompose(sentence)
    symbols = _normalise(words)
    @_markov.observe(symbols)
  end

  def generate
    @_markov.generate.map { |symbol| @_dictionary[symbol] }.join
  end

  private

  def _decompose(sentence, min = 5)
    sequence = sentence.split(/([[:word:]]+)/)
    chars = sequence.length <= min
    sequence = sentence.split(/()/) if chars
    sequence << '' if chars || sequence.last =~ /[[:word:]]+/
    sequence.unshift '' if chars || sequence.first =~ /[[:word:]]+/
    sequence.partition.with_index { |symbol, index| index.even? }
  end

  def _normalise(sequence)
    sequence.map { |symbol| UnicodeUtils.upcase(symbol) }
  end

end
