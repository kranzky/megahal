# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe MH::Predictor::Insert do

  before do
    @insert = MH::Predictor::Insert.new
  end

  describe '#initialize' do

    it 'should start out empty' do
      @insert.context.to_a.should == [0, 0]
      @insert.random.should == nil
    end

  end

  describe '#observe' do

    it 'should infer a model from a decomposed sentence' do
      @insert.observe([1, 2, 3, 4], [5, 6, 7])
      @insert.context.reset!
      @insert.random.should == nil
      @insert.context << 5
      @insert.random.should == 1
    end

  end

  describe '#generate' do

    it 'should predict a likely sequence of punctuation to repair a sentence' do
      @insert.observe([1, 2, 3, 4], [5, 6, 7])
      @insert.generate([5, 6, 7]).should == [1, 2, 3, 4]
    end

  end

end
