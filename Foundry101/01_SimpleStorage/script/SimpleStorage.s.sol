// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    SimpleStorage public simpleStorage;

    function setUp() public {}

    function run() public  returns (SimpleStorage) {

        // vm is a special cheatcode object provided by Foundry
        // startBroadcast tells Foundry to start sending transactions
        // from the private key specified in the environment variable
        vm.startBroadcast();
        // new keyword deploys a new contract
        simpleStorage = new SimpleStorage();

        vm.stopBroadcast();

        return simpleStorage;
    }
}