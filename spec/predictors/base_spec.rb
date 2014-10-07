require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Predictor::Base do

  before do
    @base = MegaHAL::Predictor::Base.new(3)
  end

  describe '#initialize' do

    it 'should start out empty' do
      expect(@base.context.to_a).to eq([0, 0, 0])
      expect(@base.random).to eq(nil)
    end

  end

  describe '#<<' do

    it 'should append to the current context' do
      @base << 1
      expect(@base.random).to eq(1)
      @base.context << 1
      expect(@base.random).to eq(nil)
      @base.context.reset!
      expect(@base.random).to eq(1)
    end

  end

end
