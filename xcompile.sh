#!/bin/bash

# --------- [ Setup arguments ] ---------

SCRIPT_DIR=$(realpath $(dirname $0))

# fixed arguments
CN_WORK_DIR="/project" # working directory in container, constant

help_info() {
    echo "Cross compile a rust tauri application to debian package for raspberry pi (armhf/arm64)."
    echo
    echo "Syntax: ./xcompile.sh [-c|h] [-e|n|p|t|a ARG]"
    echo
    echo "Option:"
    echo "  -e <DEBIAN_VERSION>"
    echo "          to set debian version of compilation environment"
    echo "          available versions are bookworm (debian 12, default) and bullseye (debian 11)"
    echo "  -n <PROJECT_NAME>"
    echo "          to set compilation target project"
    echo "          default value is project"
    echo "  -p <PROJECT_PATH>"
    echo "          to set path of project to be compiled"
    echo "          default value is ./project"
    echo "  -t <TARGET_PATH>"
    echo "          to set path of compilation target path"
    echo "          default value is ."
    echo "  -a <RASP_ARCH>"
    echo "          to set architecture of raspberry pi"
    echo "          default value: arm64"
    echo "  -c      clean up all compilation targets before cross compilation"
    echo "          default not to clean up"
    echo "  -h      show the help message"
}

# optional argument
DEBIAN_VER="bookworm"
RASP_ARCH="arm64"
PROJECT_PATH="./project"
PROJECT="project"
CLEANUP="true"
TARGET_PATH="."

# parse options
while getopts ":a:che:p:n:t:" option; do
    case $option in
    h) # display Help
        help_info
        exit
        ;;
    c) # whether to cleanup before compile
        CLEANUP="cargo clean"
        ;;
    a) # architecture of raspberry pi
        RASP_ARCH=$OPTARG
        ;;
    e) # debian version
        DEBIAN_VER=$OPTARG
        ;;
    n) # rust project name
        PROJECT=$OPTARG
        ;;
    p) # rust project path
        PROJECT_PATH=$OPTARG
        ;;
    t) # target path of compiled .deb file
        TARGET_PATH=$OPTARG
        ;;
    \?) # Invalid option
        echo "Error: Invalid option"
        exit
        ;;
    esac
done

# argument to derive from settings
if [ $RASP_ARCH = arm64 ]; then
    RASP_ARCH_LINKER=aarch64-linux-gnu
    COMPILE_TARGET=aarch64-unknown-linux-gnu
elif [ $RASP_ARCH = armhf ]; then
    RASP_ARCH_LINKER=arm-linux-gnueabihf
    COMPILE_TARGET=armv7-unknown-linux-gnueabihf
else
    echo Invalid raspberry pi arch && exit 1
fi

# parameter to construct x-compilation command
XCOMPILE="cargo tauri build --target ${COMPILE_TARGET} --bundles deb"
IMG_NAME="${PROJECT}-${RASP_ARCH}-${DEBIAN_VER}"

# --------- [ Build image for x-compilation ] ---------

if ! docker image inspect "${IMG_NAME}" >/dev/null; then
    docker build -t ${IMG_NAME} \
        --build-arg DEBIAN_VER="${DEBIAN_VER}" \
        --build-arg RASP_ARCH="${RASP_ARCH}" \
        --build-arg RASP_ARCH_LINKER="${RASP_ARCH_LINKER}" \
        --build-arg COMPILE_TARGET="${COMPILE_TARGET}" \
        ${SCRIPT_DIR} || { echo "error due to docker build image" && exit 1; }
fi

# --------- [ Cross compilation ] ---------

# before x-compile, put configuration file to project
cp -r $SCRIPT_DIR/.cargo $PROJECT_PATH/

docker run --rm -v $PROJECT_PATH:$CN_WORK_DIR \
    -v $CN_WORK_DIR/node_modules \
    ${IMG_NAME} /bin/bash -c "cd $CN_WORK_DIR && $CLEANUP && $XCOMPILE"

# --------- [ Copy result ] ---------

cp $PROJECT_PATH/target/$COMPILE_TARGET/release/bundle/deb/*.deb $TARGET_PATH