#! /bin/bash
docker build \
	-t chpark1111/tensorflow:2.7.1-gpu-jupyter-python3.9 \
	--build-arg USER_NAME=chpark1111 \
	--build-arg PASSWORD=1234 \
	--build-arg UID=$UID \
	--build-arg GID=$UID \
	.
	
docker run \
	-it \
	--privileged \
	--gpus all \
	--ipc=host \
	--restart unless-stopped \
	-p 60020:22 \
	-p 60021-60040:60021-60040 \
	--name=chpark1111_deep \
	-v=$HOME:$HOME \
	-w=$HOME \
	chpark1111/tensorflow:2.7.1-gpu-jupyter-python3.9 /bin/zsh
#-u $(id -u ${USER}):$(id -g ${USER}) \
#-u :$(id -g ${USER}) \
