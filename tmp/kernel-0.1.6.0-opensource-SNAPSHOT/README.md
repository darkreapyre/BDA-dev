DataStax Enterprise Spark Kernels for Scala and Python
============

### Prerequisites:
DataStax Enterprise 4.8
Python 2.7
Scala (for Scala users)
Jupyter

### To get ipython notebook

Obviously you need python 2.7.  Install these python packages

    pip install jupyter

### To set it up:

1. Unpack the tarball downloaded from http://github.com/slowenthal/spark-kernel/releases
2. in the tarball, navigate to the bin directory
3. Run `setup.sh [<ip address for spark master>]`. If your spark master is 127.0.0.1, you can leave out the ip addresses.*

If you are on an edge node, copy the hadoop configuration file dse-core-defaults.xml from a node in your cluster to your local DSE directories.

### To run it

    ipython notebook

Some Useful options

1. `--no-browser` - avoid the browser from popping up
2. `--ip 0.0.0.0` - listen on all interfaces instead of just localhost
3. `--port <portno>` - listen on a different port.  (The default is 8888)


In the browser - create a new spark notebook

![image](https://cloud.githubusercontent.com/assets/2955904/9398338/fe850f02-475a-11e5-9fea-86bfcdbfbbad.png)

### ... and spark away

![image](https://cloud.githubusercontent.com/assets/2955904/9398374/60c4bef6-475b-11e5-8eca-62add0d38763.png)


## Special features of the Scala Kernel

1. `%%cql <cql statement>`   Run a CQL statement and display the output
2. `%%showschema [<keyspace>][.<table>]` - Display all or part of the schema


[![Build Status][build-badge]][build-url]
[![Coverage Status][coverage-badge]][coverage-url]
[![Scaladoc][scaladoc-badge]][scaladoc-url]
[![License][license-badge]][license-url]

#### Note: To download and install, click releases above, and read that stuff.

Requires JDK 1.7 or higher!

The Spark Kernel has one main goal: provide the foundation for interactive applications to connect and use [Apache Spark][1].

Overview
========

<!-- Embedding HTML so we can align right our image -->
<!-- Using absolute cache path since cannot reference wiki image using normal relative url -->
<img src="https://raw.githubusercontent.com/wiki/ibm-et/spark-kernel/overview.png" alt="Spark Kernel Overview" title="Spark Kernel Overview" align="right" width=500px />

The kernel provides several key features for applications:

1. Define and run Spark Tasks

    - Executing Scala code dynamically in a similar fashion to the _Scala REPL_ and _Spark Shell_

2. Collect Results without a Datastore

    - Send execution results and streaming data back via the Spark Kernel to your applications

    - Use the [Comm API][2] - an abstraction of the IPython protocol - for more detailed data 
      communication and synchronization between your applications and the Spark Kernel

3. Host and Manage Applications Separately from Apache Spark

    - The _Spark Kernel_ serves as a proxy for requests to the Apache Spark cluster

The project intends to provide applications with the ability to send both packaged jars and code snippets. As it implements the latest IPython message protocol (5.0), the Spark Kernel can easily plug into the 3.x branch of IPython for quick, interactive data exploration. The Spark Kernel strives to be extensible, providing a [pluggable interface][3] for developers to add their own functionality.

For Cassandra you may need to override some of the spark cassandra connector settings such as

    spark.cassandra.connection.host 127.0.0.1

If you're starting the kernel from the command line, you can add spark settings to the command line as follows:

    --spark-configuration spark.cassandra.connection.host

use a --spark-configuration for each separate parameter

If you're starting it through iPython notebook, you will have created a kernel.json file.  Add this to the args

    "--spark-configuration",
    "spark.cassandra.connection.host=127.0.0.1"


    
        





__If you are new to the Spark Kernel, please see the [Getting Started][4] section.__

__For more information, please visit the [Spark Kernel wiki][5].__

__For bug reporting and feature requests, please visit the [Spark Kernel issue list][6].__

[1]: https://spark.apache.org/
[2]: https://github.com/ibm-et/spark-kernel/wiki/Guide-to-the-Comm-API-of-the-Spark-Kernel-and-Spark-Kernel-Client
[3]: https://github.com/ibm-et/spark-kernel/wiki/Guide-to-Developing-Magics-for-the-Spark-Kernel
[4]: https://github.com/ibm-et/spark-kernel/wiki/Getting-Started-with-the-Spark-Kernel
[5]: https://github.com/ibm-et/spark-kernel/wiki
[6]: https://github.com/ibm-et/spark-kernel/issues

[build-badge]: https://travis-ci.org/ibm-et/spark-kernel.svg?branch=master
[build-url]: https://travis-ci.org/ibm-et/spark-kernel
[coverage-badge]: https://coveralls.io/repos/ibm-et/spark-kernel/badge.svg?branch=master
[coverage-url]: https://coveralls.io/r/ibm-et/spark-kernel?branch=master
[scaladoc-badge]: https://img.shields.io/badge/Scaladoc-Latest-34B6A8.svg?style=flat
[scaladoc-url]: http://ibm-et.github.io/spark-kernel/latest/api
[license-badge]: https://img.shields.io/badge/License-Apache%202-blue.svg?style=flat
[license-url]: LICENSE
