module Tamagotchi
  class Error
    def initialize(display:, text:)
      @display = display
      @text = text
    end

    def display_error
      @display
    end

    def text_error
      @text
    end
  end
end
