# Big Data Architecturesm - "Production" Rleases
## DSIoT Sandbox for local use
### Overview

| Version  | Description | Issues |
|:--------:|:----------------------|:-------|
| *0.1* | Initial commit of the integration of Spark 1.5.2 with Hadoop 2.6.0 and Cassandra (DataStax DDC) 3.5. Using the spark-Cassandra-connector 1.5.0 called through `--packages`. | Spark-Cassandra-Connector does not work with the Scala Kernel in the Jupyter Notebook. The connector does work with the Spark Shell and the Jupyter PySpark kernel. |

## DSIoT Sandbox for use with VMware vSphere
### Overview

| Version  | Description | Issues |
|:--------:|:----------------------|:-------|
| *0.1* | Initial commit of the integration of Spark 1.5.2 with Hadoop 2.6.0 and Cassandra (DataStax DDC) 3.5. Using the spark-Cassandra-connector 1.5.0 called through `--packages`. | Spark-Cassandra-Connector does not work with the Scala Kernel in the Jupyter Notebook. Issues with memory when submitting Spark Shell jobs. The connector does work with Jupyter PySpark Kernel. Suggested confiuration of two VM's with 6GB of virtual RAM each. |
| *0.2* | Upgraaded to DataStax Enterprise 5.0.1 and Spark 1.6.1 and created a custom "fat" jar for Cassandra connectivity. | Finally resolved the Sparl/Cassandra memory issue by upgrading to DataStax Enterprise. To resolve Scala not able to connect to Spark, using either Jupyter or Zeppelin, a custom assembly jar (based on spark-cassandra-connector-1.6) was compiled. All tests are funcitonal with Scala and PySpark, using both Juputer, R and Zeppelin. |
