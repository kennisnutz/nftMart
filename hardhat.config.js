require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");

const fs = require("fs")
const privateKey = fs.readFileSync(".secret").toString();

const projectId = "VkKgYuyXxAqbmzwWBKOaxbM9nlplyxtq"

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`,
      accounts: [privateKey],
      // gas: 2100000,
      // gasPrice: 8000000000,
      // saveDeployments: true,
    },
    mainnet: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${projectId}`,
      accounts: [privateKey]
    },
    // bscTestnet: {
    //   url: `https://polygon-mainnet.g.alchemy.com/v2/${projectId}`,
    //   accounts: [privateKey]
    // }

    // eth: {
    //   url: `https://eth-mainnet.g.alchemy.com/v2/${projectId}`,
    //   accounts: []
    // },

    // trx: {
    //   url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`,
    //   accounts: []
    // }
    // ,
    // bsc: {
    //   url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`,
    //   accounts: []
    // },
    // harmony: {
    //   url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`,
    //   accounts: []
    // }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: {
      polygonMumbai: "UUM311KI8CQ73RCVE24K893SXSVDGGEWMK"

    }
  },
  solidity: "0.8.9",
};
