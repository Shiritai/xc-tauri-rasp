# Rust Tauri ❤️ Raspberry Pi

Out-of-the-box tool that cross compile a rust tauri project for raspberry pi target.

## Usage

One can run `xcompile.sh -h` and see:

```bash
Cross compile a rust tauri application to debian package for raspberry pi (armhf/arm64).

Syntax: ./xcompile.sh [-c|h] [-e|n|p|a ARG]

Option:
  -e <DEBIAN_VERSION>
          to set debian version of compilation environment
          available versions are bookworm (debian 12, default) and bullseye (debian 11)
  -n <PROJECT_NAME>
          to set compilation target project
          default value is project
  -p <PROJECT_PATH>
          to set path of compilation target project
          default value is ./project
  -a <RASP_ARCH>
          to set architecture of raspberry pi
          default value: arm64
  -c      clean up all compilation targets before cross compile
          default not to clean up
  -h      show the help message
```

## Example

Situation:

* Project name: `my_project`
* Project path: `/path/to/my_project`
* Raspberry pi architecture: `arm64` (ARMv8), e.g. Raspberry pi 4b
* Raspberry Pi OS base, a.k.a. debian version: `bookworm` (debian 12)

One can cross compile a tauri app by running:

```bash
./xcompile.sh -e bookworm -n my_project -p /path/to/my_project -a arm64
```

## Prerequisite

* `docker` installed and `dockerd` is running

## Tested environment

|status|hardware|os|
|:-:|:-:|:-:|
|✅|Raspberry Pi 4 Model B|Raspberry Pi OS - Debian 11 (bullseye) aarch64|
|✅|Raspberry Pi Zero 2 w|Raspberry Pi OS Lite - Debian 12 (bookworm) aarch64|

## Contribute

We welcome any kinds of contribution, feel free to post issues and pull requests :)
