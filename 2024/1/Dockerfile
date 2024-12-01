FROM erlang:27.1.2-slim

WORKDIR /app
COPY . /app

RUN erlc one.erl

CMD ["erl", "-noshell", "-s", "one", "start", "-s", "init", "stop"]
