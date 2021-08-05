FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive
ARG UID=1000

RUN mkdir -p /usr/local/lib/cmake

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -yq nano build-essential zsh snapd && \
    apt-get install -yq locales mc wget curl openssl openssh-server xauth && \
    apt-get install -yq sudo net-tools iputils-ping && \
    apt-get install -yq curl g++-7 git python3-dev python3-numpy libudev-dev libturbojpeg0-dev && \
    apt-get install -yq rsync gdb cgdb libxkbcommon-x11-0 && \
    apt-get install -yq pkg-config libgtk2.0-dev libgtkglext1-dev && \
    apt-get install -yq ffmpeg libavcodec-dev libavformat-dev libswscale-dev libdrm-dev && \
    apt-get install -yq libgtk2.0 libgtkglext1 libcanberra-gtk-module opencl-headers ocl-icd-opencl-dev && \
    apt-get install -yq libpulse-mainloop-glib0 xcb && \
    apt-get install -yq libxcb-composite0 libxcb-damage0 libxcb-dpms0 libxcb-dri2-0 libxcb-dri3-0 && \
    apt-get install -yq libxcb-ewmh2 libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 && \
    apt-get install -yq libxcb-present0 libxcb-randr0 libxcb-record0 libxcb-render0 libxcb-res0 && \
    apt-get install -yq libxcb-screensaver0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1 && \
    apt-get install -yq libxcb-xf86dri0 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxcb-xtest0 && \
    apt-get install -yq libxcb-xv0 libxcb-xvmc0 libxcb1 libx11-xcb1 libxcb-cursor0 && \
    apt-get install -yq libxcb-xrm0 libxcb-xinput0 && \
    apt-get install -yq mplayer x11-apps libavresample-dev mesa-utils

RUN apt-get install -yq --no-install-recommends --allow-change-held-packages cuda-10-1 libcudnn7 libcudnn7-dev

COPY tensorflow_cc_shared_1.15.0_cuda_10.1_amd64.deb /
RUN dpkg -i /tensorflow_cc_shared_1.15.0_cuda_10.1_amd64.deb
RUN rm -f /tensorflow_cc_shared_1.15.0_cuda_10.1_amd64.deb

COPY tensorflow_cc_static_1.15.0_amd64.deb /
RUN dpkg -i /tensorflow_cc_static_1.15.0_amd64.deb
RUN rm -f /tensorflow_cc_static_1.15.0_amd64.deb

RUN apt-get clean

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN /home/linuxbrew/.linuxbrew/bin/brew install cmake vim neovim

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -p "$(openssl passwd -1 ubuntu)" -rm -d /home/ubuntu -s /usr/bin/zsh -g root -G sudo -u $UID ubuntu

RUN mkdir /var/run/sshd
RUN ssh-keygen -A -v
RUN /usr/sbin/update-rc.d ssh defaults
RUN sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config

RUN sudo chown -hR ubuntu /home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu

EXPOSE 22
ENTRYPOINT sudo service ssh start && /usr/bin/zsh

