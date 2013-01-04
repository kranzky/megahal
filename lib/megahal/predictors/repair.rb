# encoding: UTF-8

module MH

  module Predictor

    class Repair < Base

      def initialize
        super(2)
      end

      def observe(puncs, words)
        raise unless words.length == puncs.length - 1
        @_context.reset!
        sequence.each do |symbol|
          @_context << (self << symbol)
        end
        @_context.size.times { @_context << (self << nil) }
      end

    end

  end

end
