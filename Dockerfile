FROM ubuntu:12.04 as buildbase

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

RUN <<-EOF
gcc -v
python -V
perl -V
make --version
EOF

WORKDIR /build
ADD https://static.rust-lang.org/dist/rust-${RUST_VER}.tar.gz ./archive.tar.gz
RUN tar -xzf ./archive.tar.gz

# artifact will be i686-unknown-linux-gnu/stage2/bin/rustc
# test i686-unknown-linux-gnu/stage2/bin/rustc src/test/run-pass/issue-3878.rs
WORKDIR /build/rust-0.7/
RUN <<-EOF
./configure
make
EOF
