FROM ocaml/opam:ubuntu-24.10-ocaml-5.4

WORKDIR /app
COPY .ocamlinit /app
RUN opam update && opam install core --unlock-base
COPY . /app

CMD ["ocaml", "str.cma", "nineteen.ml"]
