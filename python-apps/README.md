# Kafka demo

- Confluent Kafka admin UI: `http://localhost:9092`

```bash
docker-compose up --build -d
docker-compose stop python_consumer python_producer
docker exec -it kafka-demo_kafka_1 /bin/bash
  # recreate topic with 3 partitions (because docker compose create automatically with 1 partition)
  > kafka-topics --delete --bootstrap-server=localhost:9092 --topic=kafka-demo-topic
  > kafka-topics --create --bootstrap-server=localhost:9092 --topic=kafka-demo-topic --partitions=3
docker-compose start python_consumer python_producer
docker-compose logs -f --tail 100 python_consumer

# consumers (run this in multiple terminal at same time)
kafka-console-consumer --bootstrap-server=localhost:9092 --topic=kafka-demo-topic --group=kafka-demo-consumer-group

# producer (send messages with string "key;value". ";" is the separator of key and value. the key is used to determine for which partition the data will be sent)
kafka-console-producer --bootstrap-server=localhost:9092 --topic kafka-demo-topic --property parse.key=true --property key.separator=;

# monitor of consumer offsets
watch kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic=kafka-demo-topic

# monitor of consumer group
watch kafka-consumer-groups --bootstrap-server=localhost:9092 --group=kafka-demo-consumer-group --describe
```

Obs

```bash
# key 1234 | 123 | 23434r vai apontar para diferentes partitions

curl --request POST \
  --url 'http://localhost:5005/?key=1234' \
  --header 'Content-Type: application/json' \
  --data '{
  "msg": "asd"
}'

curl --request POST \
  --url 'http://localhost:5005/?key=123' \
  --header 'Content-Type: application/json' \
  --data '{
  "msg": "asd"
}'

curl --request POST \
  --url 'http://localhost:5005/?key=23434r' \
  --header 'Content-Type: application/json' \
  --data '{
  "msg": "asd"
}'
```
