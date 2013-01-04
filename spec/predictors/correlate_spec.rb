# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe MH::Predictor::Correlate do

  before do
    @correlate = MH::Predictor::Correlate.new
  end

  describe '#initialize' do

    it 'should start out empty' do
      @correlate.context.to_a.should == [0, 0]
      @correlate.random.should == nil
    end

  end

end
