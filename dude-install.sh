#!/usr/bin/env bash
#
# ============================================================================ #
# The Dude Client for Mikrotik installer on Linux.                             #
# dude-install.sh                                                              #
# Autor: danielcshn                                                            #
# URL: https://github.com/danielcshn                                           #
# ============================================================================ #
# Version: v1.2 (20261103)                                                     #
# ============================================================================ #
# Copyright (c) 2022-2026 danielcshn                                           #
# ============================================================================ #
#
# This Script comes with ABSOLUTELY NO WARRANTY!
#
# Standard ANSI colors (not "bright") with bold, so they stay readable on
# both dark and light terminal themes. "White" is the terminal's default
# foreground color, which adapts automatically to the current theme.
# https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124#file-bash-colors-md

Black="\e[1;30m"
Red="\e[1;31m" # Bold
Green="\e[1;32m"
Yellow="\e[1;33m"
Blue="\e[1;34m"
Purple="\e[1;35m"
Cyan="\e[1;36m"
White="\e[0m"

## Optional escape hatch for terminals/themes where colors are still a problem:
## NO_COLOR=1 ./dude-install.sh
if [ -n "${NO_COLOR:-}" ]; then
  Black=""; Red=""; Green=""; Yellow=""; Blue=""; Purple=""; Cyan=""; White=""
fi

Compatible=false
InstallFailed=false

## Run commands directly when the script is already running as root.
## This avoids requiring the "sudo" package, which is not installed by
## default on minimal Debian installations.
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

##### Read a value from /etc/os-release #####
function osReleaseValue() {
  local key="$1"
  local file="${2:-/etc/os-release}"

  [ -r "$file" ] || return 1

  awk -F= -v key="$key" '$1 == key {
    value = $0
    sub(/^[^=]*=/, "", value)
    gsub(/^"|"$/, "", value)
    print value
    exit
  }' "$file"
}

##### Detect the distribution without depending on lsb_release #####
function detectOS() {
  OS_ID=""
  OS_VERSION=""
  OS_CODENAME=""
  OS_UBUNTU_CODENAME=""
  OS_LIKE=""
  OS_NAME=""
  OS_PRETTY=""

  ## /etc/os-release is the standard source and is present on Debian 13+,
  ## LMDE 7 and every other modern distribution. lsb-release is optional.
  if [ -r /etc/os-release ]; then
    OS_ID="$(osReleaseValue ID /etc/os-release)"
    OS_VERSION="$(osReleaseValue VERSION_ID /etc/os-release)"
    OS_CODENAME="$(osReleaseValue VERSION_CODENAME /etc/os-release)"
    OS_UBUNTU_CODENAME="$(osReleaseValue UBUNTU_CODENAME /etc/os-release)"
    OS_LIKE="$(osReleaseValue ID_LIKE /etc/os-release)"
    OS_NAME="$(osReleaseValue NAME /etc/os-release)"
    OS_PRETTY="$(osReleaseValue PRETTY_NAME /etc/os-release)"
  fi

  ## Fallback for older systems where only lsb_release is available.
  if [ -z "$OS_ID" ] && command -v lsb_release > /dev/null 2>&1; then
    OS_ID="$(lsb_release -is 2>/dev/null)"
    OS_VERSION="$(lsb_release -rs 2>/dev/null)"
    OS_CODENAME="$(lsb_release -cs 2>/dev/null)"
    OS_PRETTY="$(lsb_release -ds 2>/dev/null)"
  fi

  ## Last resort: identify Debian from /etc/debian_version.
  if [ -z "$OS_ID" ] && [ -r /etc/debian_version ]; then
    OS_ID="debian"
    OS_VERSION="$(cut -d. -f1 /etc/debian_version)"
  fi

  OS_ID="$(printf '%s' "$OS_ID" | tr '[:upper:]' '[:lower:]')"
  OS_LIKE="$(printf '%s' "$OS_LIKE" | tr '[:upper:]' '[:lower:]')"
  OS_UBUNTU_CODENAME="$(printf '%s' "$OS_UBUNTU_CODENAME" | tr '[:upper:]' '[:lower:]')"

  [ -n "$OS_PRETTY" ] || OS_PRETTY="$(uname -om)"

  ## LMDE is Linux Mint with a Debian base. Unlike the Ubuntu-based
  ## editions it has no UBUNTU_CODENAME and its ID_LIKE does not mention
  ## Ubuntu.
  IS_LMDE=false
  if [ "$OS_ID" = "linuxmint" ]; then
    case "$OS_NAME" in
      LMDE*|lmde*)
        IS_LMDE=true
        ;;
      *)
        if printf '%s' "$OS_LIKE" | grep -qw debian &&
           ! printf '%s' "$OS_LIKE" | grep -qw ubuntu &&
           [ -z "$OS_UBUNTU_CODENAME" ]; then
          IS_LMDE=true
        fi
        ;;
    esac
  fi
}

