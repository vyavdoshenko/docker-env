# nvidia image to with preinstalled packages
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive
# default user id
ARG UID=1000

RUN mkdir -p /usr/local/lib/cmake

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -yq nano build-essential zsh
RUN apt-get install -yq locales mc wget curl openssl openssh-server xauth
RUN apt-get install -yq sudo net-tools iputils-ping
RUN apt-get install -yq curl git python3-dev python3-numpy libudev-dev libturbojpeg0-dev
RUN apt-get install -yq rsync gdb cgdb libxkbcommon-x11-0
RUN apt-get install -yq pkg-config libgtk2.0-dev libgtkglext1-dev
RUN apt-get install -yq ffmpeg libavcodec-dev libavformat-dev libswscale-dev libdrm-dev
RUN apt-get install -yq libgtk2.0 libgtkglext1 libcanberra-gtk-module opencl-headers ocl-icd-opencl-dev
RUN apt-get install -yq libpulse-mainloop-glib0 xcb
RUN apt-get install -yq libxcb-composite0 libxcb-damage0 libxcb-dpms0 libxcb-dri2-0 libxcb-dri3-0
RUN apt-get install -yq libxcb-ewmh2 libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1
RUN apt-get install -yq libxcb-present0 libxcb-randr0 libxcb-record0 libxcb-render0 libxcb-res0
RUN apt-get install -yq libxcb-screensaver0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1
RUN apt-get install -yq libxcb-xf86dri0 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxcb-xtest0
RUN apt-get install -yq libxcb-xv0 libxcb-xvmc0 libxcb1 libx11-xcb1 libxcb-cursor0
RUN apt-get install -yq libxcb-xrm0 libxcb-xinput0
RUN apt-get install -yq mplayer x11-apps libavresample-dev mesa-utils
RUN apt-get install -yq gcc-5 gcc-8 g++-8 xclip kdiff3 adb

RUN apt-get install -yq --no-install-recommends --allow-change-held-packages cuda-10-1 libcudnn7 libcudnn7-dev

# install additional deb packages from local build folder
RUN mkdir -p /tmp/deb/
COPY *.deb /tmp/deb/
RUN dpkg -i /tmp/deb/*.deb
RUN rm -fr /tmp/deb/

RUN apt-get clean

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8

# install linux brew to install fresh components if needed
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN /home/linuxbrew/.linuxbrew/bin/brew install cmake vim neovim ctags ripgrep ack python3

# optional step, install clion
COPY CLion-*.tar.gz /
RUN tar xvzf CLion-*.tar.gz -C /opt/
RUN rm -f /CLion-*.tar.gz

# make user sudoer without password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# create default locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# create user ubuntu with password ubuntu
RUN useradd -p "$(openssl passwd -1 ubuntu)" -rm -d /home/ubuntu -s /usr/bin/zsh -G sudo -u $UID ubuntu

# ssh service install with xserver support
RUN mkdir /var/run/sshd
RUN ssh-keygen -A -v
RUN /usr/sbin/update-rc.d ssh defaults
RUN sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config

USER ubuntu
WORKDIR /home/ubuntu

EXPOSE 22
ENTRYPOINT sudo service ssh start && /usr/bin/zsh
