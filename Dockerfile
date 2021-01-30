FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ENV PATH="/opt/riscv32i/bin:${PATH}"

RUN apt-get update && apt-get -y install autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
    gperf libtool patchutils bc zlib1g-dev git libexpat1-dev python3

RUN mkdir /opt/riscv32i

RUN git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i && \
    cd riscv-gnu-toolchain-rv32i && \
    git checkout 411d134 && \
    git submodule update --init --recursive && \
    mkdir build && \
    cd build && \
    ../configure --with-arch=rv32i --prefix=/opt/riscv32i && \
    make -j$(nproc)

RUN rm -r riscv-gnu-toolchain-rv32i

WORKDIR /build