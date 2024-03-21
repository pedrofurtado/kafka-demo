import json
from kafka3 import KafkaConsumer

KAFKA_DEMO_CONSUMER_HOST = 'kafka:9092'
KAFKA_DEMO_CONSUMER_TOPIC_NAME = 'kafka-demo-topic'
KAFKA_DEMO_CONSUMER_GROUP_ID = 'kafka-demo-consumer-group'
KAFKA_DEMO_CONSUMER_MAX_POLL = 1

def deserialize_message(m):
    m_utf8 = m.decode('utf-8')

    try:
        return json.loads(m_utf8)
    except json.decoder.JSONDecodeError as e:
        #print(f"deserialize_message -> Error {e} -> M {m}")
        return m_utf8

def initialize_consumer():
    print(f"Initialing kafka consumer | Host {KAFKA_DEMO_CONSUMER_HOST} | Topic {KAFKA_DEMO_CONSUMER_TOPIC_NAME} | Consumer group {KAFKA_DEMO_CONSUMER_GROUP_ID}")

    consumer = KafkaConsumer(
        KAFKA_DEMO_CONSUMER_TOPIC_NAME,
        group_id=KAFKA_DEMO_CONSUMER_GROUP_ID,
        bootstrap_servers=KAFKA_DEMO_CONSUMER_HOST,
        max_poll_records=KAFKA_DEMO_CONSUMER_MAX_POLL,
        value_deserializer=deserialize_message)

    print(f"Poll for messages ...")

    for message in consumer:
        print(f"Message read: {type(message.value).__name__} | {message.value}")

if __name__ == '__main__':
  initialize_consumer()
