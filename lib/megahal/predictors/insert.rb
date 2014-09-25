module MH

  module Predictor

    class Insert < Base

      def initialize
        super(2)
      end

      def observe(puncs, norms)
        raise unless norms.length == puncs.length - 1
        @_context.reset!
        norms.each.with_index do |id, index|
          @_context << id
          self << puncs[index]
        end
        @_context << 0
        self << puncs[-1]
      end

      def generate(norms)
        puncs = []
        @_context.reset!
        norms.each do |id|
          @_context << id
          puncs << self.random
        end
        @_context << 0
        puncs << self.random
        puncs
      end

    end

  end

end
