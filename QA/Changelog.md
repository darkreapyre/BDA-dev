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
| *0.1* | Initial commit of the integration of Spark 1.5.2 with Hadoop 2.6.0 and Cassandra (DataStax DDC) 3.5. Using the spark-Cassandra-connector 1.5.0 called through `--packages`. | Spark-Cassandra-Connector does not work with the Scala Kernel in the Jupyter Notebook. Issues with memory when submitting Spark Shell jobs. The connector does work with Jupyter PySpark Kernel. Suggested confiuration of two VM's with 6GB of virtual RAM each.|
