FROM python:3.8

# Add project source
WORKDIR /usr/src/musicbot
COPY requirements.txt .

# Install dependencies
RUN apt update \
  && apt install -y \
  ca-certificates \
  ffmpeg \
  opus-tools \
  python3 \
  libsodium-dev \
  gcc \
  git \
  libffi-dev \
  make \
  musl-dev \
  \
  # Install pip dependencies
  && pip install --no-cache-dir wheel \
  && pip install --no-cache-dir -r requirements.txt \
  && pip install --upgrade --force-reinstall --version websockets==4.0.1 

# Create volume for mapping the config
VOLUME /usr/src/musicbot/config

ENV APP_ENV=docker

ENTRYPOINT ["python3", "dockerentry.py"]

COPY . ./