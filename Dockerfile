FROM rust:latest

WORKDIR /usr/src/mk48

RUN apt-get update && apt-get install -y \
    gcc \
    make \
    nodejs \
    npm \
    pkg-config \
    libssl-dev

RUN rustup default nightly-2022-08-14 && \
    rustup target add wasm32-unknown-unknown

RUN cargo install --locked trunk --version 0.16.0

RUN git clone https://github.com/SoftbearStudios/mk48.git .

WORKDIR /usr/src/mk48/client
RUN trunk build --release

WORKDIR /usr/src/mk48/server
RUN cargo build --release

WORKDIR /usr/src/mk48/engine/js
RUN npm install && npm run build

WORKDIR /usr/src/mk48

EXPOSE 8081

CMD ["./target/release/mk48_server"]
