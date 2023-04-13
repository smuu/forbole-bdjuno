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

apk add jq vim curl
wget --timeout=10 -q -O - consensus-validator-1.robusta-3.svc.cluster.local:26657/genesis? | jq -r '.result.genesis' > $HOME/.bdjuno/genesis.json
bdjuno parse genesis-file --genesis-file-path ~/.bdjuno/genesis.json
