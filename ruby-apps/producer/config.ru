require './app'

# reference: https://thoughtbot.com/blog/how-to-share-a-session-between-sinatra-and-rails

map '/karafka-web' do
  run Karafka::Web::App
end

map '/api' do
  run Sinatra::Application
end
