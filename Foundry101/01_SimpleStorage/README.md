## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).

forge create can be used to deploy a contract
forge script can be used to run a deployment contract or something

- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.

In order to store special data use:
cast wallet import <variable name> --interactive
Enter the data and related password
Get `<variable name>` keystore was saved successfully. Address: <address of the data>
forge script script/SimpleStorage.s.sol --rpc-url $RPC_URL --account privateKey --sender <address of the data> --broadcast

In order to interact with the deployed contract:
cast send <to address> <function selector> <arguments> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call ---> same above.. this is for view functions

- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
