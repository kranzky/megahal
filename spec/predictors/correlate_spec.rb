require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Predictor::Correlate do

  before do
    @correlate = MegaHAL::Predictor::Correlate.new
  end

  describe '#initialize' do

    it 'should start out empty' do
      expect(@correlate.context.to_a).to eq([0, 0])
      expect(@correlate.random).to eq(nil)
    end

  end

end
