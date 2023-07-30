# Dockerized Ordinals

This repo demonstrate an attempt to use Ordinals in containerized environment.

Example is based on Docker Compose

Considerations:

1. `ord` is connecting to `bitcoind` via RPC URL, but its current implementation expects the RPC authentication configured on `bitcoind` side
2. To generate unique user and password RPC Auth see the `./scripts/rpcauth`, update the bitcoin.conf afterwards and set Environment variables (via .env file) for `ord`
3. `bitcoind` should be started first and fully synced before `ord` can start indexing
4. `bitcoind` should be launched with flag `txindex=1`.

## Quick Start

Run `bitcoind`:

```shell
docker compose up -d bitcoind
```

Check logs 

```shell
docker compose logs bitcoind -f --tail 100
```

Once `bitcoind` fully synced

```shell
docker compose up -d ord
```

## Requirements

### Bitcoin Transaction Database Index

If `txindex` is set to true (1), Bitcoin Core maintains an index of all transactions that have ever happened, which you can query using the remote procedure call (RPC) method `getrawtransaction` or the RESTful API call get-tx.

Can be verified in container: 

```shell
docker compose exec bitcoind bitcoin-cli getindexinfo
```
Expecting `"synced": true`.

Get details of the first Transaction should return without error:

```shell
docker compose exec bitcoind bitcoin-cli getrawtransaction "f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16 true
```

Or via JSON-RPC interface

```shell
curl --user foo --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getrawtransaction", "params": ["f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16", true]}' -H 'content-type: text/plain;' http://127.0.0.1:8332/
```


### Bitcoin config generator

https://jlopp.github.io/bitcoin-core-config-generator/


### Ordinals 

When starting `ord` the Bitcoin Block Index loading should be completed (usually few minutes), otherwise the following error:

```shell
ord  | error: JSON-RPC error: RPC error response: RpcError { code: -28, message: "Loading block index…", data: None }
```
