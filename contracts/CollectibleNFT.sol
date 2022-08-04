// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CollectibleNFT is ERC721URIStorage { 
   
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    
    address public nftMart;

    constructor(address _nftMart)ERC721("Collectible NFT", "CNFT"){
       nftMart=_nftMart;

    }

    ///@notice create new nft
    ///@param _tokenURI: token URI
    function createToken(string memory _tokenURI) public returns(uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId); // mint new item
        _setTokenURI(newItemId, _tokenURI); // set the url loction of the token
        setApprovalForAll(nftMart, true); // approve the token to the market place

        //return the token ID
        return newItemId;


    }


   
}