server:
	SKYNET_NODE_TYPE=server SKYNET_SERVER_NODE=bob@127.0.0.1 iex --name skynet_server@127.0.0.1 -S mix

client:
	SKYNET_NODE_TYPE=client SKYNET_SERVER_NODE=skynet_server@127.0.0.1 iex --name skynet_client@127.0.0.1 -S mix
