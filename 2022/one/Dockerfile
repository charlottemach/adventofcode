FROM openjdk:8-jdk-alpine

ARG KOTLIN_VERSION=1.7.20

RUN apk add --no-cache bash && \
    apk add --no-cache -t build-dependencies wget && \
    wget -q https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip && \
    unzip kotlin-compiler-*.zip -d /usr/lib/ && \
    rm kotlin-compiler-*.zip && \
    rm -f kotlinc/bin/*.bat && \
    apk del --no-cache build-dependencies

COPY one.txt one.txt
COPY one.kt one.kt

ENV PATH $PATH:/usr/lib/kotlinc/bin

RUN kotlinc one.kt

CMD ["/usr/lib/kotlinc/bin/kotlin", "OneKt"]
