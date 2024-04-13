1. run the below command to get the kafka cluster id  
`docker container run -it --rm --name kafka-cli bitnami/kafka:3.4 kafka-storage.sh random-uuid`
2. set the cluster id to docker-compose.yml : KAFKA_KRAFT_CLUSTER_ID  
3. run `docker compose up` to launch the cluster  
4. create a kafka client to connect to the cluster  
`docker container run -it --rm --network kafka_kafka-network --name kafka-cli bitnami/kafka:3.4 /bin/bash`
5. in the kafka-cli, use alias to set the bootstrap server to prevent repeat typing  
`alias kafka-topics="kafka-topics.sh --bootstrap-server kafka101:9092"`
6. to remove all cluster-related containers and volumes, run   
`docker compose rm -fsv`  