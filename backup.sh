#!/usr/bin/env bash
#
# ----- Config start -----
timestamp=`date +%Y%m%d%H%M%S`
cat $PAYLOAD_FILE
set

if [ -z "$DB_HOST" ]; then
    echo "DB_HOST environment variable not found..."
    exit 1
fi

if [ -z "$DB_PORT" ]; then
    echo "DB_PORT environment variable not found..."
    exit 1
fi

if [ -z "$DB_USER" ]; then
    echo "DB_USER environment variable not found..."
    exit 1
fi

if [ -z "$DB_PASSWORD" ]; then
    echo "DB_PASSWORD environment variable not found..."
    exit 1
fi

if [ -z "$DB_NAME" ]; then
    echo "DB_NAME environment variable not found..."
    exit 1
fi

if [ -z "$BACKUP_NAME" ]; then
    echo "BACKUP_NAME environment variable not found..."
    exit 1
fi

if [ -z "$S3_BUCKET" ]; then
    echo "Specify S3 destination bucket in S3_BUCKET variable..."
    exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "Specify AWS_ACCESS_KEY_ID variable..."
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Specify AWS_SECRET_ACCESS_KEY variable..."
    exit 1
fi

echo Using configuration
echo -------------------
echo     S3 Bucket: ${s3_bucket}
# ----- Config end -----

echo Processing...
echo "$DB_HOST:$DB_PORT:$DB_NAME:$DB_USER:$DB_PASSWORD" > ~/.pgpass

outfile=${BACKUP_NAME}-${timestamp}.gz.aes
echo Backing up stream to s3://${S3_BUCKET}/${OUTFILE} ...
time pg_dump -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} ${DB_NAME} | gzip | /app/gof3r put -b ${S3_BUCKET} -k ${OUTFILE} --no-md5
