// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggragator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 public constant LOCAL_CHAIN_ID = 31337;

    NetworkConfig private activeNetworkConfig;

    constructor() {
        if (block.chainid == ETH_SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaETHUSDConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaETHUSDConfig() internal pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    // bucause of vm object, this function cannot be view or pure
    // because vm is not a constant, it's provided by the forge framework during runtime
    function getOrCreateAnvilConfig() internal returns (NetworkConfig memory) {
        // If we already have a price feed, we don't need to create one 
        if (activeNetworkConfig.priceFeed != address(0)) { 
            return activeNetworkConfig;
        }

        // 1. Deploy the mocks
        // 2. Return the mock address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }

    function getActiveNetworkConfig() public returns (NetworkConfig memory) {
        if (block.chainid == 11155111) {
            return getSepoliaETHUSDConfig();
        }
        return getOrCreateAnvilConfig();
    }
}