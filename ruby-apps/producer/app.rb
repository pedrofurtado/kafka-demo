require 'sinatra'
require 'sinatra/reloader'
require_relative 'karafka'

configure do
  enable :reloader
end

get '/' do
  'Homepage - Kafka demo - Ruby producer API'
end

get '/send_sync' do
  k = SecureRandom.uuid
  payload = { "my": "msg" }
  report = Karafka.producer.produce_sync(topic: 'my_ruby_topic', payload: payload.to_json, key: k)
  msg = "[PRODUCER] send_sync topic=#{report.topic_name} key=#{k} offset=#{report.offset} partition=#{report.partition} payload=#{payload}"
  Karafka.logger.info msg
  msg
end
