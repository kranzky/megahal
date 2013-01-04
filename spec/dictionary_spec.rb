# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe MH::Dictionary do

  before do
    @dictionary = MH::Dictionary.new
  end

  describe '#initialize' do

    it 'should be created with the non-symbol' do
      @dictionary.to_a.should == [nil]
      @dictionary[nil].should == 0
      @dictionary[0].should == nil
    end

  end

  describe '#decompose' do

    it 'should convert a sentence to three arrays of ids' do
      puncs, norms, words = @dictionary.decompose('The cat sat on the mat!')
      puncs.length.should == 7
      norms.length.should == puncs.length - 1
      words.length.should == norms.length
      @dictionary[norms.first].should == :THE
      @dictionary[words.last].should == :mat
    end

    it 'should handle punctuation' do
      puncs, norms, words = @dictionary.decompose('?!?is this a test')
      @dictionary[puncs.first].to_s.should == '?!?'
    end

    it 'should handle utf characters' do
      puncs, norms, words = @dictionary.decompose('See the ümlaut!')
      @dictionary[words[2]].to_s.should == 'ümlaut'
    end

    it 'should handle chinese' do
      puncs, norms, words = @dictionary.decompose('有什么需要我帮你的？')
      words.length.should == 10
      @dictionary[words.last].to_s.should == '？'
    end

  end

  describe '#reconstitute' do

    it 'should return a sentence from two arrays of ids' do
      puncs, norms, words = @dictionary.decompose('The cat sat on the mat!')
      @dictionary.reconstitute(puncs, words).should == 'The cat sat on the mat!'
    end

  end

  describe '#map!' do

    it 'should append a sequence' do
      sequence = [:one, :two, :three]
      @dictionary << sequence
      @dictionary[:two].should == 2
      @dictionary[2].should == :two
    end

  end

  describe '#<<' do

    it 'should return a new id when appending a new symbol' do
      @dictionary[:one].should == nil
      id = @dictionary << :one
      id.should == 1
      @dictionary[:one].should == 1
    end

  end

  describe '#[]' do

    it 'should return the symbol by its id' do
      @dictionary[1].should == nil
      @dictionary << :one
      @dictionary[1].should == :one
    end

  end

end
