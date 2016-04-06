require 'tempfile'

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MegaHAL do

  let(:megahal) { MegaHAL.new }

  describe "#list" do
    it "returns an array of all personalities" do
    end
  end

  describe "#inspect" do
    it "doesn't return a massive string" do
      expect(megahal.inspect.length).to be < 100
      expect(megahal.inspect).to match(/MegaHAL/)
    end
  end

  describe "#clear" do
    it "clears all internal state" do
      expect(megahal.instance_variables.length).to eq(8)
      megahal.clear
      megahal.reply("one two three four five")
      expect(megahal.instance_variable_get(:@dictionary).length).to eq(15)
      expect(megahal.instance_variable_get(:@brain).length).to eq(33)
      expect(megahal.instance_variable_get(:@seed).count(1)).to be > 0
      expect(megahal.instance_variable_get(:@fore).count(0)).to be > 0
      expect(megahal.instance_variable_get(:@back).count(0)).to be > 0
      expect(megahal.instance_variable_get(:@case).count(13)).to be > 0
      expect(megahal.instance_variable_get(:@punc).count(27)).to be > 0
      megahal.clear
      expect(megahal.instance_variable_get(:@dictionary).length).to eq(3)
      expect(megahal.instance_variable_get(:@brain).length).to eq(0)
      expect(megahal.instance_variable_get(:@seed).count(1)).to eq(0)
      expect(megahal.instance_variable_get(:@fore).count(0)).to eq(0)
      expect(megahal.instance_variable_get(:@back).count(0)).to eq(0)
      expect(megahal.instance_variable_get(:@case).count(13)).to eq(0)
      expect(megahal.instance_variable_get(:@punc).count(27)).to eq(0)
    end
  end

  describe "#become" do
    it "switches to another personality" do
      expect(megahal.reply("holmes")).to_not match(/watson/i)
      megahal.become(:sherlock)
      expect(megahal.reply("holmes")).to match(/watson/i)
    end
  end

  describe "#reply" do
    it "swaps keywords" do
      expect(megahal.reply("why")).to match(/because/i)
    end
  end

  describe "#save" do
    it "saves the brain" do
      begin
        file = Tempfile.new('megahal_spec')
        megahal.clear
        megahal.reply("one two three four five")
        megahal.save(file.path)
        megahal.clear
        expect(megahal.reply("")).to eq("...")
        megahal.load(file.path)
        expect(megahal.reply("")).to eq("one two three four five")
      ensure
        file.close
        file.unlink
      end
    end
  end

  describe "#train" do
    it "learns from a text file" do
      megahal.clear
      begin
        file = Tempfile.new('megahal_spec')
        file.write("one two three four five")
        file.close
        expect(megahal.reply("")).to eq("...")
        megahal.train(file.path)
        expect(megahal.reply("")).to eq("one two three four five")
      ensure
        file.unlink
      end
    end
  end

end
