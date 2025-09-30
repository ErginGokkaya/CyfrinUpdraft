Notes

- So as to import contract with a relative path like "@chainlink/contracts/" you may need to download first. Use the command below to get them in your terminal

'''
forge install smartcontractkit/chainlink-brownie-contracts@1.1.1
'''

once you have the libs and contracts, you may need to remap the path to refer "@chainlink/contracts/". To do that, add the below line into youtr foundry.toml file

'''
remappings = ["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/"]
'''


- To run the all cases, execute the below
'''
forge test -vv
'''

- To run a single test case
'''
forge test -mt <testcase_name>
'''

- if you don't specify the RPC_URL or something, foundry calls anvil on behalf of you as default.


// Unit test: testing individual units of code (functions)
// Integration test: testing how different units work together
// Forked test: testing our code on a forked mainnet (or testnet) state.. it is like a simulation
// Staging test: testing our code on a real testnet (not a fork, but the actual testnet)

- For forked test, use an RPC URL from somewhere like alchemy

- In order to see the test case coverage, use below:
'''
forge coverage --forked-url $YOUR_FORKED_URL
'''

- To simulate a contract like a price feed in your local blockchain such as anvil, use mocks:

## 🚀 Never Forget!!! Foundry Cheatcodes are Treasure 🚀

- test case organization approach:
    function testABC() external{
        // Arrange

        // Act

        // Assert
    }

- To see how much gas is spent for a test, use forge snapshot

- To check the storage: forge inspect <ContractName> storageLayout