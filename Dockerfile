FROM python:3.13.0a4-slim-bookworm

ARG USERNAME=insta-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN mkdir /downloads /instaloader

RUN pip3 install --upgrade pip
RUN pip3 install instaloader

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN chown ${USERNAME} /downloads /instaloader

USER ${USERNAME}

RUN touch /instaloader/args.txt /instaloader/targets.txt

WORKDIR /downloads

CMD instaloader $(xargs -a /instaloader/args.txt) $(xargs -a /instaloader/targets.txt)