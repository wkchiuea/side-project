package com.wkchiuea.demos;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.CooperativeStickyAssignor;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.errors.WakeupException;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.util.Arrays;
import java.util.Properties;

public class ConsumerDemoWithShutdown {

    private static final Logger logger = LoggerFactory.getLogger(ConsumerDemoWithShutdown.class.getSimpleName());

    public static void main(String[] args) {
        logger.info("=== Simple Consumer with shutdown");

        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "127.0.0.1:9092");
        properties.setProperty("key.deserializer", StringDeserializer.class.getName());
        properties.setProperty("value.deserializer", StringDeserializer.class.getName());

        String groupId = "my-app";
        properties.setProperty("group.id", groupId);
        properties.setProperty("auto.offset.reset", "earliest");
//        properties.setProperty("partition.assignment.strategy", CooperativeStickyAssignor.class.getName());

        String topic = "demo_java";
        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(properties);

        // get a reference to the main thread
        final Thread mainThread = Thread.currentThread();

        // adding shutdown hook
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                logger.info("Detected a shutdown, let's exit by calling consumer.wakeup()..."); // another thread, not main thread will do this
                consumer.wakeup(); // next time when calling consumer.poll(), throw wake up exception

                // join the main thread to allow execution of code in main thread
                try {
                    mainThread.join(); // allow the code to be completed
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        });

        try {
            consumer.subscribe(Arrays.asList(topic));
            while (true) {
                logger.info("Polling");
                ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(1000)); // if no data, wait 1s to poll again
                for (ConsumerRecord<String, String> record: records) {
                    logger.info("Key: " + record.key() + ", Value: " + record.value());
                    logger.info("Partition: " + record.partition() + ", Offset: " + record.offset());
                }
            }

        } catch (WakeupException e) {
            logger.info("Consumer is starting to shut down");
        } catch (Exception e) {
            logger.info("Unexpected exception in the consumer", e);
        } finally {
            consumer.close(); // close the consumer, also commit offsets
            logger.info("The consumer is now gracefully shut down");
        }

    }

}
