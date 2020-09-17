added versionFROM debian:buster@sha256:439a6bae1ef351ba9308fc9a5e69ff7754c14516f6be8ca26975fb564cb7fb76

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

# Added piwheels to make the builds faster
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm/v7" ] || [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  printf "[global]\nextra-index-url=https://www.piwheels.org/simple" | touch /etc/pip.conf; \
  fi

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

# I don't even know why this is needed
RUN update-ca-certificates -f -v

# Create volume for mapping the config
VOLUME /usr/src/musicbot/config

ENV APP_ENV=docker

ENTRYPOINT ["python3", "dockerentry.py"]

COPY . ./