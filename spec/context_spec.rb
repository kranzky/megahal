require File.join(File.dirname(__FILE__), 'spec_helper')

describe MH::Context do

  describe '#initialize' do

    it 'should start off empty' do
      context = MH::Context.new(5)
      context.size.should == 5
      context.to_a.should == [0, 0, 0, 0, 0]
    end

  end

  describe '#<<' do

    it 'should append and wrap' do
      context = MH::Context.new(2)
      context.to_a.should == [0, 0]
      context << 1
      context.to_a.should == [0, 1]
      context << 2
      context.to_a.should == [1, 2]
      context << 3
      context.to_a.should == [2, 3]
    end

    it 'should chain' do
      context = MH::Context.new(2)
      context << 1 << 2 << 3
      context.to_a.should == [2, 3]
    end

  end

  describe '#reset!' do

    it 'should reset to empty state' do
      context = MH::Context.new(3)
      context << 1 << 2 << 3
      context.to_a.should == [1, 2, 3]
      context.reset!
      context.to_a.should == [0, 0, 0]
    end

  end

  describe '#code' do
  end

end
