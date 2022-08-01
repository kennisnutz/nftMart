require("@nomicfoundation/hardhat-toolbox");

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
      url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`
    }
  }
  solidity: "0.8.9",
};
