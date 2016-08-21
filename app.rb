require 'sinatra'
require 'sinatra/reloader'

MRBC = '../mruby/bin/mrbc'

get '/' do
  @message =  `#{MRBC} --version`
  erb :index
end

get '/version' do
  `#{MRBC} --version`
end


post '/compile' do
  src = param[:s]
end

