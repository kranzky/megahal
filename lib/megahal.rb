# encoding: UTF-8

require 'unicode_utils'

require 'megahal/dictionary'
require 'megahal/context'
require 'megahal/distribution'
require 'megahal/memory'
require 'megahal/session'
require 'megahal/predictors'
require 'megahal/models'

class MegaHAL

  def initialize
    @_session = MH::Session.new
    @_dictionary = MH::Dictionary.new
    @_utterance = MH::Model::Utterance.new
    @_punctuation = MH::Model::Punctuation.new
    @_capitalisation = MH::Model::Capitalisation.new
    @_memory = MH::Model::Memory.new
  end

  def observe(sentence)
    separators, symbols, words = @_dictionary.decompose(sentence)
    @_utterance.learn(symbols)
    @_punctuation.learn(separators, symbols)
    @_capitalisation.learn(separators, symbols, words)
    symbols
  end
  
  def stimulus(sentence)
    @_session.question = observe(sentence)
  end

  def response(sentence)
    answer = observe(sentence)
    @_memory.learn(@_session.question, @_session.answer)
  end

  def generate
    @_memory.think(@_session.question, @_session.memory)
    symbols = @_utterance.generate(@_session.memory)
    separators = @_punctuation.generate(symbols)
    words = @_capitalisation.generate(separators, symbols)
    @_dictionary.reconstitute(separators, words)
  end

end
