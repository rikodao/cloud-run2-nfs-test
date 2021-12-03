FROM golang:1.14.4 as builder

WORKDIR /go/src



COPY main.go .
ARG GOOS=linux
ARG GOARCH=amd64
RUN go build -o /go/bin/main main.go


FROM ubuntu as runner

COPY --from=builder /go/bin/main /app/main




# Install system dependencies
RUN apt-get update -y && apt-get install -y \
    tini \
    nfs-common \
    netbase \
    && apt-get clean \
    \

# Set fallback mount directory
ENV MNT_DIR ./filestore
ENV FILE_SHARE_NAME ./filestore

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./


# Ensure the script is executable
RUN chmod +x /app/run.sh
RUN chmod +x /app/main

ENTRYPOINT ["/usr/bin/tini", "--"]

# Pass the startup script as arguments to tini
CMD ["/app/run.sh"]