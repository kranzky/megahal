# encoding: UTF-8

module MH

  class Distribution

    def initialize
      @_count = Hash.new { 0 }
      @_total = 0
    end

    def <<(id)
      raise unless id.kind_of?(Integer)
      @_count[id] += 1
      @_total += 1
      id
    end

    def inspect
      to_s
    end

    def to_s
      to_a.to_s
    end

    def to_a
      total = @_total.to_f
      @_count.map do |id, count|
        {
          id: id,
          probability: count / total
        }
      end
    end

    def random
      return nil if @_total == 0
      threshold = rand(0...@_total)
      element = @_count.detect do |_, count|
        (threshold -= count) < 0
      end
      element.first
    end

  end

end
