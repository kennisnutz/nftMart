// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold; //total number of Items sold on contract

    address payable owner; //smartcontract administrator;
    uint256 listingFee= 0.025 ether;

    function setPrice(uint256 _amount) external returns(uint256){
        require(msg.sender== owner);
        listingFee= _amount;
        return listingFee;
    }

    constructor(){
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint itemId;
        uint256 tokenId;
        address nftContract;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;

    }

    //access item details using id
    mapping(uint256 => MarketItem) private idMarketItem;

    event MarketItemCreated(
        uint indexed itemId,
        uint256 indexed tokenId,
        address indexed nftContract,
        address  seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingFee() public view returns(uint256){
        return listingFee;
    }

    function createMarketItem(
        address _nftContract,
        uint256 _tokenID,
        uint256 _price
    ) public payable nonReentrant{
        require(_price> 0, "price cannot be 0");
        require(msg.value==listingFee, "Must include a listing fee to list on this contract");
       
       _itemIds.increment();
       uint256 itemId= _itemIds.current();

       idMarketItem[itemId]= MarketItem(
        itemId,
       _tokenID,
        _nftContract,
        payable(msg.sender),
        payable(address(0)),
        _price,
        false
       );

       //transfer the nft to the contract
       IERC721(_nftContract).transferFrom(msg.sender, address(this), _tokenID);
       
       emit MarketItemCreated(
        itemId,
        _tokenID,
        _nftContract,
        msg.sender,
        address(0),
        _price,
        false
       );
    }


    /// @notice function to create a sale
    function createMarketSale(
        address _nftContract,
         uint256 _itemId
        ) public payable nonReentrant{
        uint price = idMarketItem[_itemId].price;
        uint tokenId = idMarketItem[_itemId].tokenId;

        require(msg.value == price, "Please submit the correct price  to complete purchase");

           //pay the seller the amount
           idMarketItem[_itemId].seller.transfer(msg.value);

             //transfer ownership of the nft from the contract itself to the buyer
            IERC721(_nftContract).transferFrom(address(this), msg.sender, tokenId);

            idMarketItem[_itemId].owner = payable(msg.sender); //mark buyer as new owner
            idMarketItem[_itemId].sold = true; //mark that it has been sold
            _itemsSold.increment(); //increment the total number of Items sold by 1
            payable(owner).transfer(listingFee); //pay owner of contract the listing price
        }


        /// @notice total number ofunsold  items  on our platform
        function fetchMarketItems() public view returns (MarketItem[] memory){
            uint itemCount = _itemIds.current(); //total number of items ever created
            //total number of items that are unsold = total items ever created - total items ever sold
            uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
            uint currentIndex = 0;

            MarketItem[] memory items =  new MarketItem[](unsoldItemCount);

            //loop through all items ever created
            for(uint i = 0; i < itemCount; i++){

                //get only unsold item
                //check if the item has not been sold
                //by checking if the owner field is empty
                if(idMarketItem[i+1].owner == address(0)){
                    //yes, this item has never been sold
                    uint currentId = idMarketItem[i + 1].itemId;
                    MarketItem storage currentItem = idMarketItem[currentId];
                    items[currentIndex] = currentItem;
                    currentIndex += 1;

                }
            }
            return items; //return array of all unsold items
        }

         /// @notice fetch list of NFTS owned/bought by this user
        function fetchMyNFTs() public view returns (MarketItem[] memory){
            //get total number of items ever created
            uint totalItemCount = _itemIds.current();

            uint itemCount = 0;
            uint currentIndex = 0;


            for(uint i = 0; i < totalItemCount; i++){
                //get only the items that this user has bought/is the owner
                if(idMarketItem[i+1].owner == msg.sender){
                    itemCount += 1; //total length
                }
            }

            MarketItem[] memory items = new MarketItem[](itemCount);
            for(uint i = 0; i < totalItemCount; i++){
               if(idMarketItem[i+1].owner == msg.sender){
                   uint currentId = idMarketItem[i+1].itemId;
                   MarketItem storage currentItem = idMarketItem[currentId];
                   items[currentIndex] = currentItem;
                   currentIndex += 1;
               }
            }
            return items;

        }

          /// @notice fetch list of NFTS owned/bought by this user
        function fetchItemsCreated() public view returns (MarketItem[] memory){
            //get total number of items ever created
            uint totalItemCount = _itemIds.current();

            uint itemCount = 0;
            uint currentIndex = 0;


            for(uint i = 0; i < totalItemCount; i++){
                //get only the items that this user has bought/is the owner
                if(idMarketItem[i+1].seller == msg.sender){
                    itemCount += 1; //total length
                }
            }

            MarketItem[] memory items = new MarketItem[](itemCount);
            for(uint i = 0; i < totalItemCount; i++){
               if(idMarketItem[i+1].seller == msg.sender){
                   uint currentId = idMarketItem[i+1].itemId;
                   MarketItem storage currentItem = idMarketItem[currentId];
                   items[currentIndex] = currentItem;
                   currentIndex += 1;
               }
            }
            return items;

        }

}