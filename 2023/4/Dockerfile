FROM erlang:26.1.2-slim

WORKDIR /app
COPY . /app

RUN erlc four.erl

CMD ["erl", "-noshell", "-s", "four", "start", "-s", "init", "stop"]
