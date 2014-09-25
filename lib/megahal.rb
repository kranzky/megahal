require 'megahal/dictionary'
require 'megahal/context'
require 'megahal/distribution'
require 'megahal/memory'
require 'megahal/session'
require 'megahal/predictors'
require 'megahal/models'

module MegaHAL

  class Brain
    def initialize
      @_session = MegaHAL::Session.new
      @_dictionary = MegaHAL::Dictionary.new
      @_utterance = MegaHAL::Model::Utterance.new
      @_punctuation = MegaHAL::Model::Punctuation.new
      @_capitalisation = MegaHAL::Model::Capitalisation.new
      @_memory = MegaHAL::Model::Memory.new
    end

    def observe(sentence)
      puncs, norms, words = @_dictionary.decompose(sentence)
      @_utterance.learn(norms)
      @_punctuation.learn(puncs, norms)
      @_capitalisation.learn(puncs, norms, words)
      norms
    end

    def normalise(sentence)
      _, norms, _ = @_dictionary.decompose(sentence)
      norms
    end

    def reconstitute(norms)
      puncs = @_punctuation.generate(norms)
      words = @_capitalisation.generate(puncs, norms)
      @_dictionary.reconstitute(puncs, words)
    end

    def stimulus(sentence)
      @_session.question = observe(sentence)
    end

    def response(sentence)
      @_session.answer = observe(sentence)
      @_memory.learn(@_session.question, @_session.answer)
    end

    def generate
      @_memory.think(@_session.question, @_session.memory)
      norms = @_utterance.generate(@_session.memory)
      reconstitute(norms)
    end
  end

end
