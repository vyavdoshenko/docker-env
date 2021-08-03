FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/local/lib/cmake

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -yq nano vim neovim build-essential && \
    apt-get install -yq locales mc wget curl openssl openssh-server xauth && \
    apt-get install -yq sudo net-tools iputils-ping && \
    apt-get install -yq curl g++-7 git python3-dev python3-numpy libudev-dev libturbojpeg0-dev

COPY tensorflow_cc_static_1.15.0_amd64.deb /
RUN dpkg -i /tensorflow_cc_static_1.15.0_amd64.deb
RUN rm -f /tensorflow_cc_static_1.15.0_amd64.deb

RUN apt-get clean

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN /home/linuxbrew/.linuxbrew/bin/brew install cmake

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -p "$(openssl passwd -1 ubuntu)" -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/ubuntu/.bashrc

RUN mkdir /var/run/sshd
RUN ssh-keygen -A -v
RUN /usr/sbin/update-rc.d ssh defaults

RUN sudo chown -hR ubuntu /home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu

EXPOSE 22
ENTRYPOINT sudo service ssh start && /bin/bash

