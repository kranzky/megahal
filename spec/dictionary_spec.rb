require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Dictionary do

  before do
    @dictionary = MegaHAL::Dictionary.new
  end

  describe '#initialize' do

    it 'should be created with the non-symbol' do
      expect(@dictionary.to_a).to eq([nil])
      expect(@dictionary[nil]).to eq(0)
      expect(@dictionary[0]).to eq(nil)
    end

  end

  describe '#decompose' do

    it 'should convert a sentence to three arrays of ids' do
      puncs, norms, words = @dictionary.decompose('The cat sat on the mat!')
      expect(puncs.length).to eq(7)
      expect(norms.length).to eq(puncs.length - 1)
      expect(words.length).to eq(norms.length)
      expect(@dictionary[norms.first]).to eq(:THE)
      expect(@dictionary[words.last]).to eq(:mat)
    end

    it 'should handle punctuation' do
      puncs, norms, words = @dictionary.decompose('?!?is this a test')
      expect(@dictionary[puncs.first].to_s).to eq('?!?')
    end

    it 'should handle utf characters' do
      puncs, norms, words = @dictionary.decompose('See the ümlaut!')
      expect(@dictionary[words[2]].to_s).to eq('ümlaut')
    end

    it 'should handle chinese' do
      puncs, norms, words = @dictionary.decompose('有什么需要我帮你的？')
      expect(words.length).to eq(10)
      expect(@dictionary[words.last].to_s).to eq('？')
    end

    it 'should strip whitespace' do
      puncs, norms, words = @dictionary.decompose('  "this is a test"  ')
      expect(puncs.length).to eq(5)
      expect(@dictionary[puncs.first].to_s).to eq('"')
      expect(@dictionary[puncs.last].to_s).to eq('"')
    end

    it 'should convert short sentences to chars' do
      puncs, norms, words = @dictionary.decompose('test')
      expect(norms.length).to eq(4)
    end

  end

  describe '#reconstitute' do

    it 'should return a sentence from two arrays of ids' do
      puncs, norms, words = @dictionary.decompose('The cat sat on the mat!')
      expect(@dictionary.reconstitute(puncs, words)).to eq('The cat sat on the mat!')
    end

  end

  describe '#map!' do

    it 'should append a sequence' do
      sequence = [:one, :two, :three]
      @dictionary << sequence
      expect(@dictionary[:two]).to eq(2)
      expect(@dictionary[2]).to eq(:two)
    end

  end

  describe '#<<' do

    it 'should return a new id when appending a new symbol' do
      expect(@dictionary[:one]).to eq(nil)
      id = @dictionary << :one
      expect(id).to eq(1)
      expect(@dictionary[:one]).to eq(1)
    end

  end

  describe '#[]' do

    it 'should return the symbol by its id' do
      expect(@dictionary[1]).to eq(nil)
      @dictionary << :one
      expect(@dictionary[1]).to eq(:one)
    end

  end

end
