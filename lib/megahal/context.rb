module MH

  class Context

    def initialize(size)
      @_ids = Array.new(size, 0)
      @_format = 'w' * size
    end

    def code
      @_ids.pack(@_format)
    end

    def reset!
      @_ids.map! { 0 }
    end

    def size
      @_ids.size
    end

    def <<(id)
      raise unless id.kind_of?(Integer)
      @_ids << id
      @_ids.shift
      self
    end

    def inspect
      to_s
    end

    def to_s
      to_a.to_s
    end

    def to_a
      @_ids
    end

  end

end
