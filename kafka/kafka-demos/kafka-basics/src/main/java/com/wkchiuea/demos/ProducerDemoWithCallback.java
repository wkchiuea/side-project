package com.wkchiuea.demos;

import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class ProducerDemoWithCallback {

    private static final Logger logger = LoggerFactory.getLogger(ProducerDemoWithCallback.class.getSimpleName());

    public static void main(String[] args) {
        logger.info("=== Producer With Callback");

        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "127.0.0.1:9092");
        properties.setProperty("key.serializer", StringSerializer.class.getName());
        properties.setProperty("value.serializer", StringSerializer.class.getName());

        properties.setProperty("batch.size", "400");
//        properties.setProperty("partitioner.class", RoundRobinPartitioner.class.getName());

        KafkaProducer<String, String> producer = new KafkaProducer<>(properties);
        for (int j=0; j<10; ++j) {

            for (int i=0; i<30; ++i) {

                ProducerRecord<String, String> producerRecord = new ProducerRecord<>("demo_java", "hello world " + i);
                producer.send(producerRecord, new Callback() {
                    @Override
                    public void onCompletion(RecordMetadata recordMetadata, Exception e) {
                        if (e == null) {
                            logger.info("Received new metadata \n"
                                    + "Topic: " + recordMetadata.topic() + "\n"
                                    + "Partition: " + recordMetadata.partition() + "\n"
                                    + "Offset: " + recordMetadata.offset() + "\n"
                                    + "Timestamp: " + recordMetadata.timestamp()
                            );
                        } else {
                            logger.error("Error while producing", e);
                        }
                    }
                });

            }

            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }

        }

        producer.flush();

        producer.close();


    }

}
