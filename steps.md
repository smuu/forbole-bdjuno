# Steps

## Database

Start database

```shell
docker run -p 5432:5432 -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_DB=bdjuno docker.io/postgres:15.2-alpine3.17
```

Setup database

```shell
cd database/schema
```

Note: Password is `password`

```shell
psql -U user -d bdjuno -h localhost -f 00-cosmos.sql
psql -U user -d bdjuno -h localhost -f 01-auth.sql
psql -U user -d bdjuno -h localhost -f 02-bank.sql
psql -U user -d bdjuno -h localhost -f 03-staking.sql
psql -U user -d bdjuno -h localhost -f 04-consensus.sql
psql -U user -d bdjuno -h localhost -f 05-mint.sql
psql -U user -d bdjuno -h localhost -f 06-distribution.sql
psql -U user -d bdjuno -h localhost -f 07-pricefeed.sql
psql -U user -d bdjuno -h localhost -f 08-gov.sql
psql -U user -d bdjuno -h localhost -f 09-modules.sql
psql -U user -d bdjuno -h localhost -f 10-slashing.sql
psql -U user -d bdjuno -h localhost -f 11-feegrant.sql
psql -U user -d bdjuno -h localhost -f 12-upgrade.sql
```

## Celestia

```shell
docker run -p 26657:26657 -p 9090:9090 ghcr.io/rollkit/local-celestia-devnet:v0.8.2
```

## Bdjuno

https://github.com/smuu/forbole-bdjuno branch `chains/celestia/robusta`

Build bdjuno

```shell
make build
```

Save config.yaml to `~/.bdjuno/config.yaml`

```yaml
chain:
  bech32_prefix: celestia
  modules:
  - modules
  - messages
  # - auth
  - bank
  - consensus
  - gov
  - mint
  # - pricefeed
  - slashing
  - staking
  - distribution
  - actions
  # - history
node:
  type: remote
  config:
    rpc:
      client_name: juno
      address: http://localhost:26657
      max_connections: 20
    grpc:
      address: localhost:9090
      insecure: true
parsing:
    workers: 1
    start_height: 1
    average_block_time: 5s
    listen_new_blocks: true
    parse_old_blocks: true
    parse_genesis: true
database:
    url: postgresql://user:password@localhost:5432/bdjuno?sslmode=disable&search_path=public
    max_open_connections: 1
    max_idle_connections: 1
    partition_size: 100000
    partition_batch: 1000
logging:
    level: debug
    format: text
actions:
    host: 127.0.0.1
    port: 3000
```

Get `genesis.json` from celestia node

```shell
wget -q -O - localhost:26657/genesis | jq -r '.result.genesis' > ~/.bdjuno/genesis.json
```

Parse genesis

```shell
bdjuno parse genesis-file --home ~/.bdjuno --genesis-file-path ~/.bdjuno/genesis.json
```

## Error

```
ERROR: error while storing genesis transactions: error while unmashasling genesis tx: unable to resolve type URL /cosmos.staking.v1beta1.MsgCreateValidator
```
