# encoding: UTF-8

module MH

  class Distribution

    def initialize
      @_count = Hash.new { 0 }
      @_total = 0
    end

    def <<(symbol)
      @_count[symbol.to_sym] += 1
      @_total += 1
    end

    def inspect
      to_s
    end

    def to_s
      to_a.to_s
    end

    def to_a
      total = @_total.to_f
      @_count.map do |symbol, count|
        {
          symbol: symbol,
          probability: count / total
        }
      end
    end

    def random
      threshold = rand(0...@_total)
      element = @_count.detect do |symbol, count|
        (threshold -= count) < 0
      end
      element.first
    end

  end

end
