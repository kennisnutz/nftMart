// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { getAccountPath } = require("ethers/lib/utils");
const hre = require("hardhat");
const abi = require('../artifacts/contracts/NFTMarket.sol/NFTMarket.json');

async function main() {


    // fetch the contract to deploy

    const address = "0x67b5859e6FDFf6Da419a9F70AaAbfF0b955042da";


    const nftMarket = new ethers.Contract(address, abi);

    console.log(nftMarket.address)




}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });