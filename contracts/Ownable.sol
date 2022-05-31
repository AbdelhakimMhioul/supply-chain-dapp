// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title Ownable
 * @dev Provides basic authorization control
 */
contract Ownable {
    address payable private origOwner;

    /**
     * @dev Define an Event to Transfer Ownership
     */
    event TransferOwnership(address indexed oldOwner, address indexed newOwner);

    /**
     * @dev Assign the contract to an owner (The contract's caller)
     */
    constructor() {
        origOwner = payable(msg.sender);
        emit TransferOwnership(address(0), origOwner);
    }

    /**
     * @dev Define a function 'kill' if required
     */
    function kill() public {
        if (msg.sender == origOwner) {
            selfdestruct(origOwner);
        }
    }

    /**
     * @dev Look up the address of the owner
     */
    function owner() public view returns (address) {
        return origOwner;
    }

    /**
     * @dev Check if the calling address is the owner of the contract
     */
    modifier onlyOwner() {
        require(
            msg.sender == origOwner,
            "Only the owner can perform this operation"
        );
        _;
    }

    /**
     * @dev Define a function to renounce ownerhip
     */
    function renounceOwnership() public onlyOwner {
        emit TransferOwnership(origOwner, address(0));
        origOwner = payable(address(0));
    }

    /**
     * @dev Define an public function to transfer ownership
     */
    function transferOwnership(address payable newOwner) public onlyOwner {
        require(newOwner != address(0), "The new Owner cannot be address 0");
        emit TransferOwnership(origOwner, newOwner);
        origOwner = newOwner;
    }
}
