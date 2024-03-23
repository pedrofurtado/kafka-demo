class MyRubyTopicConsumer < ApplicationConsumer
  def consume
    Karafka.logger.info "[CONSUMER] Consuming #{messages.size} messages from TOPIC #{topic.name}" # #{topic.to_h}
    messages.each do |message|
      Karafka.logger.info "[CONSUMER] message partition=#{message.metadata.partition} offset=#{message.metadata.offset} key=#{message.metadata.key} payload=#{message.payload}"
    end
  end

  def revoked
    Karafka.logger.info '[CONSUMER] Run anything upon partition being revoked'
  end

  def shutdown
    Karafka.logger.info '[CONSUMER] Define here any teardown things you want when Karafka server stops'
  end
end
