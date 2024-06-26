#!/usr/bin/env bash
#
# ============================================================================ #
# The Dude Client for Mikrotik installer on Linux.                             #
# dude-install.sh                                                              #
# Autor: danielcshn                                                            #
# URL: https://github.com/danielcshn                                           #
# ============================================================================ #
# Version: v0.9 (20240424)                                                     #
# ============================================================================ #
# Copyright (c) 2022-2024 danielcshn                                           #
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

##### Support Install Zorin OS 16 (focal) < TESTED OK
function installZorinOS16() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -q -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-focal.sources
    if ! [ -f "$file2" ]; then
      wget -q -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
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

    printf "[${Green}Status${White}] Installing successful. Exit root mode, option 4 to exit.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 21 (vanessa) < TESTED OK
function installLinuxMint21() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -q -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-bullseye.sources
    if ! [ -f "$file2" ]; then
      wget -q -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
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

    printf "[${Green}Status${White}] Installing successful. Exit root mode, option 4 to exit.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 20 (ulyana) < TESTED OK
function installLinuxMint20() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -q -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-focal.sources
    if ! [ -f "$file2" ]; then
      wget -q -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
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

    printf "[${Green}Status${White}] Installing successful. Exit root mode, option 4 to exit.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Linux Mint 19 (tara) < TESTED OK
function installLinuxMint19() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    dpkg --add-architecture i386

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -q -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-bionic.sources
    if ! [ -f "$file2" ]; then
      wget -q -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
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

    printf "[${Green}Status${White}] Installing successful. Exit root mode, option 4 to exit.\n\n"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Wine & Tools Ubuntu
##### UBUNTU: https://wiki.winehq.org/Ubuntu

function installWineAndTools() {
  printf "[${Red}Status${White}] Found missing dependencies...\n\n"
  printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

  dpkg --add-architecture i386

  file1=/etc/apt/keyrings/winehq-archive.key
  if ! [ -f "$file1" ]; then
    mkdir -pm755 /etc/apt/keyrings > /dev/null
    wget -q -nc -P /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key > /dev/null
  fi

  local version=$1
  local codename=$2

  file2=/etc/apt/sources.list.d/winehq-$codename.sources
  if ! [ -f "$file2" ]; then
    wget -q -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$codename/winehq-$codename.sources
  fi

  printf "[${Green}Status${White}] Installing WineHQ (Devel)...\n"
  apt-get update > /dev/null && apt install --install-recommends winehq-devel -y > /dev/null
  winever="$(wine --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

  ## Tools
  printf "[${Green}Status${White}] Installing xdotool...\n"
  apt-get install xdotool -y > /dev/null
  xdotver="$(xdotool --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

  printf "[${Green}Status${White}] Installing winetricks...\n"
  apt-get install winetricks -y > /dev/null
  witrver="$(winetricks --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

  printf "[${Green}Status${White}] Installing dotnet45...\n"
  winetricks dotnet45 -f -q > /dev/null

  printf "[${Green}Status${White}] Installing successful. Exit root mode, option 4 to exit.\n\n"
}

##### Support: Ubuntu 24.04 (Noble Numbat) Beta

function installUbuntu2404() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    installWineAndTools "23.10" "mantic"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 23.10 (Mantic Minotaur)

function installUbuntu2310() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    installWineAndTools "23.10" "mantic"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 23.04 (Lunar Lobster)

function installUbuntu2304() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    installWineAndTools "23.04" "lunar"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 22.04 (Jammy Jellyfish)

function installUbuntu2204() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    installWineAndTools "22.04" "jammy"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 21.10 (Impish Indri)

function installUbuntu2110() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    installWineAndTools "21.10" "impish"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 20.04 (Focal Fossa)

function installUbuntu2004() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    installWineAndTools "20.04" "focal"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support: Ubuntu 18.04 (Bionic Beaver)

function installUbuntu1804() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    installWineAndTools "18.04" "bionic"
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Install Wine & Tools Debian
##### Debian: https://wiki.winehq.org/Debian

