FROM clojure:temurin-8-lein-2.10.0-bullseye-slim

RUN lein new app one
WORKDIR one/src/one

COPY input.txt input.txt
COPY one.clj core.clj

RUN lein deps
RUN mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')" one.jar

CMD ["java", "-jar", "one.jar"]
