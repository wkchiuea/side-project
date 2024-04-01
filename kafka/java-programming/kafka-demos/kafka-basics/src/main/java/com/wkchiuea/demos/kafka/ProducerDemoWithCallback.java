package com.wkchiuea.demos.kafka;

import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class ProducerDemoWithCallback {

    private static final Logger logger = LoggerFactory.getLogger(ProducerDemoWithCallback.class.getSimpleName());

    public static void main(String[] args) {

        logger.info("Kafka Producer");

        // create Producer Properties
        Properties properties = new Properties();

        properties.setProperty("bootstrap.servers", "127.0.0.1:9092"); // connect to localhost

//        properties.setProperty("bootstrap.servers", ""); // connect to playground
//        properties.setProperty("security.protocol", "");
//        properties.setProperty("sasl.jaas.config", "");
//        properties.setProperty("sasl.mechanism", "PLAIN");

        // set producer properties
        properties.setProperty("key.serializer", StringSerializer.class.getName());
        properties.setProperty("value.serializer", StringSerializer.class.getName());

        properties.setProperty("practitioner.class", RoundRobinPartitioner.class.getName());

        // create Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(properties);
        // crate Producer Record
        ProducerRecord<String, String> producerRecord = new ProducerRecord<>("demo_java", "hello world");
        ProducerRecord<String, String> producerRecordWithKey = new ProducerRecord<>("demo_java", "id_1", "hello world");
        // send data -- asynchronously
        producer.send(producerRecord, new Callback() {
            @Override
            public void onCompletion(RecordMetadata metadata, Exception e) {
                // executes every time a record successfully sent or an exception is thrown
                if (e == null) {
                    logger.info("Received new metadata \n" +
                                "Topic: " + metadata.topic() + "\n" +
                                "Offset: " + metadata.offset() + "\n" +
                                "Timestamp: " + metadata.timestamp());
                } else {
                    logger.error("Error while producing", e);
                }
            }
        });

        // flush and close producer
        producer.flush(); // tell producer to send all data and block until done -- synchronous
        producer.close(); // will also flush when close




    }
}
