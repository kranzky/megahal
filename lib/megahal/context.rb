# encoding: UTF-8

module MH

  class Context

    def initialize
      @_symbols = []
    end

    def <<(symbol)
      @_symbols << symbol.to_sym
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
