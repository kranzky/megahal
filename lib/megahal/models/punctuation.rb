# encoding: UTF-8

module MH

  module Model

    class Punctuation < Base

      def initialize
        @_insert = MH::Predictor::Insert.new
      end

      def learn(separators, symbols)
        @_insert.observe(separators, symbols)
      end

      def generate(symbols)
        @_insert.generate(symbols)
      end

    end

  end

end
