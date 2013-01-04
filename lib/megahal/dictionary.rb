# encoding: UTF-8

module MH

  class Dictionary

    def initialize
      @_index = [nil]
      @_lookup = {nil => 0}
    end

    def decompose(sentence)
      puncs, words = _segment(sentence)
      norms = _normalise(words)
      [puncs, norms, words].each { |a| self << a }
    end

    def reconstitute(puncs, words)
      sequence = puncs.zip(words).flatten.compact
      sequence.map { |symbol| self[symbol] }.join
    end

    def <<(symbol)
      return 0 if symbol.nil?
      symbol = symbol.to_sym if symbol.kind_of?(String)
      return _insert(symbol) unless symbol.kind_of?(Symbol)
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

    private

    def _segment(sentence, min = 5)
      sequence = sentence.split(/([[:word:]]+)/)
      chars = sequence.length <= min
      sequence = sentence.split(/()/) if chars
      sequence << '' if chars || sequence.last =~ /[[:word:]]+/
      sequence.unshift '' if chars || sequence.first =~ /[[:word:]]+/
      sequence.partition.with_index { |symbol, index| index.even? }
    end

    def _normalise(sequence)
      sequence.map { |symbol| UnicodeUtils.upcase(symbol) }
    end

    def _insert(sequence)
      sequence.map! { |symbol| self.<<(symbol) }
    end

  end

end
