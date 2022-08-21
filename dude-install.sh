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

##### Check if user is root or not #####
checkRoot() {
  if ! [ $(id -u) = 0 ]; then
  banner
  echo "\n\n${White}[${Red}DudeInstaller${White}] Please run the tool as root or use sudo.\n"
  exit 1
  fi
}

##### Check if winehq is installed or not #####
checkDependencies() {
  checkRoot
  
  if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    printf "[${Red}Status${White}] Found missing dependencies...\n\n"
    printf "[${Green}Status${White}] Installing wine and dependencies...\n\n"

    osversion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  
  if [ $(lsb_release -rs) = "22.04" ]; then

    printf "[${Green}Status${White}] $osversion... compatible.\n\n"

    dpkg --add-architecture i386 

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-jammy.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
    fi
    
    sudo apt update && apt install --install-recommends wine wine32 winetricks xdotool --force-yes --yes > /dev/null
    winetricks dotnet45
  elif [ $(lsb_release -rs) = "21.10" ]; then
    printf "[${Green}Status${White}] $osversion... compatible.\n\n"

    dpkg --add-architecture i386 

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-jammy.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/impish/winehq-impish.sources
    fi

    sudo apt update && apt install --install-recommends wine wine32 winetricks xdotool --force-yes --yes > /dev/null
    winetricks dotnet45
  elif [ $(lsb_release -rs) = "20.04" ]; then
    printf "[${Green}Status${White}] $osversion... compatible.\n\n"

    dpkg --add-architecture i386 

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-jammy.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
    fi

    sudo apt update && apt install --install-recommends wine wine32 winetricks xdotool --force-yes --yes > /dev/null
    winetricks dotnet45
  elif [ $(lsb_release -rs) = "18.04" ]; then
    printf "[${Green}Status${White}] $osversion... compatible.\n\n"

    dpkg --add-architecture i386 

    file1=/usr/share/keyrings/winehq-archive.key
    if ! [ -f "$file1" ]; then
      wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    fi

    file2=/etc/apt/sources.list.d/winehq-jammy.sources
    if ! [ -f "$file2" ]; then
      wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
    fi

    sudo apt update && apt install --install-recommends wine wine32 winetricks xdotool --force-yes --yes > /dev/null
    winetricks dotnet45
  else
    printf "Non-compatible version - $osversion.\n\n"
  fi
  
  fi
}

launchDude() {
  wine ~/.wine/drive_c/Program\ Files/Dude/dude.exe &
}

dudeDownload() {
  wget https://download.mikrotik.com/routeros/7.4.1/dude-install-7.4.1.exe
  wine dude-install-7.4.1.exe &
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
banner() {
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
  printf "${Green}\n Version: 0.3\n"
}

##### Display available options #####
menu() {
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

dudeInstaller() {
  clear
  banner
  menu
}

dudeInstaller
