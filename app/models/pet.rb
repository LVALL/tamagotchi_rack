module Tamagotchi
  class Pet
    attr_accessor :name, :dreams, :ignore, :image

    def initialize(req:, name:, params:, ignore:, image:, dreams:)
      @req = req.path
      @name = name
      @reaction = ''
      @params = params
      @ignore = ignore
      @image = image
      @dreams = dreams
    end

    def params
      @params.each_with_object(@params) do |(key, _), hash|
        hash[key] = 100 if hash[key] > 100
        hash[key] = 0 if hash[key].negative?
      end
    end

    def play
      @reaction = 'I like to play! '
      @params[:happiness] += 20
      @params[:health] += 5
      @params[:appetite] -= 5
      @ignore[:play] = 0
      @image = 'play.jpg'
      check
    end

    def eat
      if @params[:appetite] >= 100
        @reaction = 'I don`t want to eat. '
        @image = 'wtf.jpg'
        @params[:happiness] -= 10
      else
        @reaction = 'OmNomNom. '
        @params[:appetite] += 10
        @params[:health] += 5
        @params[:happiness] += 5
        @params[:thirst] -= 10
        @image = 'eat.jpg'
        @ignore[:eat] = 0
      end
      check
    end

    def drink
      if @params[:thirst] >= 100
        @reaction = 'I don`t want to drink. '
        @image = 'wtf.jpg'
        @params[:happiness] -= 10
      else
        @reaction = 'Thanks. '
        @image = 'drink.jpg'
        @params[:health] += 5
        @params[:happiness] += 5
        @params[:thirst] += 10
        @ignore[:drink] = 0
      end
      check
    end

    def heal
      @reaction = 'I`m alive, OmG. '
      @params[:health] += 50
      @params[:happiness] += 10
      @params[:thirst] -= 10
      @params[:appetite] += 10
      @image = 'heal.jpg'
      reset_ignore
      check
    end

    def sleep
      @reaction = '💤💤💤'
      @dreams = true
      @image = 'sleep.jpg'
      reset_ignore
      @params.each_with_object(@params) do |(key, _), hash|
        hash[key] += 20
      end
    end

    def awake
      @reaction = 'Hello, new day))) '
      @dreams = false
      @image = 'awake.jpg'
      increase_ignore
    end

    def reset_ignore
      @ignore.each_with_object(@ignore) do |(key, _), hash|
        hash[key] = 0
      end
    end

    def increase_ignore
      if @params[:appetite] < 100
        @reaction += 'I want to eat. '
        @ignore[:eat] += 1
      end
      if @params[:thirst] < 100
        @reaction += 'I need some water. '
        @ignore[:drink] += 1
      end
      if @params[:happiness] < 80 || @params[:health] < 80
        if @params[:health] <= 50 || @params[:happiness] <= 50
          @reaction += 'I`m bad, I need a doctor... '
        elsif check_ignore.size.zero?
          @reaction += 'I want to play. '
          @ignore[:play] += 1
        end
      end
    end

    def check_ignore
      ignore
      @ignore.select { |_, value| value >= 5 }
    end

    def check
      bad_params = @params.select { |_, value| value.zero? || value <= 50 }
      @params[:health] -= 10 if bad_params.size.positive? || bad_params.size > 1

      @params[:happiness] -= 10 if @params[:appetite] < 50 || @params[:thirst] < 50
      @params[:happiness] -= 5 if check_ignore.size.positive?
      @params[:health] -= 10 if check_ignore.size > 1

      increase_ignore
      params
    end

    def dead?
      check
      params_zero = @params.select { |_, value| value.zero? }
      @params[:health].zero? || params_zero.size > 1
    end

    def speak
      case @req
      when '/pet'
        @reaction = 'Ohh, hello my new friend 💚💚💚. '
        check
      when '/play' then play
      when '/eat' then eat
      when '/drink' then drink
      when '/heal' then heal
      when '/sleep' then sleep
      when '/awake' then awake
      end
      @reaction
    end
  end
end
