#!/usr/bin/bash

set -e

if [ -z "${GCLOUD_PRIVATE_KEY_ID_B64}" ]; then
    echo "Set the GCLOUD_PRIVATE_KEY_ID_B64 environment variable."
    exit 1
fi

if [ -z "${GCLOUD_ACCOUNT}" ]; then
    echo "Set the GCLOUD_ACCOUNT environment variable."
    exit 1
fi

if [ -z "${GCLOUD_PROJECT}" ]; then
    echo "Set the GCLOUD_PROJECT environment variable."
    exit 1
fi

if [ -z "${GS_BUCKET}" ]; then
    echo "Set the GS_BUCKET environment variable."
    exit 1
fi

if [ -z "${POSTGRES_DATABASE}" ]; then
    echo "Set the POSTGRES_DATABASE environment variable."
    exit 1
fi

if [ -z "${POSTGRES_HOST}" ] ; then
    echo "Set the POSTGRES_HOST environment variable."
    exit 1
fi

if [ -z "${POSTGRES_USER}" ]; then
    echo "You need to set the POSTGRES_USER environment variable."
    exit 1
fi

echo ${GCLOUD_PRIVATE_KEY_ID_B64}|base64 -d > ./key.json

./google-cloud-sdk/bin/gcloud auth activate-service-account  $GCLOUD_ACCOUNT --key-file=./key.json --project=$GLCOUD_PROJECT

if [ "$1" = 'restore-and-cron' ]; then
    /usr/local/bin/restore.sh
    # Normal startup run every 6 hours
    echo "${SCHEDULE} GS_BUCKET=${GS_BUCKET} POSTGRES_PORT=${POSTGRES_PORT} POSTGRES_USER=${POSTGRES_USER} POSTGRES_PASSWORD=${POSTGRES_PASSWORD} POSTGRES_HOST=${POSTGRES_HOST} POSTGRES_DATABASE=${POSTGRES_DATABASE} /usr/local/bin/backup.sh
    # extraline"> schedule.txt
    crontab schedule.txt
    crond -f
elif [ "$1" = 'backup-and-cron' ]; then
    /usr/local/bin/backup.sh
    echo "${SCHEDULE} GS_BUCKET=${GS_BUCKET} POSTGRES_PORT=${POSTGRES_PORT} POSTGRES_USER=${POSTGRES_USER} POSTGRES_PASSWORD=${POSTGRES_PASSWORD} POSTGRES_HOST=${POSTGRES_HOST} POSTGRES_DATABASE=${POSTGRES_DATABASE} /usr/local/bin/backup.sh
    # extraline"> schedule.txt
    crontab schedule.txt
    crond -f

elif [ "$1" = 'backup' ]; then
    # Backup now
    /usr/local/bin/backup.sh

elif [ "$1" = 'restore' ]; then
    # Restore now
    /usr/local/bin/restore.sh

else
    # Run command as given by user
    exec "$@"
fi

