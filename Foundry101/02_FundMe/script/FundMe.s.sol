// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// functions like vm.startBroadcast come from Script
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract FundMeDeploy is Script{
    FundMe fundMe;
    
    function run() external  returns (FundMe){
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory networkConfig = helperConfig.getActiveNetworkConfig();
        address priceFeed = networkConfig.priceFeed;
        
        vm.startBroadcast();
        fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();

        return fundMe;
    }
}
