Quickstart for running an archive node through zkevm for xlayer.
zkevm is run through a Docker container.
Requires a fully synced L1 node to function correctly - if not,
errors will be thrown.

A quickstart for an L1 node is provided below.
The quickstart L1 node uses Geth for execution and Prysm for consensus.
https://github.com/JLeopoldA/quickstart-L1-node/tree/main

To run - download quickstart-zkevm.sh 
Make executable: chmod +x quickstart-zkevm.sh
Run: sudo ./quickstart-zkevm.sh
The working directory zkevm is run in will be where information is stored.

To access the logs -
docker logs [container-id OR container-name]

To stop the process
docker stop $(docker ps -q) && docker rm $(docker ps -aq)
