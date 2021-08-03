FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/local/lib/cmake

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -yq nano vim neovim build-essential && \
    apt-get install -yq locales mc wget curl && \
    apt-get install -yq sudo net-tools iputils-ping && \
    apt-get install -yq cmake curl g++-7 git python3-dev python3-numpy

RUN apt-get install -yq --no-install-recommends --allow-change-held-packages cuda-10-1 libcudnn7 libcudnn7-dev

COPY tensorflow_cc_shared_1.15.0_cuda_10.1_amd64.deb /
RUN dpkg -i /tensorflow_cc_shared_1.15.0_cuda_10.1_amd64.deb
RUN rm -f /tensorflow_cc_shared_1.15.0_cuda_10.1_amd64.deb 

RUN apt-get clean

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
USER ubuntu
WORKDIR /home/ubuntu

CMD /bin/bash
