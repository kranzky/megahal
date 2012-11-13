# encoding: UTF-8

module MH

  class Dictionary

    def initialize
      @_index = [nil]
      @_lookup = {nil => 0}
    end

    def <<(symbol)
      return 0 if symbol.nil?
      key = symbol.to_sym
      unless @_lookup.include?(key)
        @_lookup[key] = @_index.length
        @_index << symbol
      end
      @_lookup[key]
    end

    def [](key)
      return 0 if key.nil?
      key.is_a?(Numeric) ? @_index[key] : @_lookup[key.to_sym]
    end

    def inspect
      to_s
    end

    def to_s
      to_a.to_s
    end

    def to_a
      @_index
    end

  end

end
