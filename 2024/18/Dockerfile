FROM rust:alpine3.20
 
WORKDIR /usr/src/eighteen
COPY . .
 
RUN cargo install --path .
 
CMD ["eighteen"]
