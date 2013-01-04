# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe MH::Distribution do

  before do
    @distribution = MH::Distribution.new
  end

  describe '#initialize' do

    it 'should start out blank' do
      @distribution.to_a.should == []
      @distribution.random.should == nil
    end

  end

  describe '#<<' do

    it 'should increase the count of an appended id' do
      @distribution << 1
      @distribution.to_a.first.should == {id: 1, probability: 1}
      @distribution << 2
      @distribution.to_a.length.should == 2
      @distribution.to_a.first.should == {id: 1, probability: 0.5}
    end

  end

  describe '#random' do

    it 'should return a random id based on frequencies' do
      @distribution << 1
      @distribution << 1
      @distribution << 2
      counts = Hash.new(0)
      1000.times do
        counts[@distribution.random] += 1
      end
      counts.keys.sort.should == [1, 2]
      counts[1].should be_within(50).of(666)
      counts[2].should be_within(50).of(333)
    end

  end

end
