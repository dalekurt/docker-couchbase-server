#!/bin/bash
# Create bucket
couchbase-cli bucket-create -c localhost:8091 -u ${CB_USERNAME} -p ${CB_PASSWORD} \
  --bucket=${CB_BUCKET} \
  --bucket-type=couchbase \
  --bucket-port=11222 \
  --bucket-ramsize=200 \
  --bucket-replica=1 \
  --wait

# Restore from backup
cbrestore /app/backups http://${CB_USERNAME}:${CB_PASSWORD}@localhost:8091 \
  --bucket-source=${CB_BUCKET} \
  --bucket-destination=${CB_BUCKET}
