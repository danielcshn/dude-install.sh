#!/usr/bin/env bash
#
# ============================================================================ #
# The Dude Client for Mikrotik installer on Linux.                             #
# dude-install.sh                                                              #
# Autor: danielcshn                                                            #
# URL: https://github.com/danielcshn                                           #
# ============================================================================ #
# Copyright (c) 2022 danielcshn                                                #
# ============================================================================ #
#
# This Script comes with ABSOLUTELY NO WARRANTY!
#
# High Intensty Colors Used:
# https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124#file-bash-colors-md

Black="\e[0;90m"
Red="\e[1;31m" # Bold
Green="\e[0;92m"
Yellow="\e[0;93m"
Blue="\e[0;94m"
Purple="\e[0;95m"
Cyan="\e[0;96m"
White="\e[0;97m"

Compatible=false

##### Check if user is root or not #####
function checkRoot() {
  if ! [ $(id -u) = 0 ]; then
  banner
  printf "\n\n${White}[${Red}DudeInstaller${White}] Please run the tool as root or use: sudo ./dude-install.sh \n\n\n"
  exit 1
  fi
}

##### Support Install Linux Mint 21 (vanessa) < TESTED OK
function installLinuxMint21(){
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-bullseye.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
    fi

    # At this time (August 7, 2022), Wine Stable remains unavailable.
    # https://wine.htmlvalidator.com/install-wine-on-ubuntu-22.04.html
    printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
    sudo apt-get update > /dev/null && sudo apt install --install-recommends winehq-devel -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 20 (ulyana) < TESTED OK
function installLinuxMint20(){
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-focal.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
    fi

    # At this time (August 7, 2022), Wine Stable remains unavailable. 
    printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
    sudo apt-get update > /dev/null && sudo apt install --install-recommends winehq-devel -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 19 (tara) < TESTED OK
function installLinuxMint19(){
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-bionic.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
    fi

    # At this time (August 7, 2022), Wine Stable remains unavailable. 
    printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
    sudo apt-get update > /dev/null
    sudo apt install --install-recommends winehq-devel -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Ubuntu 22.04 (bullseye) < TESTED OK
function intallUbuntu2204(){
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-bullseye.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
    fi

    # At this time (August 7, 2022), Wine Stable remains unavailable.
    # https://wine.htmlvalidator.com/install-wine-on-ubuntu-22.04.html
    printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
    sudo apt-get update > /dev/null && sudo apt install --install-recommends winehq-devel -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Ubuntu 21.10 (impish) < NOT TESTED
function intallUbuntu2110(){
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-impish.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/impish/winehq-impish.sources
    fi

    # At this time (August 7, 2022), Wine Stable remains unavailable. 
    printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
    sudo apt-get update > /dev/null && sudo apt install --install-recommends winehq-devel -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Ubuntu 20.04 (focal) < TESTED OK
function intallUbuntu2004(){
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-focal.sources
    if ! [ -f "$file2" ]; then
      sudo wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
    fi

    # At this time (August 7, 2022), Wine Stable remains unavailable. 
    printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
    sudo apt-get update > /dev/null && sudo apt install --install-recommends winehq-devel -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Ubuntu 18.04.6 (bionic) < TESTED OK
function intallUbuntu1804(){
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-bionic.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
    fi

    # At this time (August 7, 2022), Wine Stable remains unavailable. 
    printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
    sudo apt-get update > /dev/null && sudo apt install --install-recommends winehq-devel -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Debian GNU/Linux 11 (bullseye) < TESTED OK
function intallDebian11() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    ## Enable contrib & non-free sources list.
    sudo sed -i 's/bullseye main/bullseye main contrib non-free/g' /etc/apt/sources.list
    sudo sed -i 's/bullseye-security main/bullseye-security main contrib non-free/g' /etc/apt/sources.list
    sudo sed -i 's/bullseye-updates main/bullseye-updates main contrib non-free/g' /etc/apt/sources.list

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-bullseye.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources
    fi

    # sudo apt update && apt install --install-recommends wine wine32 winetricks xdotool -y > /dev/null
    printf "[${Green}Status${White}] Installing WineHQ (Stable)...\n"
    sudo apt-get update > /dev/null && apt-get install --install-recommends winehq-stable -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi

}

##### Support Install Debian GNU/Linux 10 (buster) < NOT TESTED
function intallDebian10() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    ## Enable contrib & non-free sources list.
    sudo sed -i 's/buster main/buster main contrib non-free/g' /etc/apt/sources.list
    sudo sed -i 's/buster-security main/buster-security main contrib non-free/g' /etc/apt/sources.list
    sudo sed -i 's/buster-updates main/buster-updates main contrib non-free/g' /etc/apt/sources.list

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-buster.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/buster/winehq-buster.sources
    fi

    # sudo apt update && apt install --install-recommends wine wine32 winetricks xdotool -y > /dev/null
    printf "[${Green}Status${White}] Installing WineHQ (Stable)...\n"
    sudo apt-get update > /dev/null && apt-get install --install-recommends winehq-stable -y > /dev/null
    winever="$(wine --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

    ## Tools
    printf "[${Green}Status${White}] Installing xdotool...\n"
    sudo apt-get install xdotool -y > /dev/null
    xdotver="$(xdotool --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

    printf "[${Green}Status${White}] Installing winetricks...\n"
    sudo apt-get install winetricks -y > /dev/null
    witrver="$(winetricks --version)"
    printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

    printf "[${Green}Status${White}] Installing dotnet45...\n"
    winetricks dotnet45 -f -q > /dev/null

    printf "[${Green}Status${White}] Installing successful.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi

}

##### Check if winehq is installed or not #####
function checkDependencies() {
  checkRoot

  ## Debian GNU/Linux 11 (bullseye)

  if [ $(lsb_release -is) = "Debian" ]; then
    case $(lsb_release -rs) in 
      11)
        Compatible=true
        intallDebian11
        ;;
      10)
        Compatible=true
        intallDebian10
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  ## Ubuntu

  if [ $(lsb_release -is) = "Ubuntu" ]; then
    case $(lsb_release -rs) in 
      22.04)
        Compatible=true
        intallUbuntu2204
        ;;
      21.10)
        Compatible=true
        intallUbuntu2110
        ;;
      20.04)
        Compatible=true
        intallUbuntu2004
        ;;
      18.04)
        Compatible=true
        intallUbuntu1804
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  ## LinuxMint

  if [ $(lsb_release -is | awk '{print tolower($0)}') = "linuxmint" ]; then
    case $(lsb_release -rs) in 
      21)
        Compatible=true
        installLinuxMint21
        ;;
      20)
        Compatible=true
        installLinuxMint20
        ;;
      19)
        Compatible=true
        installLinuxMint19
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"

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

  printf "${White}┌─[${Green}DudeInstaller${White}] Please indicate the version of The Dude Client you want to install:\n"
  read -p "└──►$(tput setaf 7) " verdude

  wget https://download.mikrotik.com/routeros/$verdude/dude-install-$verdude.exe
  wine dude-install-$verdude.exe &
  # Wait until Wine initializes
  while : ; do
      printf "Waiting for Wine to initialize..."
      sleep 2
      set +e  # Fix for: https://github.com/jordansissel/xdotool/issues/60
      WINDOW_ID=$(xdotool search --name "The Dude Setup")
      set -e
      [[ -z $WINDOW_ID ]] || break
  done
  
  # Set focus on installer window and act to install platform
  xdotool windowfocus $WINDOW_ID
  sleep 5
  xdotool key KP_Enter KP_Enter KP_Enter 
  sleep 1
  xdotool key KP_Enter
  sleep 5
  rm *.exe
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
  printf "${Green}\n Version: 0.7\n"
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
  read -p "└──►$(tput setaf 7) " option
  case $option in
    1) printf "\n[${Green}Selected${White}] Option 1 Check Dependencies...\n"
       checkDependencies
       ;;
    2) printf "\n[${Green}Selected${White}] Option 2 The Dude Client...\n"
       dudeDownload
       clear
       banner
       menu
       ;;
    3) printf "\n[${Green}Selected${White}] Option 3 Launch The Dude Client...\n"
       launchDude
       ;;
    4) printf "${Red}\nThank You for using the script ${White}:)\n"
       exit 0
       ;;
    *) printf "${White}[${Red}Error${White}] Please select correct option...\n"
       ;;
  esac
  done
}

function dudeInstaller() {
  clear
  banner
  menu
}

dudeInstaller
