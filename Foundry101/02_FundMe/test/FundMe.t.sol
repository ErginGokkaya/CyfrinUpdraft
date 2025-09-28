// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// the functions like assertEq come from the Test contract
// the console.log line comes from the console contract.. you can use console.log to debug the contracts 
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    
    FundMe fundMe;
    uint256 testValue = 1;
    // each test case first runs setUp()
    function setUp() external {
        testValue = 2;
        fundMe = new FundMe(address(0));
    }

    // a test function must start with "test"
    function testExample() external view {
        console.log("Hello World");
        assertEq(testValue, 2);
    }

    function testMinimumUSD() external view{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
}