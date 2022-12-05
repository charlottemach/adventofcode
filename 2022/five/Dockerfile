FROM erlang:25.1.2-slim

WORKDIR /app
COPY . /app

RUN erlc five.erl

#CMD ["/bin/sh"]
# CMD ["erl"]
CMD ["erl", "-noshell", "-s", "five", "start", "-s", "init", "stop"]

