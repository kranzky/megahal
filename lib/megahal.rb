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
    @_punctuation = MH::Model::Punctuation.new
  end
  
  def observe(sentence)
    separators, symbols, words = @_dictionary.decompose(sentence)
    @_utterance.learn(symbols)
    @_punctuation.learn(separators, symbols)
  end

  def generate
    symbols = @_utterance.generate(@_memory)
    separators = @_punctuation.generate(@_utterance)
    @_dictionary.reconstitute(separators, symbols)
  end

end
