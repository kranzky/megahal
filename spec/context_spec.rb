require File.join(File.dirname(__FILE__), 'spec_helper')

describe MH::Context do

  before do
    @context = MH::Context.new(3)
  end

  describe '#initialize' do

    it 'should start off empty' do
      @context.size.should == 3
      @context.to_a.should == [0, 0, 0]
    end

  end

  describe '#<<' do

    it 'should append and wrap' do
      @context << 1
      @context.to_a.should == [0, 0, 1]
      @context << 2
      @context.to_a.should == [0, 1, 2]
      @context << 3
      @context.to_a.should == [1, 2, 3]
    end

    it 'should chain' do
      @context << 1 << 2 << 3 << 4 << 5
      @context.to_a.should == [3, 4, 5]
    end

  end

  describe '#reset!' do

    it 'should reset to empty state' do
      @context << 1 << 2 << 3
      @context.to_a.should == [1, 2, 3]
      @context.reset!
      @context.to_a.should == [0, 0, 0]
    end

  end

  describe '#code' do

    it 'should represent itself in a compact form' do
      @context.code.bytesize.should == 3
      @context << 2e10.to_i << 2e11.to_i << 2e12.to_i
      @context.code.bytesize.should == 17
    end

  end

end
