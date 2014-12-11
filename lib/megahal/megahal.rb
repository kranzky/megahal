require 'byebug'

class MegaHAL
  # Create a new MegaHAL instance, loading the :default personality.
  def initialize
  end

  # Wipe MegaHAL's brain. Note that this wipes the personality too, allowing you
  # to begin from a truly blank slate.
  def clear
  end

  def self.add_personality(name, data)
    @@personalities ||= {}
    @@personalities[name.to_sym] = data.each_line.to_a.map(&:strip)
  end

  # Returns an array of MegaHAL personalities.
  #
  # @return [Array] A list of symbols representing the available personalities.
  def self.list
    @@personalities ||= {}
    @@personalities.keys
  end

  # Loads the specified personality. Will raise an exception if the personality
  # parameter isn't one of those returned by #list. Note that this will clear
  # MegaHAL's brain first.
  #
  # @param [Symbol] personality The personality to be loaded.
  def become(personality=:default)
  end

  # Generate a reply to the user's input. If the learn parameter is set to true,
  # MegaHAL will also learn from what the user said.
  # 
  # @param [String] input A string that represents the user's input.
  # @param [Bool] learn Whether or not MegaHAL should learn the input.
  # @param [String] error The default reply, which will be used when no
  #                       suitable reply can be formed.
  #
  # @return [String] MegaHAL's reply to the user's input, or the error
  #                  string if no reply could be formed.
  def reply(input, learn=true, error="I don't know enough to answer you yet!")
  end

  # Save MegaHAL's brain to the specified binary file.
  #
  # @param [String] filename The brain file to be saved.
  #
  # @return A boolean value indicating whether or not the save was successful.
  def save(filename)
  end

  # Load a brain that has previously been saved.
  #
  # @param [String] filename The brain file to be loaded.
  #
  # @return A boolean value indicating whether or not the load was successful.
  def load(filename)
  end

  # Merge a brain that has previously been saved. This is similar to #load, but
  # doesn't clear MegaHAL's brain first. This makes it easy to merge several
  # brain files together.
  #
  # @param [String] filename The brain file to be merged.
  #
  # @return A boolean value indicating whether or not the merge was successful.
  def merge(filename)
  end

  # Train MegaHAL with the contents of the specified file, which should be plain
  # text with one sentence per line.  Note that it takes MegaHAL about one
  # second to process about 500 lines, so large files may cause the process to
  # block for a while. Lines that have more than maximum_words will be skipped.
  #
  # @param [String] filename The text file to be used for training.
  # @param [Fixnum] maximum_words An upper limit on the size of a single line in
  #                               the training file; lines longer than this will
  #                               be ignored.
  #
  # @return A boolean value indicating whether or not the training was successful.
  def train(filename, maximum_words=42)
  end
end
