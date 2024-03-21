class MyRubyTopicConsumer < ApplicationConsumer
  def consume
    puts "Consuming #{messages.size} messages from TOPIC #{topic.name}" # #{topic.to_h}
    messages.each do |message|
      puts "MESSAGE partition=#{message.metadata.partition} offset=#{message.metadata.offset} key=#{message.metadata.key} payload=#{message.payload}"
    end
  end

  def revoked
    puts 'Run anything upon partition being revoked'
  end

  def shutdown
    puts 'Define here any teardown things you want when Karafka server stops'
  end
end
