# encoding: UTF-8

module MH

  module Predictor

    class Insert < Base

      def initialize
        super(2)
      end

      def observe(separators, symbols)
        @_context.reset!
        symbols.each.with_index do |symbol, index|
          @_context << symbol
          self << separators[index]
        end
        @_context << 0
        self << separators[-1]
      end

      def generate(symbols)
        separators = []
        @_context.reset!
        symbols.each do |symbol|
          @_context << symbol
          separators << random
        end
        @_context << 0
        separators << random
        separators
      end

    end

  end

end
