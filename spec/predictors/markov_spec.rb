require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Predictor::Markov do

  before do
    @markov = MegaHAL::Predictor::Markov.new(3)
  end

  describe '#initialize' do

    it 'should start out empty' do
    end

  end

end
