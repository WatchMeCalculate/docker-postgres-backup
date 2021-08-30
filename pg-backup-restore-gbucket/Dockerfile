FROM alpine:3.14.2

RUN apk add --no-cache curl python3 postgresql-client gzip bash
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-354.0.0-linux-x86_64.tar.gz
RUN tar xvf google-cloud*
RUN ./google-cloud-sdk/install.sh --quiet
RUN ./google-cloud-sdk/bin/gcloud components update
RUN apk del --no-cache curl

ENV POSTGRES_PORT 5432
ENV SCHEDULE "@daily"

COPY entrypoint.sh /usr/local/bin
COPY backup.sh /usr/local/bin
COPY restore.sh /usr/local/bin

ENTRYPOINT ["bash","/usr/local/bin/entrypoint.sh"]
CMD ["backup-and-cron"]
