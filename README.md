# Docker development environment

## Pre-requirements
- Linux distributive on the host
- Installed nvidia drivers
- Installed docker
- Created ~/work folder for using as a home folder inside a docker container

## Docker build
```
docker build --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    -t build_env .
```

## Docker run
```
docker run -p 2222:22 \
    --runtime=nvidia \
    --mount type=bind,source=${HOME}/work,destination=/home/ubuntu \
    --privileged \
    --device /dev/video0 \
    -v /dev/snd:/dev/snd \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    --hostname DOCKER_NVIDIA \
    -it build_env \
    /usr/bin/zsh
```
