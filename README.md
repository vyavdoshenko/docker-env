# Docker development environment

- Docker build
{code}
docker build --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    -t build_env .
{code}

- Docker run
{code}
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
{code}
