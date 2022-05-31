// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Import the library 'Roles'
import "./Roles.sol";

/**
 * @title Farmer
 * @dev Contract for managing the farmer role
 */
contract Farmer {
    using Roles for Roles.Role;

    // Define 2 events, one for Adding, and other for Removing
    event FarmerAdded(address indexed account);
    event FarmerRemoved(address indexed account);

    // Define a struct 'farmers' by inheriting from 'Roles' library, struct Role
    Roles.Role private farmers;

    // In the constructor make the address that deploys this contract the 1st farmer
    constructor() {
        addFarmer(msg.sender);
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyFarmer() {
        require(isFarmer(msg.sender), "This account has no a Farmer Role");
        _;
    }

    // Define a function 'isFarmer' to check this role
    function isFarmer(address account) public view returns (bool) {
        return farmers.has(account);
    }

    // Define a function 'addFarmer' that adds this role
    function addFarmer(address account) public {
        farmers.add(account);
        emit FarmerAdded(account);
    }

    // Define a function 'renounceFarmer' to renounce this role
    function renounceFarmer(address account) public {
        farmers.remove(account);
        emit FarmerRemoved(account);
    }
}
