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
    // Define a variable called 'upc' for Universal Product Code (UPC)
    uint256 upc;
    // Define a variable called 'sku' for Stock Keeping Unit (SKU)
    uint256 sku;
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
            items[_upc].itemState == StateProduct.Harvested,
            "The Item is not in Harvested state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Processed
    modifier processed(uint256 _upc) {
        require(
            items[_upc].itemState == StateProduct.Processed,
            "The Item is not in Processed state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Packed
    modifier packed(uint256 _upc) {
        require(
            items[_upc].itemState == StateProduct.Packed,
            "The Item is not in Packed state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is ForSale
    modifier forSale(uint256 _upc) {
        require(
            items[_upc].itemState == StateProduct.ForSale,
            "The Item is not in ForSale state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Sold
    modifier sold(uint256 _upc) {
        require(
            items[_upc].itemState == StateProduct.Sold,
            "The Item is not in Sold state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Shipped
    modifier shipped(uint256 _upc) {
        require(
            items[_upc].itemState == StateProduct.Shipped,
            "The Item is not in Shipped state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Received
    modifier received(uint256 _upc) {
        require(
            items[_upc].itemState == StateProduct.Received,
            "The Item is not in Received state!"
        );
        _;
    }
    // Define a modifier that checks if an item.state of a upc is Purchased
    modifier purchased(uint256 _upc) {
        require(
            items[_upc].itemState == StateProduct.Purchased,
            "The Item is not in Purchased state!"
        );
        _;
    }

    /** FUNCTIONS (GETTERS) */
    // Get The Item History
    function getItemHistory(uint256 _upc, string memory state)
        public
        view
        returns (address)
    {
        return itemsHistory[_upc][state];
    }

    /** FUNCTIONS (STATE) */
    // Define a function 'harvestItem' that allows a farmer to mark an item 'Harvested'
    function harvestItem(
        uint256 _upc,
        address payable _originFarmerID,
        string memory _originFarmName,
        string memory _originFarmInformation,
        string memory _originFarmLatitude,
        string memory _originFarmLongitude,
        string memory _productNotes
    ) public onlyFarmer {
        // Add the new item as part of Harvest
        Item memory newItem;
        newItem.upc = _upc;
        newItem.ownerID = _originFarmerID;
        newItem.originFarmerID = _originFarmerID;
        newItem.originFarmName = _originFarmName;
        newItem.originFarmInformation = _originFarmInformation;
        newItem.originFarmLatitude = _originFarmLatitude;
        newItem.originFarmLongitude = _originFarmLongitude;
        newItem.productNotes = _productNotes;
        newItem.sku = sku;
        newItem.productID = _upc + sku;
        // Add Harvest to Item History
        itemsHistory[_upc]["Harvested"] = tx.origin;
        // Increment sku
        sku = sku + 1;
        // Setting state
        newItem.itemState = StateProduct.Harvested;
        // Adding new Item to map
        items[_upc] = newItem;
        // Emit the appropriate event
        emit Harvested(_upc);
    }

    // Define a function 'processtItem' that allows a farmer to mark an item 'Processed'
    function processItem(uint256 _upc)
        public
        //Only Farmer
        onlyFarmer
        // Call modifier to check if upc has passed previous supply chain stage
        harvested(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originFarmerID)
    {
        // Update the appropriate fields
        Item storage existingItem = items[_upc];
        existingItem.itemState = StateProduct.Processed;
        // Add Harvest to Item History
        itemsHistory[_upc]["Processed"] = tx.origin;
        // Emit the appropriate event
        emit Processed(_upc);
    }

    // Define a function 'packItem' that allows a farmer to mark an item 'Packed'
    function packItem(uint256 _upc)
        public
        //Only Farmer
        onlyFarmer
        // Call modifier to check if upc has passed previous supply chain stage
        processed(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originFarmerID)
    {
        // Update the appropriate fields
        Item storage existingItem = items[_upc];
        existingItem.itemState = StateProduct.Packed;
        // Add Harvest to Item History
        itemsHistory[_upc]["Packed"] = tx.origin;
        // Emit the appropriate event
        emit Packed(_upc);
    }

    // Define a function 'sellItem' that allows a farmer to mark an item is 'ForSale'
    function sellItem(uint256 _upc, uint256 _price)
        public
        //Only Farmer
        onlyFarmer
        // Call modifier to check if upc has passed previous supply chain stage
        packed(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originFarmerID)
    {
        // Update the appropriate fields
        Item storage existingItem = items[_upc];
        existingItem.itemState = StateProduct.ForSale;
        existingItem.productPrice = _price;
        // Add Harvest to Item History
        itemsHistory[_upc]["Sold"] = tx.origin;
        // Emit the appropriate event
        emit ForSale(_upc);
    }

    // Define a function 'buyItem' that allows the disributor to mark an item 'Sold'
    // Use the above defined modifiers to check if the item is available for sale, if the buyer has paid enough,
    // and any excess ether sent is refunded back to the buyer
    function buyItem(uint256 _upc)
        public
        payable
        // Only Distributor
        onlyDistributor
        // Call modifier to check if upc has passed previous supply chain stage
        forSale(_upc)
        // Call modifer to check if buyer has paid enough
        paidEnough(items[_upc].productPrice)
        // Call modifer to send any excess ether back to buyer
        checkValueForDistributor(_upc)
    {
        // Update the appropriate fields - ownerID, distributorID, itemState
        Item storage existingItem = items[_upc];
        existingItem.ownerID = payable(msg.sender);
        existingItem.itemState = StateProduct.Sold;
        existingItem.distributorID = payable(msg.sender);
        // Transfer money to farmer
        uint256 productPrice = items[_upc].productPrice;
        items[_upc].originFarmerID.transfer(productPrice);
        // Add Harvest to Item History
        itemsHistory[_upc]["Sold"] = tx.origin;
        // emit the appropriate event
        emit Sold(_upc);
    }

    // Define a function 'shipItem' that allows the distributor to mark an item 'Shipped'
    // Use the above modifers to check if the item is sold
    function shipItem(uint256 _upc)
        public
        // Only Distributor
        onlyDistributor
        // Call modifier to check if upc has passed previous supply chain stage
        sold(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].distributorID)
    {
        // Update the appropriate fields
        Item storage existingItem = items[_upc];
        existingItem.itemState = StateProduct.Shipped;
        // Add Harvest to Item History
        itemsHistory[_upc]["Shipped"] = tx.origin;
        // Emit the appropriate event
        emit Shipped(_upc);
    }

    // Define a function 'receiveItem' that allows the retailer to mark an item 'Received'
    // Use the above modifiers to check if the item is shipped
    function receiveItem(uint256 _upc)
        public
        // Only Retailer
        onlyRetailer
        // Call modifier to check if upc has passed previous supply chain stage
        shipped(_upc)
    // Access Control List enforced by calling Smart Contract / DApp
    {
        // Update the appropriate fields - ownerID, retailerID, itemState
        Item storage existingItem = items[_upc];
        existingItem.ownerID = payable(msg.sender);
        existingItem.itemState = StateProduct.Received;
        existingItem.retailerID = payable(msg.sender);
        // Add Harvest to Item History
        itemsHistory[_upc]["Received"] = tx.origin;
        // Emit the appropriate event
        emit Received(_upc);
    }

    // Define a function 'purchaseItem' that allows the consumer to mark an item 'Purchased'
    // Use the above modifiers to check if the item is received
    function purchaseItem(uint256 _upc)
        public
        payable
        //Only Consumer
        onlyConsumer
        // Call modifier to check if upc has passed previous supply chain stage
        received(_upc)
        // Make sure paid enough
        paidEnough(items[_upc].productPrice)
        // Access Control List enforced by calling Smart Contract / DApp
        checkValueForConsumer(_upc)
    {
        // Update the appropriate fields - ownerID, consumerID, itemState
        Item storage existingItem = items[_upc];
        existingItem.ownerID = payable(msg.sender);
        existingItem.itemState = StateProduct.Purchased;
        existingItem.consumerID = payable(msg.sender);
        // Add Harvest to Item History
        itemsHistory[_upc]["Purchased"] = tx.origin;
        // Emit the appropriate event
        emit Purchased(_upc);
    }

    // Define a function 'fetchItemBufferOne' that fetches the data
    function fetchItemBufferOne(uint256 _upc)
        public
        view
        returns (
            uint256 itemSKU,
            uint256 itemUPC,
            address ownerID,
            address originFarmerID,
            string memory originFarmName,
            string memory originFarmInformation,
            string memory originFarmLatitude,
            string memory originFarmLongitude
        )
    {
        // Assign values to the 8 parameters
        Item memory existingItem = items[_upc];

        itemSKU = existingItem.sku;
        itemUPC = existingItem.upc;
        ownerID = existingItem.ownerID;
        originFarmerID = existingItem.originFarmerID;
        originFarmName = existingItem.originFarmName;
        originFarmInformation = existingItem.originFarmInformation;
        originFarmLatitude = existingItem.originFarmLatitude;
        originFarmLongitude = existingItem.originFarmLongitude;

        return (
            itemSKU,
            itemUPC,
            ownerID,
            originFarmerID,
            originFarmName,
            originFarmInformation,
            originFarmLatitude,
            originFarmLongitude
        );
    }
}
