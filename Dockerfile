ARG UBUNTU_VERSION=22.04

FROM ubuntu:$UBUNTU_VERSION as build

RUN apt-get update && apt-get install -y build-essential git cmake nvidia-cuda-toolkit

WORKDIR /sd.cpp

COPY . .
RUN git submodule update --init --recursive

RUN mkdir /sd.cpp/build 
RUN cd /sd.cpp/build
RUN cmake /sd.cpp -DSD_CUDA=ON
RUN cmake --build /sd.cpp/build --config Release

FROM ubuntu:$UBUNTU_VERSION as runtime

COPY --from=build /sd.cpp/build/bin/sd /sd

ENTRYPOINT [ "/sd" ]
