# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe MH::Predictor::Repair do

  before do
    @repair = MH::Predictor::Repair.new
  end

  describe '#initialize' do

    it 'should start out empty' do
      @repair.context.to_a.should == [0, 0]
      @repair.random.should == nil
    end

  end

  describe '#observe' do

    it 'should infer a model to repair a sentence' do
      @repair.observe([1, 2, 3, 4], [5, 6, 7])
    end

  end

end
