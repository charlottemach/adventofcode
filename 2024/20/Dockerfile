FROM debian:12.8-slim

RUN apt update \
    && apt install -y valac \
    && rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app

RUN valac twenty.vala

CMD ["./twenty"]
