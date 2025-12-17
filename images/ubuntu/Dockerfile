FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
