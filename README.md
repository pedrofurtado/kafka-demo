# Kafka demo

- Confluent Kafka admin UI: `http://localhost:9092`

```bash
docker-compose up --build -d
docker exec -it kafka-demo_kafka_1 /bin/bash

# create topic
kafka-topics --create --bootstrap-server=localhost:9092 --topic=testefurtado --partitions=3

# consumers (run this in multiple terminal at same time)
kafka-console-consumer --bootstrap-server=localhost:9092 --topic=testefurtado --group=xxx

# producer (send messages with string "key;value". ";" is the separator of key and value. the key is used to determine for which partition the data will be sent)
kafka-console-producer --bootstrap-server=localhost:9092 --topic testefurtado --property parse.key=true --property key.separator=;

# monitor of consumer offsets
watch kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic=testefurtado

# monitor of consumer group
kafka-consumer-groups --bootstrap-server=localhost:9092 --group=xxx --describe
```
