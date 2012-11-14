# encoding: UTF-8

module MH

  module Predictor

    class Markov < Base

      def observe(symbols)
        @_context.reset!
        symbols.each do |symbol|
          @_context << (self << symbol)
        end
        @_context.size.times { @_context << (self << 0) }
      end

      def generate
        symbols = []
        @_context.reset!
        while true
          symbol = random
          break if symbol == 0
          symbols << symbol
          @_context << symbol
        end
        symbols
      end

    end

  end

end
