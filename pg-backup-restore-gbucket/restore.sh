#!/usr/bin/env bash

set -e

export PGPASSWORD=$POSTGRES_PASSWORD

POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"
DUMP_FILE=$(./google-cloud-sdk/bin/gsutil ls -l gs://$GS_BUCKET | sort -k 2 | tail -n 2 | head -1 | cut -d ' ' -f 10)

echo "Restoring dump of ${POSTGRES_DATABASE} database from ${DUMP_FILE}"
./google-cloud-sdk/bin/gsutil cp ${DUMP_FILE} ./dumpfile.gz

gunzip -c dumpfile.gz | psql ${POSTGRES_HOST_OPTS} $POSTGRES_DATABASE

rm dumpfile.gz

echo "DB restored successfully"

