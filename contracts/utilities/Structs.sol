// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Enums.sol";

/**
 * @title Item
 * @dev Define a struct 'Item' with the following fields:
 */
struct Item {
    uint256 sku; // Stock Keeping Unit (SKU)
    uint256 upc; // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
    address payable ownerID; // Metamask-Ethereum address of the current owner as the product moves through 8 stages
    address payable originFarmerID; // Metamask-Ethereum address of the Farmer
    string originFarmName; // Farmer Name
    string originFarmInformation; // Farmer Information
    string originFarmLatitude; // Farm Latitude
    string originFarmLongitude; // Farm Longitude
    uint256 productID; // Product ID potentially a combination of upc + sku
    string productNotes; // Product Notes
    uint256 productPrice; // Product Price
    StateProduct itemState; // Product State as represented in the enum above
    address payable distributorID; // Metamask-Ethereum address of the Distributor
    address payable retailerID; // Metamask-Ethereum address of the Retailer
    address payable consumerID; // Metamask-Ethereum address of the Consumer
}