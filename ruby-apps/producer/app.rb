require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :reloader
end

get '/' do
  'Homepage - Kafka demo - Ruby producer'
end
