FROM rust:alpine3.16
 
WORKDIR /usr/src/two
COPY . .
 
RUN cargo install --path .
 
CMD ["two"]
