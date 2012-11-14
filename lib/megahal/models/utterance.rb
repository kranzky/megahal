# encoding: UTF-8

module MH

  module Model

    class Utterance < Base

      def initialize
        @_markov = MH::Predictor::Markov.new(2)
      end

      def learn(symbols)
        @_markov.observe(symbols)
      end

      def generate(memory)
        @_markov.generate
      end

    end

  end

end
