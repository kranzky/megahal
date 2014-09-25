module MegaHAL

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

    def |(other)
      raise unless other.kind_of?(Distribution)
      retval = Distribution.new
      (@_count.keys | other._count.keys).each do |id|
        retval._count[id] += @_count[id]
        retval._count[id] += other._count[id]
        retval._total += retval._count[id]
      end
      retval
    end

    def &(other)
      raise unless other.kind_of?(Distribution)
      retval = Distribution.new
      (@_count.keys & other._count.keys).each do |id|
        retval._count[id] += @_count[id]
        retval._count[id] += other._count[id]
        retval._total += retval._count[id]
      end
      retval
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

    def max
      return nil if @_total == 0
      max_count = 0
      max_counts = []
      @_count.each do |id, count|
        next if count < max_count
        max_counts.clear if count > max_count
        max_count = count
        max_counts << id
      end
      max_counts.sample
    end

    protected

    attr_accessor :_total, :_count

  end

end
