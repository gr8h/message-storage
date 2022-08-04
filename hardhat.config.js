require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("dotenv").config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.10",
  networks: {
    rinkeby: {
      chainId: 4,
      url: process.env.DEV_RINKEBY_KEY,
      accounts: [process.env.PRIVATE_KEY],
      gas: 2100000,
      gasPrice: 8000000000
    },
    mainnet: {
      chainId: 1,
      url: process.env.PROD_MAINNET_KEY,
      accounts: [process.env.PRIVATE_KEY],
    }
  }
};