##### Check if the script can elevate privileges when needed #####
function checkRoot() {
  ## Already root: no sudo needed.
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi

  ## sudo must exist and the current user must be allowed to use it.
  if command -v sudo > /dev/null 2>&1 && $SUDO -v; then
    return 0
  fi

  ## No usable sudo: stop instead of asking for a root password with su.
  ## Mixing su would install Wine in root's profile instead of the user's.
  printf "\n${White}[${Red}DudeInstaller${White}] $(id -un) cannot use ${Cyan}sudo${White} on this system.\n\n"
  printf "${White}Root privileges are required to install the dependencies.\n"
  printf "Add your user to the sudo group, then log out and back in:\n\n"
  printf "  ${Cyan}su -c 'apt install sudo'${White}\n"
  printf "  ${Cyan}su -c 'usermod -aG sudo $(id -un)'${White}\n\n"
  printf "${White}Or run the whole script as root:\n\n"
  printf "  ${Cyan}su -${White}\n"
  printf "  ${Cyan}./$(basename "${BASH_SOURCE[0]:-$0}")${White}\n\n"
  exit 1
}

##### Repair an interrupted dpkg run that blocks every apt operation #####
function repairPackageManager() {
  local audit

  ## apt refuses to continue while dpkg is half-configured:
  ## "E: se interrumpió la ejecución de dpkg..."
  audit="$($SUDO dpkg --audit 2>/dev/null)"
  [ -n "$audit" ] || return 0

  printf "[${Yellow}Alert${White}] A previous dpkg run was interrupted. Repairing it...\n"

  if ! $SUDO env DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a \
       dpkg --configure -a --force-confdef --force-confold; then
    printf "[${Red}Error${White}] dpkg could not be repaired automatically.\n"
    printf "Run ${Cyan}sudo dpkg --configure -a${White} manually, then try again.\n\n"
    return 1
  fi
}

##### Run apt without interactive prompts (debconf, needrestart, dpkg) #####
function aptUpdate() {
  repairPackageManager || return 1

  if ! $SUDO env DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get update; then
    printf "[${Red}Error${White}] apt-get update failed. Check your network and APT repositories.\n\n"
    return 1
  fi
}

function aptInstall() {
  $SUDO env DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a \
    apt-get install -y \
    -o Dpkg::Options::=--force-confdef \
    -o Dpkg::Options::=--force-confold "$@"
}

##### Install a small tool with whichever package manager exists #####
function installPackage() {
  local package="$1"

  if command -v apt-get > /dev/null 2>&1; then
    aptUpdate && aptInstall "$package"
  elif command -v dnf > /dev/null 2>&1; then
    $SUDO dnf install -y "$package"
  else
    printf "[${Red}Error${White}] No supported package manager found (apt or dnf).\n\n"
    return 1
  fi
}

function installWget() {
  checkRoot
  printf "[${Green}Status${White}] Installing wget...\n"
  installPackage wget
}

function installCabextract() {
  checkRoot
  printf "[${Green}Status${White}] Installing cabextract...\n"
  installPackage cabextract
}

