#!/bin/bash

# Intent is to allow installation of all necessary programs to instantiate an L1 node.
# Steps to take involve installation of various programs 

# Programs needed are Docker, Docker-Compose, Geth, Prysm. 
# Installation occurs in your current working directory.

######INSTALL PREQREQUISITES######
##################################

echo "ceba - xlayer Archive Node"
##Create Directory##
####################
mkdir ceba-xlayer && cd ceba-xlayer 

# Check for curl
if ! command -v curl &>/dev/null; then
	echo "curl is not installed. Installing..."
	apt install -y curl
fi

##Update##
##########
echo "Updating system..."
apt-get update

echo "Installing ca-certificates..."
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings

##Install Docker##
##################
if ! command -v docker &>/dev/null; then
	echo "Installing Docker..."
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
	-o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc

	##Add the repository to Apt sources##
	#####################################
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
	https://download.docker.com/linux/ubuntu \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null

	apt-get update

	#Install Docker Packages#
	#########################
	apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
	docker-compose-plugin

	echo "Docker is now installed..."
else 
	echo "Docker is installed..."
fi

##Install Docker Compose##
##########################
if ! command -v docker compose &>/dev/null; then
	echo "Installing Docker Compose..."
	apt-get update
	apt-get install docker-compose-plugin
else
	echo "Docker Compose is installed..."
fi

##Install Geth##
################
if ! command -v geth &>/dev/null; then
	echo "Installing stable version of go-ethereum..."
	add-apt-repository -y ppa:ethereum/ethereum # Enabling launchpad repository
	apt-get update
	apt-get install ethereum
	apt-get upgrade geth
else 
	echo "Geth is already installed..."
fi

#Create Folder structure#
#########################
echo "Creating folder structure for Geth and Prysm..."
mkdir ethereum && cd ethereum
mkdir consensus && mkdir execution

####Set up Prysm####
####################
echo "Setting up Prysm..."
cd consensus
curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh \
--output prysm.sh && chmod +x prysm.sh

#Generate JWT token to authenticate connection between beacon and execution node
echo "Generating JWT token..."
./prysm.sh beacon-chain generate-auth-secret
mv jwt.hex ../
cd ..

####Set up Geth####
###################
echo "Setting up Geth..."
cd execution
current_directory=$(pwd)
echo "$current_directory"
geth_location=$(whereis -b geth | awk '{print $2}') # Obtain location of Geth
echo "$geth_location"
if [ -z "$geth_location" ]; then
	echo: "geth not found..."
	echo "Installing stable version of go-ethereum..."
        add-apt-repository -y ppa:ethereum/ethereum # Enabling launchpad repository
        apt-get update
        apt-get install ethereum
	apt-get upgrade geth
else 
	mv "$geth_location" "geth"
fi

##ENSURE INSTALL OF dbus-x11##
##############################
if ! command -v dbus-x11 &>/dev/null; then
	echo "Installing dbus-x11"
	apt-get install dbus-x11
fi

##Run GETH##
############
echo "Running Geth..."
gnome-terminal --working-directory="$PWD" -- bash -c \
"./geth --mainnet --http --http.api eth,net,engine,admin --http.port 8546 --authrpc.jwtsecret=../jwt.hex \
--ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.api eth,net,web3; exec bash"

##Run Beacon Node##
###################
cd .. && cd consensus
echo "Running Prysm as Beacon Node"
gnome-terminal --working-directory="$PWD" -- bash -c \
"./prysm.sh beacon-chain --execution-endpoint=http://localhost:8551 --mainnet \
--jwt-secret=../jwt.hex  --checkpoint-sync-url=https://beaconstate.info --genesis-beacon-api-url=https://beaconstate.info; \
exec bash"




