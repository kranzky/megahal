# encoding: UTF-8

module MH

  module Predictor

    class Markov < Base

      def observe(sequence)
        @_context.reset!
        sequence.each do |symbol|
          @_context << (self << symbol)
        end
        @_context.size.times { @_context << (self << 0) }
      end

      def generate
        retval = []
        @_context.reset!
        while true
          index = random
          break if index == 0
          retval << index
          @_context << index
        end
        retval
      end

    end

  end

end
