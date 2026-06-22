#!/bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
target_user="${1:-cs1680-user}"

export DEBIAN_FRONTEND=noninteractive
export TZ=America/New_York
export LANG=en_US.UTF-8


apt-get update &&\
  yes | unminimize

# include multiarch support
apt-get update &&
  apt-get -y install binfmt-support &&\
  dpkg --add-architecture amd64 &&\
  apt-get update &&\
  apt-get -y upgrade

# set up default locale
apt-get update && apt-get -y install locales
locale-gen en_US.UTF-8

# install GCC-related packages
apt-get update && apt-get -y install\
 build-essential\
 binutils-doc\
 cpp-doc\
 gcc-doc\
 g++\
 gdb\
 gdb-doc\
 glibc-doc\
 libblas-dev\
 liblapack-dev\
 liblapack-doc\
 libstdc++-11-doc\
 make\
 make-doc

# install GCC-related packages for amd64
apt-get -y install\
	g++-13-x86-64-linux-gnu\
	gdb-multiarch\
	libc6:amd64\
	libstdc++6:amd64\
	libasan8:amd64\
	libtsan2:amd64\
	libubsan1:amd64\
	libreadline-dev:amd64\
	libblas-dev:amd64\
	liblapack-dev:amd64\
	qemu-user

# # link x86-64 versions of common tools into /usr/x86_64-linux-gnu/bin
for i in addr2line c++filt cpp-13 g++-13 gcc-13 gcov-13 gcov-dump-13 gcov-tool-13 size strings; do \
    ln -s /usr/bin/x86_64-linux-gnu-$i /usr/x86_64-linux-gnu/bin/$i; done && \
    ln -s /usr/bin/x86_64-linux-gnu-cpp-13 /usr/x86_64-linux-gnu/bin/cpp && \
    ln -s /usr/bin/x86_64-linux-gnu-g++-13 /usr/x86_64-linux-gnu/bin/c++ && \
    ln -s /usr/bin/x86_64-linux-gnu-g++-13 /usr/x86_64-linux-gnu/bin/g++ && \
    ln -s /usr/bin/x86_64-linux-gnu-gcc-13 /usr/x86_64-linux-gnu/bin/gcc && \
    ln -s /usr/bin/x86_64-linux-gnu-gcc-13 /usr/x86_64-linux-gnu/bin/cc && \
    ln -s /usr/bin/gdb-multiarch /usr/x86_64-linux-gnu/bin/gdb

# Do main setup
$SCRIPT_DIR/container-setup-common
# Install golang
bash -c "mkdir /usr/local/go && wget -O - https://go.dev/dl/go1.25.5.linux-arm64.tar.gz | sudo tar -xvz -C /usr/local"

