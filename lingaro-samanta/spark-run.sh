#!/usr/bin/env bash
set -euo pipefail

until mariadb -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e 'SELECT 1' >/dev/null 2>&1; do
  echo 'Waiting for MariaDB...'; sleep 2
done

JAR="${JAR_NAME:-PG-Samanta-ETL-assembly-1.0.168.jar}"
test -f "target/scala-2.12/$JAR" || {
  echo "Jar not found: target/scala-2.12/$JAR"
  echo "Build first: docker compose run --rm samanta sbt clean assembly"
  exit 1
}

exec "$SPARK_HOME/bin/spark-submit" \
  --class "${MAIN_CLASS:-com.pg.samanta.Main}" \
  --conf spark.executor.cores=8 \
  --conf spark.executor.memory=46g \
  --conf spark.driver.memory=56g \
  --conf spark.sql.shuffle.partitions=40 \
  --conf spark.driver.extraJavaOptions=-XX:+UseG1GC \
  --conf spark.executor.extraJavaOptions=-XX:+UseG1GC \
  --conf spark.hadoop.fs.azure.io.retry.max.retries=10 \
  --conf spark.shuffle.io.maxRetries=10 \
  --conf spark.shuffle.io.retryWait=60s \
  --conf spark.driver.maxResultSize=32g \
  --conf spark.memory.offHeap.enabled=false \
  --conf spark.task.cpus=2 \
  --conf spark.sql.parquet.compression.codec=zstd \
  --conf spark.local.dir=/mnt/spark \
  --conf "spark.hadoop.fs.azure.account.key.sasamantaprod.blob.core.windows.net=${AZ_ACCOUNT_KEY}" \
  --conf "spark.db.url=${DB_URL}" \
  target/scala-2.12/"$JAR" \
  "$@"
