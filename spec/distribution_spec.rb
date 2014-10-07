require File.join(File.dirname(__FILE__), 'spec_helper')

describe MegaHAL::Distribution do

  before do
    @distribution = MegaHAL::Distribution.new
  end

  describe '#initialize' do

    it 'should start out blank' do
      expect(@distribution.to_a).to eq([])
      expect(@distribution.random).to eq(nil)
    end

  end

  describe '#<<' do

    it 'should increase the count of an appended id' do
      @distribution << 1
      expect(@distribution.to_a.first).to eq({id: 1, probability: 1})
      @distribution << 2
      expect(@distribution.to_a.length).to eq(2)
      expect(@distribution.to_a.first).to eq({id: 1, probability: 0.5})
    end

  end

  describe '#|' do

    it 'should or two distributions together' do
      other = MegaHAL::Distribution.new
      @distribution << 1
      @distribution << 2
      other << 2
      other << 3
      retval = @distribution | other
      expect(retval.to_a.length).to eq(3)
      expect(retval.to_a[0]).to eq({ id: 1, probability: 0.25 })
      expect(retval.to_a[1]).to eq({ id: 2, probability: 0.5 })
      expect(retval.to_a[2]).to eq({ id: 3, probability: 0.25 })
    end

  end

  describe '#&' do

    it 'should and two distributions together' do
      other = MegaHAL::Distribution.new
      @distribution << 1
      @distribution << 2
      other << 2
      other << 3
      retval = @distribution & other
      expect(retval.to_a.length).to eq(1)
      expect(retval.to_a[0]).to eq({ id: 2, probability: 1.0 })
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
      expect(counts.keys.sort).to eq([1, 2])
      expect(counts[1]).to be_within(50).of(666)
      expect(counts[2]).to be_within(50).of(333)
    end

  end

  describe '#max' do

    it 'should return the most common id' do
      @distribution << 1
      @distribution << 1
      @distribution << 2
      expect(@distribution.max).to eq(1)
      @distribution << 2
      @distribution << 2
      expect(@distribution.max).to eq(2)
    end

    it 'should select randomly if two or more ids have the same max count' do
      @distribution << 1
      @distribution << 2
      counts = Hash.new(0)
      1000.times do
        counts[@distribution.max] += 1
      end
      expect(counts.keys.sort).to eq([1, 2])
      expect(counts[1]).to be_within(50).of(500)
      expect(counts[2]).to be_within(50).of(500)
    end

  end

end
