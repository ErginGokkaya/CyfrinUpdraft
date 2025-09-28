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