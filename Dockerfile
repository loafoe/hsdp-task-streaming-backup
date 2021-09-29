FROM minio/mc AS minio

FROM philipslabs/siderite:v0.11.3 AS siderite

FROM alpine:latest
RUN apk add --no-cache git openssh openssl bash postgresql-client
WORKDIR /app
COPY backup.sh backup.sh
RUN chmod +x /app/backup.sh
COPY --from=minio /usr/bin/mc /app/mc
COPY --from=siderite /app/siderite /app/siderite

ENTRYPOINT ["/app/siderite", "task"]
