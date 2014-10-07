require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Context do

  before do
    @context = MegaHAL::Context.new(3)
  end

  describe '#initialize' do

    it 'should start off empty' do
      expect(@context.size).to eq(3)
      expect(@context.to_a).to eq([0, 0, 0])
    end

  end

  describe '#<<' do

    it 'should append and wrap' do
      @context << 1
      expect(@context.to_a).to eq([0, 0, 1])
      @context << 2
      expect(@context.to_a).to eq([0, 1, 2])
      @context << 3
      expect(@context.to_a).to eq([1, 2, 3])
    end

    it 'should chain' do
      @context << 1 << 2 << 3 << 4 << 5
      expect(@context.to_a).to eq([3, 4, 5])
    end

  end

  describe '#reset!' do

    it 'should reset to empty state' do
      @context << 1 << 2 << 3
      expect(@context.to_a).to eq([1, 2, 3])
      @context.reset!
      expect(@context.to_a).to eq([0, 0, 0])
    end

  end

  describe '#code' do

    it 'should represent itself in a compact form' do
      expect(@context.code.bytesize).to eq(3)
      @context << 2e10.to_i << 2e11.to_i << 2e12.to_i
      expect(@context.code.bytesize).to eq(17)
    end

  end

end
