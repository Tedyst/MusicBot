FROM debian:buster

# Add project source
WORKDIR /usr/src/musicbot

# Install dependencies
RUN apt update \
  && apt install -y \
  ca-certificates \
  ffmpeg \
  opus-tools \
  libsodium-dev \
  gcc \
  git \
  libffi-dev \
  make \
  musl-dev \
  python3-nacl \
  python3-pip \
  python3.7

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm/v7" ] || [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  printf "[global]\nextra-index-url=https://www.piwheels.org/simple" | touch /etc/pip.conf; \
  fi


COPY requirements.txt .

RUN pip3 install --no-cache-dir wheel pynacl \
  && pip3 install --no-cache-dir -r requirements.txt \
  && pip3 install --upgrade --force-reinstall --version websockets==4.0.1 \
  && python3 -m pip install -U https://github.com/Rapptz/discord.py/archive/master.zip#egg=discord.py[voice]

# Create volume for mapping the config
VOLUME /usr/src/musicbot/config

ENV APP_ENV=docker

ENTRYPOINT ["python3", "dockerentry.py"]

COPY . ./