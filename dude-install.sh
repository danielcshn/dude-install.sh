#!/bin/bash

##### Colors Used #####
Red="\e[1;91m"
Green="\e[0;92m"
Yellow="\e[0;93m"
Blue="\e[1;94m"
White="\e[0;97m"

##### Check if user is root or not #####
checkRoot () {
if ! [ $(id -u) = 0 ]; then
banner
echo "\n\n${White}[${Red}DudeInstaller${White}] Please run the tool as root or use sudo.\n"
exit 1
fi
clear
}

##### Check if winehq is installed or not #####
checkDependencies () {

checkRoot

if [ $(dpkg-query -W -f='${Status}' winetricks 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
echo "[${Red}Status${White}] Found missing dependencies..."
echo "[${Green}Status${White}] Installing wine...\n"

dpkg --add-architecture i386 
wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

if [ $(lsb_release -rs) = "22.04" ]; then
  wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
  sudo apt update
  apt install --install-recommends wine wine32 winetricks xdotool -y
  winetricks dotnet45
elif [ $(lsb_release -rs) = "21.10" ]; then
  wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/impish/winehq-impish.sources
  sudo apt update
  apt install --install-recommends wine wine32 winetricks xdotool -y
  winetricks dotnet45
elif [ $(lsb_release -rs) = "20.04" ]; then
  wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
  sudo apt update
  apt install --install-recommends wine wine32 winetricks xdotool -y
  winetricks dotnet45
elif [ $(lsb_release -rs) = "18.04" ]; then
  wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
  sudo apt update
  apt install --install-recommends wine wine32 winetricks xdotool -y
  winetricks dotnet45
else
  echo "Non-compatible version"
fi

fi
}

launchDude () {
wine ~/.wine/drive_c/Program\ Files/Dude/dude.exe &
}

dudeDownload () {
wget https://download.mikrotik.com/routeros/7.4.1/dude-install-7.4.1.exe
wine dude-install-7.4.1.exe &
# Wait until Wine initializes
while : ; do
    echo "Waiting for Wine to initialize..."
    sleep 2
    set +e  # Fix for: https://github.com/jordansissel/xdotool/issues/60
    WINDOW_ID=$(xdotool search --name "The Dude Setup")
    set -e
    [[ -z $WINDOW_ID ]] | break
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
banner () {
echo "${Red}
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
echo "${Yellow} \n A simple installer of The Dude Client for Linux!"
echo "${Green}\n Developed by: danielcshn ( https://github.com/danielcshn )"
echo "${Green} Version: 0.1"
}

##### Display available options #####
menu () {        
echo "\n${Yellow} [ Select Option To Continue ]\n"
echo " ${Red}[${Blue}1${Red}] ${Green}Check Dependencies"
echo " ${Red}[${Blue}2${Red}] ${Green}Install The Dude Client"
echo " ${Red}[${Blue}3${Red}] ${Green}Launch The Dude Client"
echo " ${Red}[${Blue}4${Red}] ${Green}Exit\n"
while true; do
echo "${Green}┌─[${Red}Select Option${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:"
read -p "└─────►$(tput setaf 7) " option
case $option in
  1) echo "\n[${Green}Selected${White}] Option 1 Check Dependencies..."
     checkDependencies
     ;;
  2) echo "\n[${Green}Selected${White}] Option 2 The Dude Client..."
     dudeDownload
     clear
     menu
     ;;
  3) echo "\n[${Green}Selected${White}] Option 3 Launch The Dude Client..."
     launchDude
     ;;
  4) echo "${Red}\nThank You for using the script ${White}:)\n"
     exit 0
     ;;
  *) echo "${White}[${Red}Error${White}] Please select correct option...\n"
     ;;
esac
done
}

dudeInstaller () {
clear
banner
menu
}

dudeInstaller
