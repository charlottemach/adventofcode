FROM clojure:temurin-23-lein-2.11.2-bullseye-slim

RUN lein new app seven
WORKDIR seven

COPY input.txt input.txt
COPY seven.clj src/seven/core.clj

RUN lein deps
RUN mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')" seven.jar

CMD ["java", "-jar", "seven.jar"]
