# encoding: UTF-8

module MH

  class Model
    attr_accessor :context

    def initialize
      @_model = Hash.new { |hash, key| hash[key] = Distribution.new }
    end

    def <<(symbol)
      @_model[@context] << symbol
    end

    def inspect
      {
        context: @context.to_a,
        distribution: to_a
      }
    end

    def to_s
      [@context.to_s, ': ', to_a.to_s].join
    end

    def to_a
      @_model[@context].to_a
    end

    def random
      @_model[@context].random
    end

  end

end
