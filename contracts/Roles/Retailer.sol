// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Import the library 'Roles'
import "./Roles.sol";

/**
 * @title Retailer
 * @dev Contract for managing the retailer role
 */
contract Retailer {
    using Roles for Roles.Role;

    // Define 2 events, one for Adding, and other for Removing
    event RetailerAdded(address indexed account);
    event RetailerRemoved(address indexed account);

    // Define a struct 'retailers' by inheriting from 'Roles' library, struct Role
    Roles.Role private retailers;

    // In the constructor make the address that deploys this contract the 1st retailer
    constructor() {
        addRetailer(msg.sender);
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyRetailer() {
        require(retailers.has(msg.sender), "This account has no Retailer role");
        _;
    }

    // Define a function 'isRetailer' to check this role
    function isRetailer(address account) public view returns (bool) {
        return retailers.has(account);
    }

    // Define a function 'addRetailer' that adds this role
    function addRetailer(address account) public {
        retailers.add(account);
        emit RetailerAdded(account);
    }

    // Define a function 'renounceRetailer' to renounce this role
    function renounceRetailer(address account) public {
        retailers.remove(account);
        emit RetailerRemoved(account);
    }
}
