FROM haskell:9.4.3-slim-buster

COPY . /app
WORKDIR /app

RUN ghc --make ten

ENTRYPOINT ["./ten"]
