FROM ubuntu:20.04 AS base

RUN apt-get update -qq \
&& DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -q \
    python3 \
    build-essential \
&& rm -rf /var/lib/apt/lists/*


FROM base as build_base

RUN apt-get update -qq \
&& DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -q \
    ca-certificates \
    autoconf \
    automake \
    autotools-dev \
    curl \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    git \
    libexpat1-dev \
&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i && \
    cd riscv-gnu-toolchain-rv32i && \
    git checkout 411d134 && \
    git submodule update --init --recursive && \
    mkdir build && \
    cd build && \
    ../configure --with-arch=rv32i --prefix=/opt/riscv32i && \
    make -j$(nproc)


FROM base

COPY --from=build_base /opt/riscv32i/ /opt/riscv32i

ENV PATH="/opt/riscv32i/bin:${PATH}"

WORKDIR /build

CMD [ "/bin/bash" ]