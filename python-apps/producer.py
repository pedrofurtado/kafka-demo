import json
from flask import Flask, request, jsonify
from kafka3 import KafkaProducer

KAFKA_DEMO_PRODUCER_HOST = 'kafka:9092'
KAFKA_DEMO_PRODUCER_TOPIC_NAME = 'kafka-demo-topic'

app = Flask(__name__)

@app.route('/', methods=['GET'])
def instruction():
    return 'Python producer', 200

@app.route('/', methods=['POST'])
def homepage():
    body_json = None
    key_for_partition = request.args.get('key', '')

    try:
      body_json = request.get_json(force=True)
    except Exception as e:
      body_json = None

    producer = KafkaProducer(bootstrap_servers=KAFKA_DEMO_PRODUCER_HOST, acks='all',key_serializer=str.encode,value_serializer=lambda v: json.dumps(v).encode('utf-8'))
    producer.send(KAFKA_DEMO_PRODUCER_TOPIC_NAME, key=key_for_partition, value=body_json)

    return jsonify(body_json), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
