# encoding: UTF-8

module MH

  class Model
    def initialize(dictionary, size)
      @_dictionary = dictionary
      @_context = MH::Context.new(size)
      @_model = Hash.new { |hash, key| hash[key] = Distribution.new }
    end

    def observe(sequence)
      @_context.reset!
      sequence.each do |symbol|
        @_context << (self << symbol)
      end
      puts @_model
    end

    def context
      @_context
    end

    def <<(symbol)
      @_model[@_context.code] << (@_dictionary << symbol)
    end

    def inspect
      {
        context: @_context.to_a,
        distribution: to_a
      }
    end

    def to_s
      [@_context.inspect, ': ', to_a.to_s].join
    end

    def to_a
      @_model[@_context.code].to_a
    end

    def random
      @_model[@_context.code].random
    end

  end

end
