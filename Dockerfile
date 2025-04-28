ARG DEBIAN_VER=""
FROM rust:${DEBIAN_VER}

ARG RASP_ARCH=""
ARG RASP_ARCH_LINKER=""
ARG COMPILE_TARGET=""

# -------------- [Install tauri (host + arm64)] ----------------
# Install base utils
RUN rm -rf /var/lib/apt/lists/* && \
  apt update && \
  apt upgrade -y && \
  apt install -y curl psmisc npm gcc-${RASP_ARCH_LINKER}

# Install rust and tauri toolchain
RUN rustup target add ${COMPILE_TARGET} && \
  cargo install tauri-cli && \
  cargo install trunk && \
  rustup target add wasm32-unknown-unknown

# Install Tauri dependencies (host machine)
RUN apt-get install -y \
  libwebkit2gtk-4.0-dev \
  libssl-dev \
  libgtk-3-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev \
  libasound2-dev \
  javascriptcoregtk-4.1 \
  libsoup-3.0 \
  webkit2gtk-4.1

# Prepare tools and basic settings for cross compilation to ARMv8
# https://tauri.app/v1/guides/building/linux/
RUN dpkg --add-architecture ${RASP_ARCH}

# Install Tauri dependencies (arm64)
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y libwebkit2gtk-4.0-dev:${RASP_ARCH} \
  libssl-dev:${RASP_ARCH} \
  libgtk-3-dev:${RASP_ARCH} \
  libayatana-appindicator3-dev:${RASP_ARCH} \
  librsvg2-dev:${RASP_ARCH} \
  libasound2-dev:${RASP_ARCH} \
  javascriptcoregtk-4.1:${RASP_ARCH} \
  libsoup-3.0:${RASP_ARCH} \
  webkit2gtk-4.1:${RASP_ARCH}

ENV PKG_CONFIG_SYSROOT_DIR=/usr/${RASP_ARCH_LINKER}/
# -------------- [End of install tauri] ----------------

RUN mkdir -p /project
WORKDIR /project

CMD ["/bin/bash"]
