#!/usr/bin/env bash

set -e

export PGPASSWORD=$POSTGRES_PASSWORD

POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > dump.sql.gz

DESTINATION="$GS_BUCKET/${POSTGRES_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz"
echo "Uploading dump to $DESTINATION"

./google-cloud-sdk/bin/gsutil cp dump.sql.gz gs://$DESTINATION

rm dump.sql.gz

echo "SQL backup uploaded successfully"
