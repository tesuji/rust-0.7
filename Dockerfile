FROM ubuntu:12.04 AS buildbase

ENV DEBIAN_FRONTEND=noninteractive

ARG RUST_VER
ENV RUST_VER=${RUST_VER:-0.7}

SHELL ["/bin/bash", "-c"]

RUN sed -i "s/archive/old-releases/g" /etc/apt/sources.list
RUN <<-EOF
apt-get update
apt-get install -y \
  gcc-multilib \
  g++-multilib \
  make \
  python \
  perl \
  curl \
  git \
  llvm
apt-get clean
EOF

WORKDIR /build
ADD https://static.rust-lang.org/dist/rust-${RUST_VER}.tar.gz ./archive.tar.gz
RUN tar -xzf ./archive.tar.gz

# artifact will be i686-unknown-linux-gnu/stage2/bin/rustc
RUN <<-EOF
cd /build/rust-$RUST_VER/
./configure
make
EOF

WORKDIR /build/rust-$RUST_VER/
RUN i686-unknown-linux-gnu/stage2/bin/rustc src/test/run-pass/issue-3878.rs
