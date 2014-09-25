module MegaHAL

  class Session

    attr_accessor :question
    attr_reader :memory

    def initialize
      @memory = Memory.new
    end

  end

end
