// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Import the library 'Roles'
import "./Roles.sol";

/**
 * @title Distributor
 * @dev Contract for managing the distributor role
 */
contract Distributor {
    using Roles for Roles.Role;

    // Define 2 events, one for Adding, and other for Removing
    event DistributorAdded(address indexed account);
    event DistributorRemoved(address indexed account);

    // Define a struct 'distributors' by inheriting from 'Roles' library, struct Role
    Roles.Role private distributors;

    // In the constructor make the address that deploys this contract the 1st distributor
    constructor() {
        // The first distributor will be the person deploying this contract
        addDistributor(msg.sender);
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyDistributor() {
        require(
            distributors.has(msg.sender),
            "This account has no Distributor Role"
        );
        _;
    }

    // Define a function 'isDistributor' to check this role
    function isDistributor(address account) public view returns (bool) {
        return distributors.has(account);
    }

    // Define a function 'addDistributor' that adds this role
    function addDistributor(address account) public {
        distributors.add(account);
        emit DistributorAdded(account);
    }

    // Define a function 'renounceDistributor' to renounce this role
    function renounceDistributor(address account) public {
        distributors.remove(account);
        emit DistributorRemoved(account);
    }
}
