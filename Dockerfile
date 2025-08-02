FROM ubuntu:latest

# apt install

RUN apt update && apt install -y sudo curl

# add user

ARG USERNAME=dockeruser
ARG GROUPNAME=dockergroup
ARG UID=1001
ARG GID=1001
ARG PASSWORD=password
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME/

# dotfiles

RUN curl -fsSL https://dotfiles.n4mlz.dev/install.sh | bash
