require 'erb'
require './app/models/pet'
require './app/models/error'

module Tamagotchi
  class PetController
    class << self
      def pet(req)
        if req.params.key?('name')
          @pet = create_pet(req)
          if check_name
            return_page(status: 201, view: 'pet')
          else
            return_error('The name must contain at least 1 character')
            return_page(status: 422, view: 'page')
          end
        end
      end

      def action(req)
        @pet = return_pet(req)
        if @pet.dead?
          return_error('Your pet die')
          return_page(status: 201, view: 'page')
        else
          return_page(status: 201, view: 'pet')
        end
      end

      def return_error(text)
        @error = Error.new(display: true, text: text)
      end

      def return_page(status:, view:)
        path = "./app/views/#{view}.html.erb"
        template = ERB.new(File.read(path)).result(binding)
        [status, { 'Content-Type' => 'text/html' }, [template]]
      end

      def create_pet(req)
        @pet_name = req['name'] || ''
        params_hash = { appetite: 80, health: 100, happiness: 100, thirst: 90 }
        ignore_hash = { eat: 0, drink: 0, play: 0, sleep: 0 }
        Pet.new(req: req, name: @pet_name, params: params_hash,
                ignore: ignore_hash, image: 'hello.jpg', dreams: false)
      end

      def return_pet(req)
        Pet.new(req: req, name: @pet_name, params: @pet.params,
                ignore: @pet.ignore, image: @pet.image, dreams: @pet.dreams)
      end

      def check_name
        @pet_name.delete(' ').size >= 1
      end
    end
  end
end
