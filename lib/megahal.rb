# encoding: UTF-8

require 'unicode_utils'

require 'megahal/dictionary'
require 'megahal/context'
require 'megahal/distribution'
require 'megahal/memory'
require 'megahal/predictors'
require 'megahal/models'

class MegaHAL

  def initialize
    @_memory = MH::Memory.new
    @_dictionary = MH::Dictionary.new
    @_utterance = MH::Model::Utterance.new
  end
  
  def observe(sentence)
    punctuation, words = _decompose(sentence)
    symbols = _normalise(words)
    [words, symbols, punctuation].each { |a| @_dictionary.map(a) }
    @_utterance.learn(words)
  end

  def generate
    symbols = @_utterance.generate(@_memory)
    symbols.map { |symbol| @_dictionary[symbol] }.join
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
