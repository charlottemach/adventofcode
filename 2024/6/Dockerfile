FROM dlangchina/dlang-dmd:2.097.1

COPY . /app
WORKDIR /app

RUN dmd six.d

CMD ["./six"]
