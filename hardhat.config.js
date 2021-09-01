require("@nomiclabs/hardhat-truffle5");
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
require("hardhat-gas-reporter");

const { alchemyApiKey, mnemonic } = require('./secrets.json');


module.exports = {
  solidity: {
    version: '0.8.4',
    settings: {
      optimizer: {
        enabled: true,
        runs: 20000, // TODO: target average DAO use
      },
    },
  },
  defaultConfig: {
    gas: "1000000"
  },
  networks: {
    rinkeby: {
      gas: 1000000,
      blockGasLimit: 1000000,
      gasMultiplier: 2,
      url: `${alchemyApiKey}`,
      accounts: {mnemonic: mnemonic}
    }
  }
};
