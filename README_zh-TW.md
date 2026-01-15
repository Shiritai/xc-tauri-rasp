# Rust Tauri ❤️ Raspberry Pi
[English](README.md) | [繁體中文](README_zh-TW.md)

這是一個開箱即用的工具，用於將 Rust Tauri 專案跨編譯為 Raspberry Pi 目標平台。

## 使用方法

執行 `xcompile.sh -h` 可查看說明：

```bash
Cross compile a rust tauri application to debian package for raspberry pi (armhf/arm64).

Syntax: ./xcompile.sh [-c|h] [-e|n|p|t|a ARG]

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
  -t <TARGET_PATH>
          to set path of compilation target path
          default value is .
  -c      clean up all compilation targets before cross compile
          default not to clean up
  -h      show the help message
```

## 設定檔 (Configuration)

您可以在 `xcompile.sh` 同級目錄下建立 `.xcompile` 檔案來設定預設值。我們在 `.xcompile.example` 中提供了一個包含預設值的範本。

```bash
cp .xcompile.example .xcompile
# 根據您的需求編輯 .xcompile
```

該檔案會被腳本 `source` 載入，因此您可以使用 Shell 變數。

```bash
# Example .xcompile
DEBIAN_VER="bullseye"
RASP_ARCH="arm64" # arm64 或 armhf
PROJECT_PATH="../my-project"
PROJECT="app"
TARGET_PATH="./dist"
DO_CLEANUP="true" # 設定為 "true" 以啟用 cargo clean
```

CLI 傳入的參數將永遠覆蓋 `.xcompile` 中的設定。

## 範例

情境：

* 專案名稱：`my_project`
* 專案路徑：`/path/to/my_project`
* Raspberry Pi 架構：`arm64` (ARMv8)，例如 Raspberry Pi 4b
* Raspberry Pi OS 基底版本 (Debian 版本)：`bookworm` (Debian 12)
* 編譯結果輸出路徑：`..` (Shell 的上層目錄)

您可以執行以下指令來跨編譯 Tauri 應用程式：

```bash
./xcompile.sh -e bookworm -n my_project -p /path/to/my_project -a arm64 -t ..
```

## 前置需求

* 已安裝 `docker` 且 `dockerd` 正在執行中

## 測試環境

|狀態|硬體|作業系統|
|:-:|:-:|:-:|
|✅|Raspberry Pi 4 Model B|Raspberry Pi OS - Debian 11 (bullseye) aarch64|
|✅|Raspberry Pi Zero 2 w|Raspberry Pi OS Lite - Debian 12 (bookworm) aarch64|


## CI/CD 整合

如果您正在尋找 GitHub Action 來自動化建置流程，請查看 [xc-tauri-rasp-action](https://github.com/Shiritai/xc-tauri-rasp-action)。

## 貢獻

我們歡迎任何形式的貢獻，歡迎提交 Issue 或 Pull Request :)
