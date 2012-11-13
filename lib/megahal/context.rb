# encoding: UTF-8

module MH

  class Context

    def initialize(size)
      @_symbols = Array.new(size, 0)
      @_format = 'w' * size
    end

    def code
      @_symbols.pack(@_format)
    end

    def reset!
      @_symbols.map! { 0 }
    end

    def size
      @_symbols.size
    end

    def <<(symbol)
      @_symbols << symbol
      @_symbols.shift
    end

    def inspect
      to_s
    end

    def to_s
      to_a.to_s
    end

    def to_a
      @_symbols
    end

  end

end
