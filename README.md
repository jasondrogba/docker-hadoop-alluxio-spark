# docker-hadoop-alluxio-spark
# Overview
First of all, it is recommended to know about [Alluxio](https://docs.alluxio.io/os/user/stable/en/Overview.html) 、 [Hadoop](https://hadoop.apache.org/) and [Spark](https://spark.apache.org/). The HDFS part of this project refers to [docker-hadoop-alluxio](https://github.com/jasondrogba/docker-hadoop-alluxio). Applications using Spark can access Alluxio through its HDFS-compatible interface. Data can be actively fetched or transparently cached into Alluxio to speed up I/O performance especially when the Spark deployment is remote to the data. meanwhile, as a near-compute cache, Alluxio can still provide compute frameworks data-locality.（[reference](https://docs.alluxio.io/os/user/stable/en/compute/Spark.html#:~:text=Spark%20on%20YARN-,Overview,-Applications%20using%20Spark)）  
Through this project, you can quickly deploy the alluxio cluster. The under storage is HDFS and the computing framework is spark. HDFS includes namenode, two datanodes, ResourceManager, historyserver and nodemanager; Spark includes spark master and two spark workers; Alluxio includes an alluxio master and two alluxio workers. All the above nodes are placed separately in the container.
# Quick Start Guide
## Deploy Alluxio container cluster
Download the whole project: 
```
git clone https://github.com/jasondrogba/docker-hadoop-alluxio-spark.git
```
Move to directory:
```
cd docker-hadoop-alluxio-spark
```
Start the alluxio cluster:
```
docker-compose up -d
```
## Launch Alluxio cluster
First, alluxio needs to start SSH:
```
./startssh.sh
```
Alluxio needs to be formatted before launching. The following command formats the Alluxio journal and worker storage directories.Execute in the alluxio-master container：
```
//enter alluxio-master container
$ docker exec -it alluxio-master bash

//move to alluxio
$ cd /opt/alluxio

//format the Alluxio journal and worker storage directories 
$ ./bin/alluxio format
```
In the master node, start the Alluxio cluster with the following command:
```
./bin/alluxio-start.sh all SudoMount
```
This will start Alluxio masters on all the nodes specified in conf/masters, and start the workers on all the nodes specified in conf/workers. Argument SudoMount indicates to mount the RamFS on each worker using sudo privilege, if it is not already mounted.  
This will start one Alluxio master and one Alluxio worker locally. You can see the master UI at http://localhost:19999.  
If the following content is displayed on the command line, the startup is successful:
```
-----------------------------------------
Starting to monitor all remote services.
-----------------------------------------
--- [ OK ] The master service @ alluxio-master is in a healthy state.
--- [ OK ] The job_master service @ alluxio-master is in a healthy state.
--- [ OK ] The worker service @ alluxio-worker1 is in a healthy state.
--- [ OK ] The worker service @ alluxio-worker2 is in a healthy state.
--- [ OK ] The job_worker service @ alluxio-worker1 is in a healthy state.
--- [ OK ] The job_worker service @ alluxio-worker2 is in a healthy state.
--- [ OK ] The proxy service @ alluxio-worker1 is in a healthy state.
--- [ OK ] The proxy service @ alluxio-worker2 is in a healthy state.
--- [ OK ] The proxy service @ alluxio-master is in a healthy state.
```
Alluxio comes with a simple program that writes and reads sample files in Alluxio. Run the sample program with:
```
./bin/alluxio runTests
```
## Web UI
alluxio-master:<IP_address>:19999 
spark-master:<IP_address>:8080 
namenode:<IP_address>:9870  
datanode1:<IP_address>:9864  
datanode2:<IP_address>:9863  
resource manager:<IP_address>:8088  
history server:<IP_address>:8188 
## Using the Alluxio Shell
The [Alluxio shell](https://docs.alluxio.io/os/user/stable/en/operation/User-CLI.html) provides command line operations for interacting with Alluxio. For specific tutorials, please refer to [using the alluxio shell](https://docs.alluxio.io/os/user/stable/en/overview/Getting-Started.html#:~:text=and%20worker%20respectively.-,Using%20the%20Alluxio%20Shell,-The%20Alluxio%20shell).

# Spark
First, start spark:
```
./startspark.sh
```
Enter the spark-master container, and run spark-shell:
```
docker exec -it spark-master bash
cd /spark && ./bin/spark-shell
```
Run the following commands from spark-shell:
```
val s=sc.textFile("alluxio://alluxio-master:19998/wordcount/input.txt")
val double=s.map(line=>line+line)
double.saveAsTextFile("alluxio://alluxio-master:19998/wordcount/Output_spark")
```
