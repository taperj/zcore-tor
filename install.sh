#!/bin/bash
####################################################
# ZCORE MASTERNODE INSTALLER WITH TOR              #
#                                                  #
#  https://github.com/taperj/zcore-tor             #
#                                                  #
#  V. 0.0.1                                        #
#                                                  #
#  By: taperj                                      #
#                                                  #
####################################################
RED='\033[0;31m'
NC='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
WHITE='\033[1;37m'
#
#
#Root user check
if [ "$EUID" -ne 0 ]
  then printf "${YELLOW}Please run as root or with sudo. ${RED}Exiting.${NC}\n"
  exit
fi
#
#
printf "${WHITE}MMMMMMMMMMMMMMMMMMMMMMWNKOxdoc:;,,'''''''',,;:codxOKNWMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMWXOxoc;,'''''''''''''''''''''''',;:lxOXWMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMWKko:,'''''''''''''''''''''''''''''.....';lxKWMMMMMMMMMMMMMMM
MMMMMMMMMMMMWXkl;'''''''''''''''''''''''''''''............',lkXWMMMMMMMMMMMM
MMMMMMMMMMWKd:,''''''''''''''''''''''''''''..................';d0WMMMMMMMMMM
MMMMMMMMWKd;''''''''''''''''''''''''''..........................;oKWMMMMMMMM
MMMMMMWXx:''''''''''''''''''''''',coddddo:,.......................;dXWMMMMMM
MMMMMWOc,'''''''''''''''''''''',l0NWMMMMWNOl'......................':OWMMMMM
MMMMNx;'''''''''''''''''''''..'dNMMMMMMMMMMNd'.......................,dNMMMM
MMMXd,'''''''''''''''''''.....:0MMMMMMMMMMMM0:........................'oXMMM
MMXo,''''''''''''';ccc:;'..,cd0NMMMMMMMMMMMMN0dc,'.';:cc:,'............'oXMM
MNd,''''''''''',lkKNWWNXOxkKXKkdONMMMMMMMMNOdkKXKkxOXNWWNKkc'...........'oXM
Wk;''''''''''';xNMMMMMMMMMWOl;'.,cxOKKKKOxc,.';lOWMMMMMMMMMNd,...........,xW
0c''''''''''''lXMMMMMMMMMMNd'......',,,,'......'dNMMMMMMMMMMXc............:0
d,''''''''''''lXMMMMMMMMMMNd'..................'dNMMMMMMMMMMXc............'d
c''''''''''''';xNMMMMMMMMWk;....................;kWMMMMMMMMNd,.............:
;'''''''''''''',lkKWMWNXOl,......................,oOXNWMWKkc'..............,
,'''''''''''''''',c0M0l;'..........................',lKM0:'................'
'''''''''''''''''';OMO,..............................;OWk,..................
'''''''''''''''''';OMO,..............................,OWO,..................
,'''''''''''''''',l0MKd:,'........................',:dKMKc'................'
:'''''''''''''';o0NWMMWNKd;......................;dKNWMMWN0o,..............;
o,'''''''''''';kWMMMMMMMMW0:....................:0WMMMMMMMMNx,..........'''o
k;''''''''''''lXMMMMMMMMMMWd'..................'dWMMMMMMMMMMXl......'''''';k
Xo,'''''''''''lKMMMMMMMMMMWx,....';loddol;'....,xWMMMMMMMMMMKc...'''''''',oX
M0c''''''''''',oXWMMMMMMMWNXOdc;lOXWMMMMWXOl;cdOXNWMMMMMMMWXo,'''''''''''c0M
MWO:'''''''''''':dOKXXX0xlcdOKXXNMMMMMMMMMMNXXKkoclx0XXXKOd:,''''''''''':OWM
MMWO:''''''''''''',;::;,''''';dXMMMMMMMMMMMMXo;'...',;::;,''''''''''''':OWMM
MMMWOc'''''''''''''''''''''''';OWMMMMMMMMMMWk,..''''''''''''''''''''''c0WMMM
MMMMWKo,'''''''''''''''''''''''cOWMMMMMMMMWO:''''''''''''''''''''''',oKWMMMM
MMMMMMNk:''''''''''''''''''''''';ok0XXXX0ko;'''''''''''''''''''''',:kNMMMMMM
MMMMMMMWKd;'''''''''''''''''''''''',;:;;,'''''''''''''''''''''''';dKWMMMMMMM
MMMMMMMMMWKd:'''''''''''''''''''''''''''''''''''''''''''''''''':dKWMMMMMMMMM
MMMMMMMMMMMWKxc,'''''''''''''''''''''''''''''''''''''''''''',cxKWMMMMMMMMMMM
MMMMMMMMMMMMMWN0dc,'''''''''''''''''''''''''''''''''''''',cd0NWMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMWN0xl:,'''''''''''''''''''''''''''''',:lx0NWMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMWX0kdl:;,'''''''''''''''''',;:ldk0XWMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMWNKOkdl:;,,'''''',,;:ldxOKNWMMMMMMMMMMMMMMMMMMMMMMMM${NC}\n"
printf "${RED}***************************************************************************${NC}\n"
printf "${RED}****************${YELLOW}WELCOME TO THE ZCORE MASTERNODE INSTALLER${RED}****************${NC}\n"
printf "${YELLOW}******THIS SCRIPT WILL INSTALL A DOCKER CONTAINER WITH ZCORED AND TOR*****${NC}\n"
printf "${RED}***************************************************************************${NC}\n"
#
#
#Get install info:
#
printf "${WHITE}Enter the masternode privkey and hit enter:${NC}\n"
read MASTERNODEPRIVKEY
#
#
#Get masternode's public ip
#
printf "${WHITE}Detecting Public IP...${NC}\n"
#
#Check for cURL
if ! [ -x "$(command -v curl)" ]; then
        printf "${RED}cURL is not detected or not executable.${GREEN} Installing cURL.${NC}\n"
        apt-get -y install curl
