docker cp alluxio-2.8.0-client.jar spark-master:/spark
docker cp alluxio-2.8.0-client.jar spark-worker1:/spark
docker cp alluxio-2.8.0-client.jar spark-worker2:/spark

docker exec spark-master bash -c " cp /spark/conf/spark-defaults.conf.template /spark/conf/spark-defaults.conf && echo 'spark.driver.extraClassPath   /spark/alluxio-2.8.0-client.jar' >> /spark/conf/spark-defaults.conf && echo 'spark.executor.extraClassPath /spark/alluxio-2.8.0-client.jar' >> /spark/conf/spark-defaults.conf  "
docker exec spark-worker1 bash -c " cp /spark/conf/spark-defaults.conf.template /spark/conf/spark-defaults.conf && echo 'spark.driver.extraClassPath   /spark/alluxio-2.8.0-client.jar' >> /spark/conf/spark-defaults.conf && echo 'spark.executor.extraClassPath /spark/alluxio-2.8.0-client.jar' >> /spark/conf/spark-defaults.conf  "
docker exec spark-worker2 bash -c " cp /spark/conf/spark-defaults.conf.template /spark/conf/spark-defaults.conf && echo 'spark.driver.extraClassPath   /spark/alluxio-2.8.0-client.jar' >> /spark/conf/spark-defaults.conf && echo 'spark.executor.extraClassPath /spark/alluxio-2.8.0-client.jar' >> /spark/conf/spark-defaults.conf  "
