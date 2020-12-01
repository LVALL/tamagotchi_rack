require './app/controllers/errors_controller'
require './app/controllers/pages_controller'
require './app/controllers/pet_controller'
require './app/models/pet'

module Tamagotchi
  class Application
    def self.call(env)
      req = Rack::Request.new(env)
      return PagesController.create if req.get? && req.path == '/'

      if req.post?
        return PetController.pet(req) if req.path == '/pet'

        return PetController.action(req)
      end

      ErrorsController.not_found
    end
  end
end