##### Install Wine & Tools on Fedora (uses Fedora's Wine 11.x) #####
function installFedora() {
  checkRoot

  printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

  if ! command -v wget > /dev/null 2>&1; then
    installWget || {
      InstallFailed=true
      return 1
    }
  fi

  printf "[${Green}Status${White}] Installing wine, winetricks and cabextract...\n"

  if ! $SUDO dnf install -y wine winetricks cabextract; then
    printf "[${Red}Error${White}] wine could not be installed.\n\n"
    InstallFailed=true
    return 1
  fi

  winever="$(wine --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

  witrver="$(winetricks --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

  installDotnet

  printf "[${Green}Status${White}] Installing successful. Select option 2 to install The Dude Client.\n\n"
}

##### Support Install Zorin OS 18 (noble) < Ubuntu 24.04 base
function installZorinOS18() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "24.04" "noble"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Zorin OS 17 (jammy) < Ubuntu 22.04 base
function installZorinOS17() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "22.04" "jammy"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Zorin OS 16 (focal) < TESTED OK
function installZorinOS16() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "16" "focal"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 22 (wilma) < Ubuntu 24.04 base
function installLinuxMint22() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "24.04" "noble"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 21 (vanessa) < TESTED OK
function installLinuxMint21() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "21" "jammy"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 20 (ulyana) < TESTED OK
function installLinuxMint20() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "20.04" "focal"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 19 (tara) < TESTED OK
function installLinuxMint19() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "19" "bionic"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Install .NET Framework 4.5 only once per Wine prefix #####
function installDotnet() {
  ## The Dude Client needs .NET Framework 4.5. winetricks installs
  ## dotnet40 first and removes Wine Mono, so the first run is slow and
  ## shows the Wine Mono, .NET 4.0 and .NET 4.5 installers.
  if winetricks list-installed 2>/dev/null | tr -d '\r' | grep -qx "dotnet45"; then
    printf "[${Green}Status${White}] dotnet45 is already installed.\n"
    return 0
  fi

  printf "[${Green}Status${White}] Installing dotnet45 (Wine Mono, .NET 4.0 and 4.5)...\n"
  printf "${Yellow}Note:${White} This can take several minutes and opens a few installers.\n"

  if winetricks dotnet45 -f -q > /dev/null 2>&1; then
    printf "[${Green}Status${White}] dotnet45 installed.\n"
  else
    printf "[${Yellow}Alert${White}] dotnet45 could not be installed.\n"
  fi
}

##### Support Install Wine & Tools Ubuntu
##### UBUNTU: https://wiki.winehq.org/Ubuntu

function installWineAndTools() {
  local codename=$2

  checkRoot

  printf "[${Red}Status${White}] Found missing dependencies...\n\n"
  printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

  $SUDO dpkg --add-architecture i386

  ## wget may not be present on minimal installations.
  if ! command -v wget > /dev/null 2>&1; then
    printf "[${Green}Status${White}] Installing wget...\n"
    aptUpdate
    aptInstall wget
  fi

  file1=/etc/apt/keyrings/winehq-archive.key
  if ! [ -f "$file1" ]; then
    $SUDO mkdir -pm755 /etc/apt/keyrings > /dev/null
    $SUDO wget -q -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
  fi

  file2=/etc/apt/sources.list.d/winehq-$codename.sources
  if ! [ -f "$file2" ]; then
    $SUDO wget -q -O /etc/apt/sources.list.d/winehq-$codename.sources https://dl.winehq.org/wine-builds/ubuntu/dists/$codename/winehq-$codename.sources
  fi

  printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"

  if ! aptUpdate; then
    InstallFailed=true
    return 1
  fi

  if ! aptInstall --install-recommends winehq-devel; then
    printf "[${Red}Error${White}] winehq-devel could not be installed.\n\n"
    InstallFailed=true
    return 1
  fi

  winever="$(wine --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

  printf "[${Green}Status${White}] Installing cabextract...\n"
  aptInstall cabextract

  printf "[${Green}Status${White}] Installing winetricks...\n"
  aptInstall winetricks
  witrver="$(winetricks --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

  installDotnet

  printf "[${Green}Status${White}] Installing successful. Select option 2 to install The Dude Client.\n\n"
}

##### Support: Ubuntu 26.04 (Resolute Raccoon)

function installUbuntu2604() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "26.04" "resolute"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 24.04 (Noble Numbat)

