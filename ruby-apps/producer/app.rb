require 'sinatra'
require 'sinatra/reloader'
require_relative 'karafka'

configure do
  enable :reloader
end

get '/' do
  'Homepage - Kafka demo - Ruby producer API'
end

def send_sync(k_override = nil)
  k = k_override || SecureRandom.uuid
  payload = { "my": "msg" }
  report = Karafka.producer.produce_sync(topic: 'my_ruby_topic', payload: payload.to_json, key: k)
  msg = "[PRODUCER] send_sync topic=#{report.topic_name} key=#{k} offset=#{report.offset} partition=#{report.partition} payload=#{payload}"
  Karafka.logger.info msg
  msg
end

get '/send_sync' do
  send_sync
end

get '/send_sync_repeated' do
  results = []
  3.times do
    results << send_sync('5ad62daf-04f3-4a9f-8d3f-9bbd894b11fc')
  end

  results.join("<br>")
end
