FROM alpine:3.20 AS base

FROM base AS builder

RUN apk update && \
    apk upgrade && \
    apk add -i build-base opam gmp-dev pkgconf bash

RUN opam init --bare -a -y --disable-sandboxing \
    && opam update

RUN opam switch create default ocaml-base-compiler.5.2.0

RUN opam install -y dune bignum

WORKDIR /app

COPY dune-project bin/dune bin/main.ml ./

# eval $(opam config env) applies dune to PATH but it only persists in a single RUN layer
RUN eval $(opam config env) \
    && dune build main.exe

FROM base AS runner

RUN apk add --no-cache gmp-dev

WORKDIR /app

COPY --from=builder /app/_build/default/main.exe /app
COPY input.txt /app/input.txt

CMD [ "/app/main.exe" ]
