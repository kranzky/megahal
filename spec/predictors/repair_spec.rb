require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Predictor::Repair do

  before do
    @repair = MegaHAL::Predictor::Repair.new
  end

  describe '#initialize' do

    it 'should start out empty' do
      @repair.context.to_a.should == [0, 0]
      @repair.random.should == nil
    end

  end

end
