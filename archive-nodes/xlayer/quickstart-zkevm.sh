#!/bin/bash

# Quickstart for xlayer's zkevm node.
# Requires an L1 node: https://github.com/JLeopoldA/quickstart-L1-node/tree/main 
# The above uses Geth and Prysm - may take hours to sync depending on CPU
# Node is available to access through http://localhost:8545 after running.
# Test node through the following commands:
# curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0", "method":"eth_blockNumber", "params":[], "id":83}' http://localhost:8545

# Programs needed - Docker, Docker-Compose 

######INSTALL PREQREQUISITES######
##################################

echo "Ceba - Create quickstart for xlayer-zkevm"
mkdir x-layer-zkevm && cd x-layer-zkevm

###Update###
echo "Updating..."
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

#Check Unzip#
#############
if ! command -v unzip &>/dev/null; then
	apt-get install unzip
fi

#####ZKEVM SET UP#####
######################
current_directory=$(pwd)
ZKEVM_NET=mainnet && ZKEVM_DIR="$current_directory" && ZKEVM_CONFIG_DIR=/"${ZKEVM_DIR}"/config

#Access zkevm#
curl -L https://github.com/0xPolygonHermez/zkevm-node/releases/latest/download/$ZKEVM_NET.zip > $ZKEVM_NET.zip && unzip -o $ZKEVM_NET.zip -d $ZKEVM_DIR && rm $ZKEVM_NET.zip
mkdir -p $ZKEVM_CONFIG_DIR && cp $ZKEVM_DIR/$ZKEVM_NET/example.env $ZKEVM_CONFIG_DIR/.env

mkdir data && mkdir ./data/pool-db && mkdir ./data/state-db # Create Data folders

##EDIT ENV##
port_number=8546
user_ip=$(hostname -I | awk '{print $1}')
env_to_edit="./config/.env"
cat <<EOL > "$env_to_edit"
ZKEVM_NETWORK="mainnet"
ZKEVM_NODE_ETHERMAN_URL="http://${user_ip}:${port_number}"
ZKEVM_NODE_STATEDB_DATA_DIR="../data/state-db"
ZKEVM_NODE_POOLDB_DATA_DIR="../data/pool-db"
EOL

# Run zkEVM node
docker compose --env-file $ZKEVM_CONFIG_DIR/.env -f $ZKEVM_DIR/$ZKEVM_NET/docker-compose.yml up -d








