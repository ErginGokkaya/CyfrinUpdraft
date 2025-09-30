// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// the functions like assertEq come from the Test contract
// the console.log line comes from the console contract.. you can use console.log to debug the contracts 
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundMeDeploy} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    
    FundMe fundMe;
    FundMeDeploy deployer;
    uint256 testValue = 1;
    // create a user address for testing with zero balance
    // makeAddr is a function provided by the forge-std Test contract
    address private immutable USER = makeAddr("user");
    uint256 private constant SENT_AMOUNT = 1 ether;
    uint256 private constant STARTING_BALANCE = 10 ether;

    // each test case first runs setUp()
    function setUp() external {
        testValue = 2;
        deployer = new FundMeDeploy();
        fundMe =deployer.run();

        vm.deal(USER, STARTING_BALANCE); // give USER amount of STARTING_BALANCE ETH
    }

    // a test function must start with "test"
    function testExample() external view {
        console.log("Hello World");
        assertEq(testValue, 2);
    }

    function testMinimumUSD() external view{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() external view {
        // you may intiutively assume that the owner is msg.sender. but it's not.
        // because the FundMe contract is created by the FundMeTest contract.
        // us(msg.sender) -> FundMeTest contract -> FundMe contract
        // so below is not correct:
        // assertEq(fundMe.getOwner(), msg.sender);
        // assertEq(fundMe.getOwner(), address(this));

        // after deployer modification, above became wrong as well.
        // correct one is below: 
        // us(msg.sender) -> FundMeTest contract -> FundMeDeployer contract -> FundMe contract
        assertEq(fundMe.getOwner(), msg.sender);
        console.log("owner is ", fundMe.getOwner());
        console.log("test contract is ", address(this));
        console.log("deployer contract is ", address(deployer));
        console.log("msg.sender is ", msg.sender);
        console.log("tx.origin is ", tx.origin);
        console.log("fundMe contract is ", address(fundMe));
    }

    // sample test:
    // forge test -vvv --mt testPriceFeedVersion --fork-url $SEPOLIA_RPC_URL
    function testPriceFeedVersion() external view {
        assertEq(fundMe.getVersion(),4);
    }

    function testFundFailWithoutEnoughETH() external {
        // expectRevert means the next line should revert
        vm.expectRevert();
        fundMe.fund{value: 1e15}(); // 0.001 ETH is less than minimum 5 USD
    }

    function testFundUpdatesFundedDataStructure() external {
        vm.prank(USER); // next tx will be sent by address(1)
        fundMe.fund{value: SENT_AMOUNT}(); // 1 ETH
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SENT_AMOUNT);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SENT_AMOUNT}();
        _;
    }

    function testWithdrawOnlyOwner() external funded {
        // expectRevert means the next line should revert   
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawFromMultipleFunders() external funded {
        // Arrange
        uint160 numberOfFunders = 13;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            // we need to convert i to address type
            // address(i) does not work, because address is 20 bytes, but uint160 is 20 bytes
            // so we need to convert uint160 to uint160 first, then to address
            address funder = address(i);
            //// give funder some ETH
            //vm.deal(funder, STARTING_BALANCE);
            //// prank the next tx to be sent by funder
            //vm.prank(funder);
            // hoax is a combination of deal and prank
            hoax(funder, STARTING_BALANCE);
            fundMe.fund{value: SENT_AMOUNT}(); // 1 ETH
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        console.log("startingOwnerBalance:", startingOwnerBalance);
        console.log("startingFundMeBalance:", startingFundMeBalance);
        console.log("endingOwnerBalance:", fundMe.getOwner().balance);
        // Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }
}