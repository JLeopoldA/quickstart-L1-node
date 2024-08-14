This quickstart utilizes the quickstart provided by fuse.
It does not require an L1 node to operate, as it uses Nethermind.
This quickstart also uses a Docker container.

Download script.
Make executable: chmod +x quickstart-fuse.sh
Run: sudo ./quickstart-fuse.sh

Test your node with the following:
curl -H "Content-Type: application/json" \
-X POST --data '{"jsonrpc":"2.0", "method":"eth_blockNumber", "params":[], "id":1}' \
http://localhost:8545

Check Logs with the following:
docker logs [container-id OR container-name]

 
