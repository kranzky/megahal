# encoding: UTF-8

module MH

  module Model

    # This model learns how to yield a sequence of words given a sequence of
    # norms and a sequence of puncs. It does this by maintaining two models;
    # one of which learns which word to yield for a given norm and a context
    # of the surrounding puncs, while the other learns which word to yield for
    # a given norm and a context of the surrounding norms. The predictions made
    # by each of these models is combined, and the most likely candidate used.
    class Capitalisation < Base

      def initialize
        @_repair_puncs = MH::Predictor::Repair.new
        @_repair_norms = MH::Predictor::Repair.new
      end

      def learn(puncs, norms, words)
        norms.each.with_index do |id, index|
          @_repair_puncs.context << puncs[index] << id
          @_repair_puncs << words[index]
          @_repair_norms.context << id
          @_repair_norms << words[index]
        end
      end

      def generate(puncs, norms)
        words = []
        norms.each.with_index do |id, index|
          @_repair_puncs.context << puncs[index] << id
          @_repair_norms.context << id
          distribution = @_repair_puncs.predict + @_repair_norms.predict
          words << distribution.max
        end
        words
      end

    end

  end

end