function installUbuntu2404() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "24.04" "noble"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 23.10 (Mantic Minotaur)

function installUbuntu2310() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "23.10" "mantic"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 23.04 (Lunar Lobster)

function installUbuntu2304() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "23.04" "lunar"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 22.04 (Jammy Jellyfish)

function installUbuntu2204() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "22.04" "jammy"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 21.10 (Impish Indri)

function installUbuntu2110() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "21.10" "impish"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 20.04 (Focal Fossa)

function installUbuntu2004() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "20.04" "focal"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 18.04 (Bionic Beaver)

function installUbuntu1804() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    installWineAndTools "18.04" "bionic"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Wine & Tools Debian
##### Debian: https://wiki.winehq.org/Debian

function installCommonPackages() {
  local distro="$1"

  checkRoot

  printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

  $SUDO dpkg --add-architecture i386

  ## wget is used to download the WineHQ key, repository and winetricks.
  ## It is not guaranteed to be present on minimal installations.
  if ! command -v wget > /dev/null 2>&1; then
    printf "[${Green}Status${White}] Installing wget...\n"
    aptUpdate
    aptInstall wget
  fi

  file1=/etc/apt/keyrings/winehq-archive.key
  if ! [ -f "$file1" ]; then
    $SUDO mkdir -pm755 /etc/apt/keyrings
    $SUDO wget -q -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
  fi

  file2=/etc/apt/sources.list.d/winehq-$distro.sources
  if ! [ -f "$file2" ]; then
    $SUDO wget -q -O /etc/apt/sources.list.d/winehq-$distro.sources https://dl.winehq.org/wine-builds/debian/dists/$distro/winehq-$distro.sources
  fi

  printf "[${Green}Status${White}] Installing WineHQ (Developed)...\n"

  if ! aptUpdate; then
    InstallFailed=true
    return 1
  fi

  if ! aptInstall --install-recommends winehq-devel; then
    printf "[${Red}Error${White}] winehq-devel could not be installed.\n\n"
    InstallFailed=true
    return 1
  fi

  winever="$(wine --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

  printf "[${Green}Status${White}] Installing cabextract...\n"
  aptInstall cabextract

  printf "[${Green}Status${White}] Installing winetricks...\n"

  $SUDO wget -q -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  $SUDO chmod +x /usr/local/bin/winetricks

  witrver="$(winetricks --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

  installDotnet

  printf "[${Green}Status${White}] Installing successful. Select option 2 to install The Dude Client.\n\n"
}

##### Support Debian GNU/Linux 13 (Trixie)

function installDebian13() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages trixie
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support LMDE 7 (Gigi) < Debian 13 (Trixie) base

function installLmde7() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages trixie
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support LMDE 6 (Faye) < Debian 12 (Bookworm) base

function installLmde6() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages bookworm
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Debian GNU/Linux 12 (Bookworm) < TESTED OK 24/04/2024

function installDebian12() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages bookworm
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Debian GNU/Linux 11 (Bullseye) < TESTED OK 24/04/2024

function installDebian11() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages bullseye
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Debian GNU/Linux 10 (Buster) < TESTED OK 24/04/2024