fi
#
PUBLICIP=$(curl -s ifconfig.me)
printf "${GREEN}Public IP detected is: $PUBLICIP${NC}\n"
#
printf "${WHITE}Enter the ip you would like to use for the masternode and hit enter:${NC}\n"
read MASTERNODEADDR
#
#
#Port specification
#make sure not to conflict with tor on 9050 and 9051
#
printf "${WHITE}Enter the port number you'd like zcored to listen on if you are not using the main net, default Port 17293 will be used if no port specified. HINT: Most people will use the default.${NC}\n"
read PORTNUMBER

if [ "$PORTNUMBER" != "" ]
  then
        if [ "$PORTNUMBER" = "9050" ] || [ "$PORTNUMBER" = "9051" ]
                then
                        printf "${RED}Port $PORTNUMBER specified in user input. $PORTNUMBER is reserved for Tor. Exiting.${NC}\n"
                        printf "${RED}PLEASE RE-RUN THE SCRIPT SELECTING A DIFFERENT PORT.${NC}\n"
                        exit
        fi
          printf "${YELLOW}Port $PORTNUMBER specified in user input. Port $PORTNUMBER will be configured.${NC}\n"
  else
          printf "${YELLOW}No port number specified. Default main net Port 17293 will be used.${NC}\n"
          PORTNUMBER=17293
fi

#
#
#RPC
#
printf "${WHITE}Enter a username for RPC:${NC}\n"
read RPCUSER
printf "${WHITE}Enter a password for RPC:${NC}\n"
read RPCPASSWORD
printf "${WHITE}SANITY CHECK...${NC}\n"
#
#
#Sanity check
#
#####
#
#Check for docker
#
if ! [ -x "$(command -v docker)" ]; then
	printf "${RED}docker is not detected or not executable.${GREEN} Installing docker.${NC}\n"
	apt-get -y install docker docker.io
fi

if [ -x "$(command -v docker)" ]; then
        printf "${YELLOW}docker detected and executable.${GREEN} Continuing.${NC}\n"
fi

