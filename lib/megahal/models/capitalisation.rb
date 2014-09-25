module MegaHAL

  module Model

    # This model learns how to yield a sequence of words given a sequence of
    # norms and a sequence of puncs. It does this by maintaining four models,
    # each of which predicts the correct word based on a context of two IDs,
    # representing all four possible contexts surrounding the target ID. The
    # predictions made by each of these models is combined, and the most likely
    # ID selected from the resulting distribution.
    class Capitalisation < Base

      def initialize
        @_models = 4.times.map { Predictor::Repair.new }
      end

      def learn(puncs, norms, words)
        norms.each.with_index do |_, index|
          _set_context(puncs, norms, index)
          @_models.each do |model|
            model << words[index]
          end
        end
      end

      def generate(puncs, norms)
        words = []
        norms.each.with_index do |id, index|
          _set_context(puncs, norms, index)
          distribution = nil
          @_models.each do |model|
            if distribution.nil?
              distribution = model.predict
            else
              distribution &= model.predict
            end
          end
          words << distribution.max
        end
        words
      end

      private

      def _set_context(puncs, norms, index)
        @_models.each.with_index do |model, model_index|
          model.context.reset!
          case model_index
          when 0
            model.context << puncs[index]
          when 1
            model.context << ((index > 0) ? norms[index - 1] : 0)
          when 2
            model.context << puncs[index + 1]
          when 3
            model.context << ((index < norms.length - 1) ? norms[index + 1] : 0)
          end
          model.context << norms[index]
        end
      end

    end

  end

end
