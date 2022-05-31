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
    // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash, that track its journey through the supply chain -- to be sent from DApp.
    mapping(uint256 => mapping(string => address)) itemsHistory;
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

    // Using Ownable to define the owner
    constructor() payable {
        sku = 1;
        upc = 1;
    }

    /** GENERAL MODIFIERS */
    // Define a modifier that verifies the Caller
    modifier verifyCaller(address _address) {
        require(
            msg.sender == _address,
            "This account is not the owner of this item"
        );
        _;
    }
    // Define a modifier that checks if the paid amount is sufficient to cover the price
    modifier paidEnough(uint256 _price) {
        require(
            msg.value >= _price,
            "The amount sent is not sufficient for the price"
        );
        _;
    }
    // Define a modifier that checks the price and refunds the remaining balance to the Distributor
    modifier checkValueForDistributor(uint256 _upc) {
        _;
        uint256 _price = items[_upc].productPrice;
        uint256 amountToReturn = msg.value - _price;
        items[_upc].distributorID.transfer(amountToReturn);
    }
    // Define a modifier that checks the price and refunds the remaining balance to the Consumer
    modifier checkValueForConsumer(uint256 _upc) {
        _;
        uint256 _price = items[_upc].productPrice;
        uint256 amountToReturn = msg.value - _price;
        items[_upc].consumerID.transfer(amountToReturn);
    }

    /** PRODUCT STATE MODIFIERS */
    // Define a modifier that checks if an item.state of a upc is Harvested
    modifier harvested(uint256 _upc) {
        require(
            items[_upc].itemState == State.Harvested,
            "The Item is not in Harvested state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Processed
    modifier processed(uint256 _upc) {
        require(
            items[_upc].itemState == State.Processed,
            "The Item is not in Processed state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Packed
    modifier packed(uint256 _upc) {
        require(
            items[_upc].itemState == State.Packed,
            "The Item is not in Packed state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is ForSale
    modifier forSale(uint256 _upc) {
        require(
            items[_upc].itemState == State.ForSale,
            "The Item is not in ForSale state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Sold
    modifier sold(uint256 _upc) {
        require(
            items[_upc].itemState == State.Sold,
            "The Item is not in Sold state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Shipped
    modifier shipped(uint256 _upc) {
        require(
            items[_upc].itemState == State.Shipped,
            "The Item is not in Shipped state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Received
    modifier received(uint256 _upc) {
        require(
            items[_upc].itemState == State.Received,
            "The Item is not in Received state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Purchased
    modifier purchased(uint256 _upc) {
        require(
            items[_upc].itemState == State.Purchased,
            "The Item is not in Purchased state!"
        );
        _;
    }
}
