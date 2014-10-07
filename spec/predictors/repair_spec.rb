require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Predictor::Repair do

  before do
    @repair = MegaHAL::Predictor::Repair.new
  end

  describe '#initialize' do

    it 'should start out empty' do
      expect(@repair.context.to_a).to eq([0, 0])
      expect(@repair.random).to eq(nil)
    end

  end

end
