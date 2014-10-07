require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Predictor::Insert do

  before do
    @insert = MegaHAL::Predictor::Insert.new
  end

  describe '#initialize' do

    it 'should start out empty' do
      expect(@insert.context.to_a).to eq([0, 0])
      expect(@insert.random).to eq(nil)
    end

  end

  describe '#observe' do

    it 'should infer a model from a decomposed sentence' do
      @insert.observe([1, 2, 3, 4], [5, 6, 7])
      @insert.context.reset!
      expect(@insert.random).to eq(nil)
      @insert.context << 5
      expect(@insert.random).to eq(1)
    end

  end

  describe '#generate' do

    it 'should predict a likely sequence of punctuation to repair a sentence' do
      @insert.observe([1, 2, 3, 4], [5, 6, 7])
      expect(@insert.generate([5, 6, 7])).to eq([1, 2, 3, 4])
    end

  end

end
