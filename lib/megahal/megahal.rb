# encoding: UTF-8

require 'megahal/context'
require 'megahal/distribution'
require 'megahal/model'

class MegaHAL
  
  def test

    model = MH::Model.new
    model.context = MH::Context.new
    model.context << 'x'
    model.context << 'y'
    model << 'a'
    model << 'b'
    model << 'a'
    model << 'a'

  end

  def observe(sentence)
    puncs, words = _decompose(sentence)
    raise unless puncs.length == words.length + 1
    symbols = _normalise(words)
    puncs.zip(symbols).flatten.compact.join
  end

  private

  def _decompose(sentence, min = 5)
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

end
