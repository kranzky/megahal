module MegaHAL

  module Model

    class Utterance < Base

      def initialize
        @_markov = Predictor::Markov.new(2)
      end

      def learn(norms)
        @_markov.observe(norms)
      end

      def generate(memory)
        @_markov.generate
      end

    end

  end

end
