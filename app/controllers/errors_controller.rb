module Tamagotchi
  class ErrorsController
    def self.not_found
      [404, { 'Content-Type' => 'text/html' }, ['<h1>Not found</h1>']]
    end
  end
end
