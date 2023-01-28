require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  console.log(process.env.URL);
  console.log(process.env.GOERLI_PRIVATE_KEY);
  for (const account of accounts) {
    console.log(account.address);
  }
});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: process.env.URL,
      accounts: [process.env.GOERLI_PRIVATE_KEY]
    }
  }
};
