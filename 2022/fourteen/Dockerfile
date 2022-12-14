FROM debian:10.13-slim

RUN apt update \
    && apt install -y valac \
    && rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app

RUN valac fourteen.vala

CMD ["./fourteen"]
