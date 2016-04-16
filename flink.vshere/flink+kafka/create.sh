#! /bin/bash

mvn archetype:generate  -DarchetypeGroupId=org.apache.flink -DarchetypeArtifactId=flink-quickstart-java  -DarchetypeVersion=1.1-SNAPSHOT

sudo bin/flink run -c uno.ReadFromKafka test/test/target/test-proba.jar

