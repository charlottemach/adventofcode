FROM sbtscala/scala-sbt:openjdk-8u342_1.8.1_3.2.1

COPY . /app
WORKDIR /app

RUN scalac twentytwo.scala

CMD ["scala", "TwentyTwo"]
