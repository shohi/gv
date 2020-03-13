#!/usr/bin/env bash

# TODO: remove `g` dependency and use golang download api directly.
function _gv_test_requirements() {
  if [[ ! "$(command -v curl)" ]]; then
    echo "gv: You must install curl"
    return 1
  elif [[ ! "$(command -v jq)" ]]; then
    echo "gv: You must install jq"
    return 1
  elif [[ ! "$(command -v file)" ]]; then
    echo "gv: You must install file"
    return 1
  fi

  # macOS: verify greadlink installed
  if [[ "$GV_OS_ARCH" == "darwin"* ]]; then
    if [[ ! "$(command -v greadlink)" ]]; then
      echo "gv: You must install coreutils"
      return 1
    fi
  fi
}

function _gv_get_os_and_arch() {
  local _uname
  local _arch

  _uname="$(uname -s)"
  _arch="$(uname -m)"

  case "${_uname}" in
    Linux) machine=linux ;;
    Darwin) machine=darwin ;;
    *) machine="UNKNOWN:${_uname}" ;;
  esac

  case "${_arch}" in
    i386) architecture="386" ;;
    arm) architecture="arm" ;;
    arm64) architecture="arm64" ;;
    x86_64) architecture="amd64" ;;
    *) architecture="UNKNOWN:${_arch}" ;;
  esac

  if [[ "$machine" == "darwin" ]]; then
    echo "$machine-amd64"
    return 0
  fi

  echo "$machine-$architecture"
}

# test whether `g` command has been installed.
function _gv_test_g() {
  if [ -e $GV_G ]; then
    return 0
  fi

  local g_version="1.1.1"
  local G_TOOLS="${GV_HOME}/tools"
  mkdir -p "${G_TOOLS}"
  local url="https://github.com/voidint/g/releases/download/v${g_version}/g${g_version}.${GV_OS_ARCH}.tar.gz"
  local dest_file="${G_TOOLS}/g${g_version}.${GV_OS_ARCH}.tar.gz"
  curl -L -s -o "${dest_file}" "${url}"
  tar -xz -f ${dest_file} -C ${GV_BINARY_PATH}
  chmod +x "${GV_G}"
}

function gv_list_remote() {
  echo "Fetching versions..."
  _gv_test_g
  $GV_G ls-remote
}

function gv_list() {
  _gv_test_g
  ${GV_G} ls
}

function gv_install() {
  _gv_test_g

  VERSION="$1"
  if [[ -z "$VERSION" ]]; then
    echo "please specify version"
    return 1
  fi
  ${GV_G} install "${VERSION}"
}

function gv_uninstall() {
  _gv_test_g

  VERSION="$1"
  if [[ -z "$VERSION" ]]; then
    echo "please specify version"
    return 1
  fi
  ${GV_G} uninstall "${VERSION}"
}

function gv_use() {
  _gv_test_g

  VERSION="$1"
  if [[ -z "$VERSION" ]]; then
    echo "please specify version"
    return 1
  fi
  ${GV_G} use "${VERSION}"
}

function gv_help() {
  echo "Usage: gv <command> [<options>]"
  echo "Commands:"
  echo "    list-remote   List all installable versions"
  echo "    list          List all installed versions"
  echo "    install       Install a specific version"
  echo "    use           Switch to specific version"
  echo "    uninstall     Uninstall a specific version"
}

function gv_init() {
  GV_HOME="${GV_HOME:-$HOME/.g}"
  GV_OS_ARCH="$(_gv_get_os_and_arch)"
  GOROOT="${GV_HOME}/go"
  GV_G="${GV_HOME}/bin/g"

  GV_BINARY_PATH="${GV_HOME}/bin"

  export GV_HOME
  export GV_OS_ARCH
  export GOROOT
  export GV_G

  if [[ ! -e "$GV_HOME" ]]; then
    mkdir -p "$GV_HOME"
  fi
  if [[ ! -e "$GV_BINARY_PATH" ]]; then
    mkdir -p "$GV_BINARY_PATH"
  fi

  # Only add GV_BINARY_PATH and GOROOT to PATH if it's not already part of the PATH
  if [[ "$PATH" != *"$GV_BINARY_PATH"* ]]; then
    export PATH="$GV_BINARY_PATH:$PATH"
  fi

  local goroot_bin="${GOROOT}/bin"
  if [[ "$PATH" != *"${goroot_bin}"* ]]; then
    export PATH="${goroot_bin}:$PATH"
  fi
}

function gv() {
  ACTION="$1"
  ACTION_PARAMETER="$2"

  _gv_test_requirements
  [[ $? = 1 ]] && return 1

  case "${ACTION}" in
    "list-remote")
      gv_list_remote
      ;;
    "list")
      gv_list
      ;;
    "install")
      gv_install "$ACTION_PARAMETER"
      ;;
    "uninstall")
      gv_uninstall "$ACTION_PARAMETER"
      ;;
    "use")
      gv_use "$ACTION_PARAMETER"
      ;;
    *)
      gv_help
      ;;
  esac
}

gv_init
