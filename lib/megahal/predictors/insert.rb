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
          self << separators[index]
          @_context << symbol
        end
        self << separators[-1]
        @_context.size.times { @_context << (self << 0) }
      end

      def generate(symbols)
        separators = []
        @_context.reset!
        symbols.each do |symbol|
          separators << random
          @_context << symbol
        end
        separators << random
        separators
      end

    end

  end

end
