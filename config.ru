require './app/application'

use Rack::Reloader
use Rack::Auth::Basic do |username, password|
  username == 'user'
  password == 'password'
end

run Rack::Cascade.new([Rack::File.new('public'), Tamagotchi::Application])
