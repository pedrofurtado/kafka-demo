$stdout.sync = true
$stderr.sync = true

ENV['KARAFKA_ENV'] ||= 'development'
Bundler.require(:default, ENV['KARAFKA_ENV'])

APP_LOADER = Zeitwerk::Loader.new
APP_LOADER.enable_reloading

%w[
  app/consumers
].each { |dir| APP_LOADER.push_dir(dir) }

APP_LOADER.setup
APP_LOADER.eager_load

class KarafkaApp < Karafka::App
  setup do |config|
    # list of all options:
    # > https://github.com/karafka/karafka/blob/master/lib/karafka/setup/config.rb
    # > https://karafka.io/docs/Librdkafka-Configuration/
    config.kafka = {
      'bootstrap.servers': 'kafka:9092',
      'allow.auto.create.topics': false,
      'enable.idempotence': true # more details in https://karafka.io/docs/WaterDrop-Configuration/#idempotence
    }
    config.client_id = 'ruby_producers_inside_docker'
    config.initial_offset = 'earliest' # or 'latest'
    config.consumer_persistence = ENV['KARAFKA_ENV'] != 'development' # more details in https://karafka.io/docs/Development-vs-Production/#avoid-using-karafkas-reload-mode-in-production
  end

  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      Karafka.logger,
      log_messages: false
    )
  )

  routes.draw do
    topic :my_ruby_topic do
      config(partitions: 3)
      consumer MyRubyTopicConsumer
    end
  end
end

Karafka::Web.setup do |config|
  # You may want to set it per ENV. This value was randomly generated.
  config.ui.sessions.secret = 'cb2866f6e8e3748e98dea648e284c9d11b1786f844327a6b9dca0cec647216f3'
  config.tracking.interval = 5_000
  config.tracking.active = true
  config.processing.active = true
end

Karafka::Web.enable!

