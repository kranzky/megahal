# encoding: UTF-8

module MH

  module Predictor

    class Insert < Base

      def initialize
        super(2)
      end

      def observe(word_sequence, punc_sequence)
        @_context.reset!
        sequence.each do |symbol|
          @_context << (self << symbol)
        end
        @_context.size.times { @_context << (self << nil) }
      end

    end

  end

end