function installDebian10() {
  osversion="$OS_PRETTY"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if ! command -v winetricks > /dev/null 2>&1; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages buster
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Check if winehq is installed or not #####

function checkDependencies() {
  detectOS

  ## Debian GNU/Linux

  if [ "$OS_ID" = "debian" ]; then
    case "$OS_VERSION" in
      13*)
        Compatible=true
        installDebian13
        ;;
      12*)
        Compatible=true
        installDebian12
        ;;
      11*)
        Compatible=true
        installDebian11
        ;;
      10*)
        Compatible=true
        installDebian10
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  ## Fedora Linux

  if [ "$OS_ID" = "fedora" ]; then
    case "$OS_VERSION" in
      43*|44*|45*)
        Compatible=true
        installFedora
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  ## Ubuntu

  if [ "$OS_ID" = "ubuntu" ]; then
    case "$OS_VERSION" in
      26.04*)
        Compatible=true
        installUbuntu2604
        ;;
      24.04*)
        Compatible=true
        installUbuntu2404
        ;;
      23.10*)
        Compatible=true
        installUbuntu2310
        ;;
      23.04*)
        Compatible=true
        installUbuntu2304
        ;;
      22.04*)
        Compatible=true
        installUbuntu2204
        ;;
      21.10*)
        Compatible=true
        installUbuntu2110
        ;;
      20.04*)
        Compatible=true
        installUbuntu2004
        ;;
      18.04*)
        Compatible=true
        installUbuntu1804
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  ## Linux Mint (Ubuntu-based) and LMDE (Debian-based)

  if [ "$OS_ID" = "linuxmint" ]; then
    if $IS_LMDE; then
      case "$OS_VERSION" in
        7*)
          Compatible=true
          installLmde7
          ;;
        6*)
          Compatible=true
          installLmde6
          ;;
        *)
          Compatible=false
          ;;
      esac
    else
      case "$OS_VERSION" in
        22*)
          Compatible=true
          installLinuxMint22
          ;;
        21*)
          Compatible=true
          installLinuxMint21
          ;;
        20*)
          Compatible=true
          installLinuxMint20
          ;;
        19*)
          Compatible=true
          installLinuxMint19
          ;;
        *)
          Compatible=false
          ;;
      esac
    fi
  fi

  ## Zorin OS

  if [ "$OS_ID" = "zorin" ]; then
    case "$OS_VERSION" in
      18*)
        Compatible=true
        installZorinOS18
        ;;
      17*)
        Compatible=true
        installZorinOS17
        ;;
      16*)
        Compatible=true
        installZorinOS16
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  ## Stop here if the Wine installation already failed (e.g. interrupted dpkg).
  if $InstallFailed; then
    return 1
  fi

  ## winetricks needs cabextract for several installers, including dotnet45.
  if $Compatible && ! command -v cabextract > /dev/null 2>&1; then
    installCabextract || return 1
  fi

  osversion="$OS_PRETTY"

  if ! $Compatible; then
    printf "[${Yellow}Alert${White}] Non-compatible version - $osversion.\n\n"
  fi
}

function launchDude() {
  file1=~/.wine/drive_c/Program\ Files/Dude/dude.exe
  if [ -f "$file1" ]; then
    wine ~/.wine/drive_c/Program\ Files/Dude/dude.exe &
  else
    wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Dude/dude.exe &
  fi
}

function dudeDownload() {
  local exe tries dude_exe wine_status

  if ! command -v wget > /dev/null 2>&1; then
    installWget || return 1
  fi

  printf "${White}┌─[${Green}DudeInstaller${White}] Please indicate the version of The Dude Client\n"
  printf "${White}│ you want to install (Example: ${Purple}7.14.3${White}):\n"

  ## -e enables readline so Home/Delete/arrow keys edit the line instead of
  ## being stored literally as escape sequences.
  read -r -e -p "└──►$(tput sgr0) " verdude

  ## Remove spaces and control characters, then require a plain version.
  verdude="$(printf '%s' "$verdude" | tr -d '[:space:][:cntrl:]')"

  if [ -z "$verdude" ]; then
    printf "[${Yellow}Alert${White}] No version was provided.\n\n"
    return 1
  fi

  if ! printf '%s' "$verdude" | grep -Eq '^[0-9A-Za-z._-]+$'; then
    printf "[${Yellow}Alert${White}] Invalid version: %q\n" "$verdude"
    printf "Use only numbers, letters, dots and dashes (example: 7.14.3).\n\n"
    return 1
  fi

  exe="dude-install-$verdude.exe"

  if ! wget -q "https://download.mikrotik.com/routeros/$verdude/$exe"; then
    printf "[${Red}Error${White}] Version $verdude was not found on the MikroTik server.\n\n"
    rm -f "$exe"
    return 1
  fi

  if [ ! -s "$exe" ]; then
    printf "[${Red}Error${White}] The installer download is empty or incomplete.\n\n"
    rm -f "$exe"
    return 1
  fi

  ## The installer is NSIS, so /S installs it without any window or prompt.
  ## This also avoids synthetic keyboard input (xdotool), which triggers the
  ## "Allow Remote Interaction" permission dialog on Wayland (Ubuntu 26.04).
  printf "[${Green}Status${White}] Installing The Dude Client...\n"
  wine "$exe" /S > /dev/null 2>&1
  wine_status=$?

  if [ "$wine_status" -ne 0 ]; then
    printf "[${Yellow}Alert${White}] Wine returned exit code $wine_status.\n"
  fi

  ## Wait for the executable to appear, in case wine returns early.
  tries=0
  while [ "$tries" -lt 30 ]; do
    for dude_exe in \
      "$HOME/.wine/drive_c/Program Files/Dude/dude.exe" \
      "$HOME/.wine/drive_c/Program Files (x86)/Dude/dude.exe"; do
      [ -f "$dude_exe" ] && break 2
    done
    sleep 2
    tries=$((tries + 1))
  done

  if [ -f "$HOME/.wine/drive_c/Program Files/Dude/dude.exe" ] ||
     [ -f "$HOME/.wine/drive_c/Program Files (x86)/Dude/dude.exe" ]; then
    printf "[${Green}Status${White}] The Dude Client installed successfully.\n\n"
  else
    printf "[${Red}Error${White}] The Dude Client could not be installed.\n"
    printf "Run ${Cyan}wine $exe /S${White} manually to see the error.\n\n"
    return 1
  fi

  ## Remove only the downloaded installer, never every .exe in the folder.
  rm -f "$exe"
}