function installCommonPackages() {
  printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

  sudo dpkg --add-architecture i386

  ## Enable contrib & non-free sources list.
  sudo sed -i 's/$1 main/$1 main contrib non-free/g' /etc/apt/sources.list
  sudo sed -i 's/$2 main/$2 main contrib non-free/g' /etc/apt/sources.list
  sudo sed -i 's/$3 main/$3 main contrib non-free/g' /etc/apt/sources.list

  file1=/etc/apt/keyrings/winehq-archive.key
  if ! [ -f "$file1" ]; then
    sudo mkdir -pm755 /etc/apt/keyrings
    sudo wget -q -nc -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
  fi

  file2=/etc/apt/sources.list.d/winehq-$1.sources
  if ! [ -f "$file2" ]; then
    sudo wget -q -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/$1/winehq-$1.sources
  fi

  printf "[${Green}Status${White}] Installing WineHQ (Developed)...\n"
  sudo apt update > /dev/null && sudo apt install --install-recommends winehq-devel -y > /dev/null
  winever="$(wine --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}$winever${White}...\n"

  ## Tools
  printf "[${Green}Status${White}] Installing xdotool...\n"
  sudo apt install xdotool -y > /dev/null
  xdotver="$(xdotool --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}$xdotver${White}.\n"

  printf "[${Green}Status${White}] Installing winetricks...\n"

  sudo wget -q ${HOME}/Downloads https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  sudo chmod +x winetricks > /dev/null
  sudo cp winetricks /usr/local/bin > /dev/null

  # sudo apt install winetricks -y > /dev/null
  witrver="$(winetricks --version)"
  printf "[${Green}Status${White}] Current version: ${Purple}winetricks $witrver${White}.\n"

  printf "[${Green}Status${White}] Installing dotnet45...\n"
  sudo winetricks --self-update
  winetricks dotnet45 -f -q > /dev/null

  printf "[${Green}Status${White}] Installing successful. Exit root mode, option 4 to exit.\n\n"
}

##### Support Debian GNU/Linux 12 (Bookworm) < TESTED OK 24/04/2024

function installDebian12() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages bookworm bookworm-security bookworm-updates
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Debian GNU/Linux 11 (Bullseye) < TESTED OK 24/04/2024

function installDebian11() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages bullseye bullseye-security bullseye-updates
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Support Debian GNU/Linux 10 (Buster) < TESTED OK 24/04/2024

function installDebian10() {
  osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  printf "[${Green}Status${White}] $osversion... compatible.\n\n"

  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    installCommonPackages buster buster-security buster-updates
  else
    printf "[${Green}Status${White}] All dependencies are installed.\n\n"
  fi
}

##### Check if winehq is installed or not #####

function checkDependencies() {
  checkRoot

  ## Debian GNU/Linux

  if [ $(lsb_release -is) = "Debian" ]; then
    case $(lsb_release -rs) in 
      12)
        Compatible=true
        installDebian12
        ;;
      11)
        Compatible=true
        installDebian11
        ;;
      10)
        Compatible=true
        installDebian10
        ;;
      *)
        Compatible=false
        ;;
    esac
  fi

  ## Ubuntu

  if [ $(lsb_release -is) = "Ubuntu" ]; then
    case $(lsb_release -rs) in 
      24.04)
        Compatible=true
        installUbuntu2404
        ;;
      23.10)
        Compatible=true
        installUbuntu2310
        ;;
      23.04)
        Compatible=true
        installUbuntu2304
        ;;
      22.04)
        Compatible=true
        installUbuntu2204
        ;;
      21.10)
        Compatible=true
        installUbuntu2110
        ;;
      20.04)
        Compatible=true
        installUbuntu2004
        ;;
      18.04)
        Compatible=true
        installUbuntu1804
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

  ## Zorin OS

  if [ $(lsb_release -is | awk '{print tolower($0)}') = "zorin" ]; then
    case $(lsb_release -rs) in 
      16)
        Compatible=true
        installZorinOS16
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

  printf "${White}┌─[${Green}DudeInstaller${White}] Please indicate the version of The Dude Client\n"
  printf "${White}│ you want to install (Example: ${Purple}7.14.3${White}):\n"
  read -p "└──►$(tput setaf 7) " verdude

  wget -q https://download.mikrotik.com/routeros/$verdude/dude-install-$verdude.exe
  wine dude-install-$verdude.exe &
  # Wait until Wine initializes
  while : ; do
      printf "Waiting for Wine to initialize... This process is automatic."
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
  printf "${Green}\n Version: 0.9 (20240424)\n"
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
    1) printf "\n[${Green}Selected${White}] Option 1 Check Dependencies...\n\n"
       checkDependencies
       ;;
    2) printf "\n[${Green}Selected${White}] Option 2 The Dude Client...\n\n"
       dudeDownload
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
  clear
  banner
  menu
}

dudeInstaller
