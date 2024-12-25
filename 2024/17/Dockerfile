FROM haskell:9.10-slim-bullseye

WORKDIR /app

RUN cabal update
COPY seventeen.cabal /app/seventeen.cabal

RUN cabal build --only-dependencies -j4

COPY . /app
RUN cabal install --lib split

ENTRYPOINT ["cabal","run","seventeen"]
