FROM tensorflow/tensorflow:2.7.1-gpu-jupyter
#Using python3.9

# set a user name and a password 
ARG USER_NAME=chpark1111
ARG PASSWORD=1234

# UID and GID should be manually declared when building Dockerfile.
# e.g. docker build --build-arg UID=$UID --build-arg GID=$GID
ARG UID
ARG GID

# install some essential packages
RUN apt-get update && apt-get install -y \
	apt-utils \
	build-essential \
    x11-apps \
    curl \
    git \
    man \
    wget \
    htop \
    vim \
    nano \
    ctags \
	openssh-server \
	sudo \
    tmux \
	cmake \
    npm \
    software-properties-common \
    libgl1-mesa-glx \
	locales \
    tzdata \
    python3.9 \
	zsh && \
	apt-get -y autoremove && apt-get -y clean

#Install newest nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
RUN apt-get install -y nodejs

# set a timezone as Asia/Seoul
ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && echo Asia/Seoul > /etc/timezone

# set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# allow root to login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN systemctl enable ssh
# Allow X11 forwarding
RUN sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config
# set the root password
RUN echo "root:root" | chpasswd 

# add a user
RUN groupadd -g $GID $USER_NAME
RUN useradd -s /bin/zsh -u $UID -g $GID $USER_NAME && echo "${USER_NAME}:${PASSWORD}" | chpasswd && adduser $USER_NAME sudo
RUN chsh -s /bin/zsh $USER_NAME && chsh -s /bin/zsh root

USER $USER_NAME
WORKDIR /home/$USER_NAME