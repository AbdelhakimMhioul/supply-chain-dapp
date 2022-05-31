// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title RolesLibrary
 * @dev Library for managing addresses assigned to a Role.
 */
library RolesLibrary {
    struct Role {
        mapping(address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0), "Address cannot be zero address");
        require(!has(role, account), "This address already has this role");
        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0), "Address cannot be zero address");
        require(has(role, account), "This address does not have this role yet");

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account)
        internal
        view
        returns (bool)
    {
        require(account != address(0), "Address cannot be zero address");
        return role.bearer[account];
    }
}
