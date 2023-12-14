FROM dlang2/dmd-ubuntu:2.096.1

COPY . /app
WORKDIR /app

RUN dmd thirteen.d

CMD ["./thirteen"]
