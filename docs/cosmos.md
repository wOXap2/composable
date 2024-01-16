To simplify the process, create an alias:
```
alias docker_cmd_000="docker run --rm -ti -v $(pwd)/private/test-node-000:/root woxap2/simd"
alias docker_cmd_001="docker run --rm -ti -v $(pwd)/private/test-node-001:/root woxap2/simd"
```

On both node:
```
docker_cmd_000 simd init test-node-000 --chain-id devnet-chain-000
docker_cmd_001 simd init test-node-001 --chain-id devnet-chain-000
```

On each node, add a new key:
```
docker_cmd_000 simd keys add test-000 --keyring-backend test
docker_cmd_001 simd keys add test-001 --keyring-backend test
```
mnemonic:
test-000: bubble code student cycle damage okay stone whip combine correct jar child anchor winter govern case age turtle edge candy grass prison seminar minor
test-001: bronze lady tourist brave erode category wage harbor address ill victory noodle gravity carpet castle stand romance bronze divert two sock bird find rotate

addresses:
test-000: cosmos15mtg3vrxh804tgyj4glxp24hmwt7ruztwndea4
test-001: cosmos1r820yvr04fcydwjsc970thze6qsgjjwtqv04lw

Get the key id for each key, in case I didn't noted from the output of the prev
command:
```
docker_cmd_000 simd keys show test-000 --address --keyring-backend test
docker_cmd_001 simd keys show test-001 --address --keyring-backend test
```

On each machine, create a new account and fund it with the same amount of
tokens:
```
docker_cmd_000 simd genesis add-genesis-account <KEY_FROM_ABOVE> 10000000000000000000000000stake --keyring-backend test
docker_cmd_000 simd genesis add-genesis-account <KEY_FROM_ABOVE> 10000000000000000000000000stake --keyring-backend test --append
docker_cmd_001 simd genesis add-genesis-account <KEY_FROM_ABOVE> 10000000000000000000000000stake --keyring-backend test
```
Add bootstrap TXs to genesis:
```
docker_cmd_000 simd genesis gentx test-000 1000000000stake --keyring-backend test --chain-id devnet-chain-000
docker_cmd_001 simd genesis gentx test-001 1000000000stake --keyring-backend test --chain-id devnet-chain-000
```

Next: prepare genesis.json file including the two nodes:
```
 cat private/test-node-000/.simapp/config/genesis.json | jq -r '.app_state.bank.balances'
[
  {
    "address": "cosmos1r820yvr04fcydwjsc970thze6qsgjjwtqv04lw",
    "coins": [
      {
        "denom": "stake",
        "amount": "10000000000000000000000000"
      }
    ]
  },
  {
    "address": "cosmos12z62704k984xamllnknlq365f5tzzm3kzqhlhj",
    "coins": [
      {
        "denom": "stake",
        "amount": "10000000000000000000000000"
      }
    ]
]
```

Now, we need to collect gentxs so I'm copying the genesis transactions from
every node:
```
docker_cmd_000 simd genesis collect-gentxs
```

Next, `config.toml` file was updated including the two nodes:
```
persistent_peers = "76877982701dd407dea86f2c609a857a1a2d4af3@10.88.135.150:26656,76877982701dd407dea86f2c609a857a1a2d4af3@10.88.135.155:26656"
```

Next, a docker network is required for the nodes to communicate:
```
 docker network create --driver=bridge --subnet=10.88.135.144/28 br-composable
1841cd6a31d2dd1e961fe57d8c8e864abcdcfa6d275ed8e7740978051bab6929
```

At this point, and after creating the genesis.json file including TXs from two
nodes we should be able to start each of the nodes but when doing so:

