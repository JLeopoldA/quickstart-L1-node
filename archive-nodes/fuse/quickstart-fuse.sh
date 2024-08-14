#!/bin/bash

# Quickstart for Fuse.

######INSTALL PREREQUISITES######
#################################
echo "Ceba - Starting Quickstart for Fuse"
apt-get update

###Curl###
if ! command -v curl &>/dev/null; then
	apt install -y curl
fi

##Install Docker##
echo "Installing ca-certificates for Docker"
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings

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
if ! command -v docker compose &>/dev/null; then
	echo "Installing Docker Compose..."
	apt-get update
	apt-get install docker-compose-plugin
else
	echo "Docker Compose is installed..."
fi


####Clone Fuse Repository###
############################
git clone https://github.com/fuseio/fuse-network.git ~/Dev/fuse-network
cd ~/Dev/fuse-network

# Download Quickstart script
wget -O quickstart.sh https://raw.githubusercontent.com/fuseio/fuse-network/master/nethermind/quickstart.sh
chmod 755 quickstart.sh

#Run Fuse 
./quickstart.sh -r explorer -n fuse -k quickstart-archive-node-fuse

