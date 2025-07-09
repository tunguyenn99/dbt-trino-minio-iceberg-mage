# dbt-trino-minio-iceberg
On-premises ELT Pipeline


docker network connect dbt-trino-minio-iceberg_trino-network astronomer_afff4a-scheduler-1
docker network connect dbt-trino-minio-iceberg_trino-network astronomer_afff4a-triggerer-1
docker network connect dbt-trino-minio-iceberg_trino-network astronomer_afff4a-api-server-1
docker network connect dbt-trino-minio-iceberg_trino-network astronomer_afff4a-dag-processor-1

docker exec -it astronomer_afff4a-scheduler-1 curl http://trino-coordinator:8080/v1/info


git clone https://github.com/mage-ai/compose-quickstart.git mage-quickstart \
&& cd mage-quickstart \
&& cp dev.env .env && rm dev.env \
&& docker compose up
