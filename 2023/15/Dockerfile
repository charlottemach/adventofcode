FROM haskell:9.6-slim

COPY . /app
WORKDIR /app
RUN cabal update && cabal install --lib split containers

RUN cabal build

ENTRYPOINT ["cabal","run","fifteen"]
