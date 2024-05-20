ARG DEBIAN_VER=""
FROM rust:${DEBIAN_VER}

# -------------- [Setup user] ----------------
ARG USERNAME=""
ENV USER "${USERNAME}"
ARG RASP_ARCH=""
ARG RASP_ARCH_LINKER=""
ARG COMPILE_TARGET=""

RUN echo ${USERNAME} && \
  apt update && apt upgrade -y && \
  apt install -y locales-all && \
  apt install sudo && \
  useradd -m -G sudo "${USERNAME}" && \
  echo "${USERNAME} ALL = NOPASSWD: ALL" > /etc/sudoers.d/"${USERNAME}" && \
  chmod 0440 /etc/sudoers.d/"${USERNAME}" && \
  passwd -d "${USERNAME}" && \
  mkdir /home/${USERNAME}/data

USER "${USERNAME}"

RUN chsh -s $(which bash)

WORKDIR /home/${USERNAME}
# -------------- [End of setup user] ----------------

# -------------- [Setup user env] ----------------
RUN mkdir -p project
# -------------- [End of setup user env] ----------------

# -------------- [Install tauri (host + arm64)] ----------------
# Install base utils
RUN sudo apt update && \
  sudo apt install -y curl psmisc

RUN rustup target add ${COMPILE_TARGET} && \
  sudo apt install -y gcc-${RASP_ARCH_LINKER}

# Install tauri toolchain
RUN cargo install create-tauri-app --locked
RUN cargo install tauri-cli && \
  cargo install trunk && \
  rustup target add wasm32-unknown-unknown

# Prepare tools and basic settings for cross compilation to ARMv8
# https://tauri.app/v1/guides/building/linux/
RUN sudo dpkg --add-architecture ${RASP_ARCH}

# Install Tauri dependencies (host machine)
RUN sudo apt install -y \
  libwebkit2gtk-4.0-dev \
  libssl-dev \
  libgtk-3-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev

# Install Tauri dependencies (arm64)
RUN sudo apt update && \
  sudo apt upgrade -y && \
  sudo apt install -y libwebkit2gtk-4.0-dev:${RASP_ARCH} \
  libssl-dev:${RASP_ARCH} \
  libgtk-3-dev:${RASP_ARCH} \
  libayatana-appindicator3-dev:${RASP_ARCH} \
  librsvg2-dev:${RASP_ARCH}

ENV PKG_CONFIG_SYSROOT_DIR=/usr/${RASP_ARCH_LINKER}/
# -------------- [End of install tauri] ----------------

# open developement port
EXPOSE 1420

CMD ["/bin/bash"]
