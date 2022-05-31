// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";
import "./Roles/Farmer.sol";
import "./Roles/Distributor.sol";
import "./Roles/Retailer.sol";
import "./Roles/Consumer.sol";
import "./utilities/Enums.sol";
import "./utilities/Structs.sol";

/**
 * @title Supplychain
 * @dev Contract for managing the entire supplychain
 */
contract SupplyChain is Ownable, Farmer, Distributor, Retailer, Consumer {
    // Define a public mapping 'items' that maps the UPC to an Item.
    mapping(uint256 => Item) items;
    // Default Product State
    StateProduct constant defaultState = StateProduct.Harvested;

    // Define 8 events with the same 8 state values and accept 'upc' as input argument
    event Harvested(uint256 upc);
    event Processed(uint256 upc);
    event Packed(uint256 upc);
    event ForSale(uint256 upc);
    event Sold(uint256 upc);
    event Shipped(uint256 upc);
    event Received(uint256 upc);
    event Purchased(uint256 upc);
}
