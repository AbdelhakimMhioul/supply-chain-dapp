// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Import the library 'Roles'
import "./Roles.sol";

/**
 * @title Consumer
 * @dev Contract for managing the consumer role
 */
contract Consumer {
    using Roles for Roles.Role;

    // Define 2 events, one for Adding, and other for Removing
    event ConsumerAdded(address indexed account);
    event ConsumerRemoved(address indexed account);

    // Define a struct 'consumers' by inheriting from 'Roles' library, struct Role
    Roles.Role private consumers;

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyConsumer() {
        require(consumers.has(msg.sender), "This account has no Consumer Role");
        _;
    }

    // In the constructor make the address that deploys this contract the 1st consumer
    constructor() {
        addConsumer(msg.sender);
    }

    // Define a function 'isConsumer' to check this role
    function isConsumer(address account) public view returns (bool) {
        return consumers.has(account);
    }

    // Define a function 'addConsumer' that adds this role
    function addConsumer(address account) public {
        consumers.add(account);
        emit ConsumerAdded(account);
    }

    // Define a function 'renounceConsumer' to renounce this role
    function renounceConsumer(address account) public {
        consumers.remove(account);
        emit ConsumerRemoved(account);
    }
}
