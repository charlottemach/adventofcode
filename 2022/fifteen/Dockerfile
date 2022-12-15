FROM sbtscala/scala-sbt:openjdk-8u342_1.8.0_3.2.1

COPY . /app
WORKDIR /app

RUN scalac fifteen.scala

CMD ["scala", "Fifteen"]
