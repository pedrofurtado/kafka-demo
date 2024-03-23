$stdout.sync = true
$stderr.sync = true

ENV['KARAFKA_ENV'] ||= 'development'
Bundler.require(:default, ENV['KARAFKA_ENV'])

APP_LOADER = Zeitwerk::Loader.new
APP_LOADER.enable_reloading

APP_LOADER.setup
APP_LOADER.eager_load

class KarafkaApp < Karafka::App
  setup do |config|
    # list of all options:
    # > https://github.com/karafka/karafka/blob/master/lib/karafka/setup/config.rb
    # > https://karafka.io/docs/Librdkafka-Configuration/
    config.kafka = {
      'bootstrap.servers': 'kafka:9092',
      'allow.auto.create.topics': false
    }
    config.client_id = 'ruby_dashboard_inside_docker'
    config.initial_offset = 'earliest' # or 'latest'
    config.consumer_persistence = ENV['KARAFKA_ENV'] != 'development' # more details in https://karafka.io/docs/Development-vs-Production/#avoid-using-karafkas-reload-mode-in-production
  end
end

Karafka::Web.setup do |config|
  # You may want to set it per ENV. This value was randomly generated.
  config.ui.sessions.secret = '82a905c85911e6da2faf02801fc4bd9bcff43cc0ee8320c0695d8e319bc76d23'
end

Karafka::Web.enable!