```
 docker run --rm -ti --ip 10.88.135.150 -v $(pwd)/private/test-node-000:/root woxap2/simd simd start
12:22PM INF starting node with ABCI CometBFT in-process module=server
12:22PM INF service start impl=multiAppConn module=proxy msg="Starting multiAppConn service"
12:22PM INF service start connection=query impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start connection=snapshot impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start connection=mempool impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start connection=consensus impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start impl=EventBus module=events msg="Starting EventBus service"
12:22PM INF service start impl=PubSub module=pubsub msg="Starting PubSub service"
12:22PM INF service start impl=IndexerService module=txindex msg="Starting IndexerService service"
12:22PM INF ABCI Handshake App Info hash=E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 height=0 module=consensus protocol-version=0 software-version=0.46.0-beta2-3126-g22683c593
12:22PM INF ABCI Replay Blocks appHeight=0 module=consensus stateHeight=0 storeHeight=0
12:22PM INF InitChain chainID=devnet-chain-000 initialHeight=1 module=server
12:22PM INF initializing blockchain state from genesis.json module=server
12:22PM INF Completed ABCI Handshake - CometBFT and App are synced appHash=E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 appHeight=0 module=consensus
12:22PM INF Version info abci=2.0.0 block=11 commit_hash= module=server p2p=8 tendermint_version=0.38.2
12:22PM INF This node is a validator addr=DBA7F573D7279FBCB0F30B74A6AFE4B369129BAD module=consensus pubKey=PubKeyEd25519{40700E7CAC93D4D7E36D5EA8DA0085E68290D04E860EAB5EB42DE7C0FA6476DB}
12:22PM INF P2P Node ID ID=f12cad515adcca5e21eef21ebb1a905ec7102992 file=/root/.simapp/config/node_key.json module=p2p
12:22PM INF Adding persistent peers addrs=["76877982701dd407dea86f2c609a857a1a2d4af3@172.17.0.30:26656","76877982701dd407dea86f2c609a857a1a2d4af3@172.17.0.31:26656"] module=p2p
12:22PM INF Adding unconditional peer ids ids=[] module=p2p
12:22PM INF Add our address to book addr=f12cad515adcca5e21eef21ebb1a905ec7102992@0.0.0.0:26656 book=/root/.simapp/config/addrbook.json module=p2p
12:22PM INF service start impl=Node module=server msg="Starting Node service"
12:22PM INF service start impl="P2P Switch" module=p2p msg="Starting P2P Switch service"
12:22PM INF service start impl=Evidence module=evidence msg="Starting Evidence service"
12:22PM INF service start impl=StateSync module=statesync msg="Starting StateSync service"
12:22PM INF service start impl=PEX module=pex msg="Starting PEX service"
12:22PM INF service start book=/root/.simapp/config/addrbook.json impl=AddrBook module=p2p msg="Starting AddrBook service"
12:22PM INF serve module=rpc-server msg="Starting RPC HTTP server on 127.0.0.1:26657"
12:22PM INF service start impl=Mempool module=mempool msg="Starting Mempool service"
12:22PM INF service start impl=Reactor module=blocksync msg="Starting Reactor service" 
12:22PM INF service start impl=BlockPool module=blocksync msg="Starting BlockPool service"
12:22PM INF service start impl=ConsensusReactor module=consensus msg="Starting Consensus service"
12:22PM INF Reactor  module=consensus waitSync=true
12:22PM ERR Can't add peer's address to addrbook err="Cannot add non-routable address 76877982701dd407dea86f2c609a857a1a2d4af3@172.17.0.30:26656" module=p2p
12:22PM ERR Can't add peer's address to addrbook err="Cannot add non-routable address 76877982701dd407dea86f2c609a857a1a2d4af3@172.17.0.31:26656" module=p2p
```

Which kinda makes sense, as the second node has not been started yet, but when
doing so:

```
 docker run --rm -ti --ip 10.88.135.155 -v $(pwd)/private/test-node-001:/root woxap2/simd simd start
12:22PM INF starting node with ABCI CometBFT in-process module=server
12:22PM INF service start impl=multiAppConn module=proxy msg="Starting multiAppConn service"
12:22PM INF service start connection=query impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start connection=snapshot impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start connection=mempool impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start connection=consensus impl=localClient module=abci-client msg="Starting localClient service"
12:22PM INF service start impl=EventBus module=events msg="Starting EventBus service"
12:22PM INF service start impl=PubSub module=pubsub msg="Starting PubSub service"
12:22PM INF service start impl=IndexerService module=txindex msg="Starting IndexerService service"
12:22PM INF ABCI Handshake App Info hash=E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 height=0 module=consensus protocol-version=0 software-version=0.46.0-beta2-3126-g22683c593
12:22PM INF ABCI Replay Blocks appHeight=0 module=consensus stateHeight=0 storeHeight=0
12:22PM INF InitChain chainID=devnet-chain-000 initialHeight=1 module=server
12:22PM INF initializing blockchain state from genesis.json module=server
Usage:
  simd start [flags]
(...)
error during handshake: error on replay: validator set is empty after InitGenesis, please ensure at least one validator is initialized with a delegation greater than or equal to the DefaultPowerReduction ({824645210592})
```

Next step: Investigate.

Possible workaround:
- Start the network with only one validator, and later add another one (but this
    does not meet the assigment requirements)
