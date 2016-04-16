# Useful additional packages to install if not already installed
options("repos"="http://cran.rstudio.com") # set the cran mirror

packages <- c("devtools",
              "ggplot2",
              "tidyr",
              "dplyr",
              "stringr",
              "rstudio",
              "knitr",
              "rmarkdown",
              "XML",
              "rJava",
              "mallet",
              "igraph",
              "SnowballC",
              "NLP",
              "openNLP")

packages <- setdiff(packages, installed.packages()[, "Package"])
if (length(packages) != 0){
  (install.packages(packages))
}

# Initialze connectivity to the Spark Cluster
Sys.setenv(SPARK_HOME = "/opt/spark")

# Initialize SparkR
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# Initialize the Spark Context for Cluster Connectivity
sc <- sparkR.init(
  master = "spark://spark-master:7077",
  sparkEnvir = list(spark.driver.memory="2g"),
  sparkPackages="com.databricks:spark-csv_2.11:1.0.3") # Add .csv import cabaility

# Initialize the SQLContext
sqlContext <- sparkRSQL.init(sc)

# REMEMBER TO SHUT DOWN `sparkR` WHEN DONE
#sparkR.stop()