#
#
#Check for files and dirs needed
for file in zcore.conf Dockerfile services/zcored/run services/zcored/finish services/tor/run services/tor/finish services/stubby/run services/stubby/finish
do
if [ ! -f $file ]; then
	printf "${RED}SANITY CHECK FAILED: $file not found in the current directory, exiting!${NC}\n"
	exit
fi
done
#
#
##
for dir in services services/zcored services/tor services/stubby 
do
if [ ! -d $dir ]; then
	printf "${RED}SANITY CHECK FAILED: $dir directory not found, exiting!${NC}\n"
	exit
	fi
done
##
printf "${GREEN}SANITY CHECK PASSED!${NC}\n"
printf "${YELLOW}BEGINNING INSTALL...${NC}\n"
#
#
#
#
#Edit zcore.conf:
#
printf "${YELLOW}Editing zcore.conf...${NC}\n"
sed -i "s/masternodeprivkey=/masternodeprivkey=$MASTERNODEPRIVKEY/g" zcore.conf
sed -i "s/masternodeaddr=/masternodeaddr=$MASTERNODEADDR/g" zcore.conf
sed -i "s/rpcuser=/rpcuser=$RPCUSER/g" zcore.conf
sed -i "s/rpcpassword=/rpcpassword=$RPCPASSWORD/g" zcore.conf
sed -i "s/^port=/port=$PORTNUMBER/g" zcore.conf
#
#
#Edit Dockerfile
printf "${YELLOW}Editing Dockerfile...${NC}\n"
sed -i "s/HiddenServicePort 21786 127.0.0.1:21786/HiddenServicePort $PORTNUMBER 127.0.0.1:$PORTNUMBER/g" Dockerfile
#
#
#Build image
#
printf "${YELLOW}Building docker image zcore-tor...${NC}\n"
docker build -t zcore-tor-$PORTNUMBER .
#
#Create container
#
printf "${YELLOW}Creating container zcore-tor...${NC}\n"
docker create --name zcore-tor-$PORTNUMBER --restart=always -p $PORTNUMBER:$PORTNUMBER zcore-tor-$PORTNUMBER:latest
#
#
#Start container
#
printf "${YELLOW}Starting container zcore-tor...${NC}\n"
docker container start zcore-tor-$PORTNUMBER
sleep 10
docker ps
printf "${GREEN}INSTALLATION COMPLETE.${NC}\n"
printf "${YELLOW}ONCE SYNCED YOU CAN GET THE TOR(onion) ADDRESS TO ADD TO YOUR COLD WALLET masternode.conf as server address with:${NC}\n"
printf "${WHITE}$ sudo docker container exec zcore-tor-$PORTNUMBER grep advertising /home/zcored/.zcr/debug.log${NC}\n"
printf "${YELLOW}THE ABOVE COMMAND SHOULD OUTPUT SOMETHING LIKE THIS EXAMPLE OUTPUT:${NC}\n"
printf "${WHITE}2020-01-12 00:21:00 tor: Got service ID b2bbjwyvksnd6az4, advertising service zsddfken27kdsdx.onion:$PORTNUMBER${NC}\n"
printf "${YELLOW}in this example you would add ${GREEN}zsddfken27kdsdx.onion:$PORTNUMBER${YELLOW} to your cold wallet masternode.conf as ip addr for this alias. Yours will be different than the example.${NC}\n"
printf "${RED}IMPORTANT: IF YOU ARE RUNNING A FIREWALL MAKE SURE TO ALLOW PORT $PORTNUMBER/TCP FOR zcored${NC}\n"
printf "${YELLOW}Tips for the developer:${NC}\n"
printf "${YELLOW}BTC: 3HLx5AMe9S5SWzVqLwAib3oyGZm5nAAWKe${NC}\n"
printf "${YELLOW}ZCORE: zKG9pqY4HnYu7EZQbtG72k8FB3t1gtxuSY${NC}\n"
printf "${YELLOW}HAVE FUN ANONYMOUS ZCORE MASTERNODING!${NC}\n"
