require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Predictor::Base do

  before do
    @base = MegaHAL::Predictor::Base.new(3)
  end

  describe '#initialize' do

    it 'should start out empty' do
      @base.context.to_a.should == [0, 0, 0]
      @base.random.should == nil
    end

  end

  describe '#<<' do

    it 'should append to the current context' do
      @base << 1
      @base.random.should == 1
      @base.context << 1
      @base.random.should == nil
      @base.context.reset!
      @base.random.should == 1
    end

  end

end