##### Banner #####
function banner() {
  printf "${Red}
 TTTTTT  HH  HH  EEEEEE    DDDDD   UU  UU  DDDDD   EEEEEE 
   TT    HH  HH  EE        DD  DD  UU  UU  DD  DD  EE     
   TT    HHHHHH  EEEE      DD  DD  UU  UU  DD  DD  EEEE   
   TT    HH  HH  EE        DD  DD  UU  UU  DD  DD  EE     
   TT    HH  HH  EEEEEE    DDDDD    UUUU   DDDDD   EEEEEE 
                                                          
       CCCC   LL      IIIIII  EEEEEE  NN  NN  TTTTTT      
      CC  CC  LL        II    EE      NNN NN    TT        
      CC      LL        II    EEEE    NN NNN    TT        
      CC  CC  LL        II    EE      NN  NN    TT        
       CCCC   LLLLLL  IIIIII  EEEEEE  NN  NN    TT        "
  printf "${Yellow}\n\n A simple installer of The Dude Client for Linux!\n"
  printf "${Green}\n Developed by: danielcshn ( https://github.com/danielcshn )"
  printf "${Green}\n Version: 1.4 (20261103)\n"
}

##### Display available options #####
function menu() {
  printf "\n${Yellow} [ Select Option To Continue ]\n\n"
  printf " ${Red}[${Blue}1${Red}] ${Green}Check Dependencies\n"
  printf " ${Red}[${Blue}2${Red}] ${Green}Install The Dude Client\n"
  printf " ${Red}[${Blue}3${Red}] ${Green}Launch The Dude Client\n"
  printf " ${Red}[${Blue}4${Red}] ${Green}Exit\n\n"
  while true; do
  printf "${Green}┌─[${Red}Select Option${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:\n"
  read -r -e -p "└──►$(tput sgr0) " option
  case $option in
    1) printf "\n[${Green}Selected${White}] Option 1 Check Dependencies...\n\n"
       checkDependencies
       ;;
    2) printf "\n[${Green}Selected${White}] Option 2 The Dude Client...\n\n"
       dudeDownload
       printf "\n${White}Press Enter to return to the menu...${White} "
       read -r
       clear
       banner
       menu
       ;;
    3) printf "\n[${Green}Selected${White}] Option 3 Launch The Dude Client...\n\n"
       launchDude
       ;;
    4) printf "${Red}\nThank You for using the script ${White}:)\n\n"
       exit 0
       ;;
    *) printf "${White}[${Red}Error${White}] Please select correct option...\n\n"
       ;;
  esac
  done
}

function dudeInstaller() {
  detectOS
  clear
  banner
  menu
}

dudeInstaller
