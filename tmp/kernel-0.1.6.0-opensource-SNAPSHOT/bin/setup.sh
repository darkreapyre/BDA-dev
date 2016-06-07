#!/bin/bash
#set -x

SPARKKERNEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"

ASSEMBLYJAR=$(echo $SPARKKERNEL/lib/kernel-assembly-*.jar)

# TODO - STEVE - fix pyspark for opensource
# SPARK_HOME=`echo 'import os; print os.environ["SPARK_HOME"]' | dse pyspark`

if [ `uname` == "Darwin" ]; then
  JUPYTER_CONFIGS=$HOME/Library/Jupyter/kernels
else
  JUPYTER_CONFIGS=$HOME/.local/share/jupyter/kernels
fi

# TODO - Steve - fix pyspark for opensource
# PY4J=$(ls $SPARK_HOME/python/lib/py4j*.zip)  

SPARKLOCAL="$JUPYTER_CONFIGS/spark-dse-local"
SPARKCLUSTER="$JUPYTER_CONFIGS/spark-dse-cluster"
PYSPARKLOCAL="$JUPYTER_CONFIGS/pyspark-dse-local"
PYSPARKCLUSTER="$JUPYTER_CONFIGS/pyspark-dse-cluster"

## File resource doesn't work correctly here because it writes a byte-order mark on the file
## and python can't then parse it


## File resource doesn't work correctly here because it writes a byte-order mark on the file
## and python can't then parse it

mkdir -p $SPARKLOCAL
echo "Creating file $SPARKLOCAL/kernel.json"
cat >$SPARKLOCAL/kernel.json <<EOF
{
    "display_name": "Spark-DSE Local",
    "language": "scala",
    "argv": [
        "spark-submit",
        "--master",
        "local[*]",
        "--packages",
        "datastax:spark-cassandra-connector:1.6.0-M2-s_2.10",
        "$ASSEMBLYJAR",
        "com.ibm.spark.SparkKernel",
        "--profile",
        "{connection_file}"
     ],
     "codemirror_mode": "scala"
}
EOF

mkdir -p $SPARKCLUSTER
echo "Creating file $SPARKCLUSTER/kernel.json"
cat <<EOF >$SPARKCLUSTER/kernel.json
{
    "display_name": "Spark-DSE Cluster",
    "language": "scala",
    "argv": [
        "spark-submit",
        "--packages",
        "datastax:spark-cassandra-connector:1.6.0-M2-s_2.10",
        "$ASSEMBLYJAR",
        "com.ibm.spark.SparkKernel",
        "--profile",
        "{connection_file}"
     ],
     "codemirror_mode": "scala"
}
EOF

exit 0


mkdir -p $PYSPARKLOCAL
echo "Creating file $PYSPARKLOCAL/kernel.json"
cat <<EOF >$PYSPARKLOCAL/kernel.json
{
 "display_name": "Pyspark DSE Local",
 "env": { "MASTER":"local",
          "PYTHONPATH" : "$PY4J:$SPARK_HOME/python",
          "PYTHONSTARTUP":"$SPARK_HOME/python/pyspark/shell.py"},
 "argv": ["python", "-m", "IPython.kernel", "-f", "{connection_file}"],
 "language": "python"
}
EOF

mkdir -p $PYSPARKCLUSTER
echo "Creating file $PYSPARKCLUSTER/kernel.json"
cat <<EOF >$PYSPARKCLUSTER/kernel.json
{
 "display_name": "Pyspark DSE Cluster",
 "env": { "PYTHONPATH" : "$PY4J:$SPARK_HOME/python",
          "PYTHONSTARTUP":"$SPARK_HOME/python/pyspark/shell.py"},
 "argv": ["python", "-m", "IPython.kernel", "-f", "{connection_file}"],
 "language": "python"
}
EOF

