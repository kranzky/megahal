# encoding: UTF-8

module MH

  module Predictor

    class Insert < Base

      def initialize
        super(2)
      end

      def observe(puncs, norms)
        raise unless norms.length == puncs.length - 1
        @_context.reset!
        norms.each.with_index do |symbol, index|
          @_context << symbol
          self << puncs[index]
        end
        @_context << 0
        self << puncs[-1]
      end

      def generate(norms)
        puncs = []
        @_context.reset!
        norms.each do |symbol|
          @_context << symbol
          puncs << random
        end
        @_context << 0
        puncs << random
        puncs
      end

    end

  end

end
