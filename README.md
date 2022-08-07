# Message Storage

The purpose of this smart contract to retrieves a text from a real-world API and stores it on the Ethereum blockchain.

  - [Assumptions](#assumptions)
  - [Enviroment variables](#enviroment-variables)
  - [Interact with the deployed smart-contract](#interact-with-the-deployed-smart-contract)
  - [Run Tests](#run-tests)
  - [Run Deploy](#run-deploy)
  - [Tools](#tools)

## Assumptions
* Using https://www.quicknode.com/ to call the ETH Rinkeby testnet.

## Enviroment variables
* DEV_RINKEBY_KEY=`[Rinkeby test network key]`
* PROD_MAINNET_KEY=`[Mainnet network key]`
* PRIVATE_KEY=`[Private Key]`
* CHAINLINK_TOKEN_ADDRESS=`[Chainlink LINK token address]`
* CHAINLINK_ORACLE_ADDRESS=`[Chainlink Oracle address]`
* CHAINLINK_JOBID=`[Chainlink Job ID]`
* EXTERNAL_API_URL=`[External API URL]`
* EXTERNAL_API_PATH=`[External API Path]`


## Interact with the deployed smart-contract
* Smart-contract [address](https://rinkeby.etherscan.io/address/0xD841b6e9479E708735C51dea7EC5Ba165EA523c9)
  * Get balance
  * Update message
```bash
npm run execute
```

## Run Tests
* Run unit-test cases aginist the moked smart-contracts
  * [MockLink](contracts/mocks/MockLink.sol) [Ref](https://github.com/pappas999/chainlink-hardhat-box/blob/main/contracts/test/MockLink.sol)
  * [MockMessageStorage](contracts/mocks/MockMessageStorage.sol)
```bash
npm run test
```

## Run Deploy
* Deploy the contract to Rinkeby test network

## Tools
  * Solidity
  * Hardhat
  * Chainlink [Get > Bytes](https://github.com/translucent-link/chainlink-node-jobs/tree/main/ethereum-rinkeby/Get%20%3E%20Bytes)