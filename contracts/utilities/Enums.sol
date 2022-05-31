// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title StateProduct
 * @dev Enum for managing Product's State
 */
enum StateProduct {
    Harvested, // 0
    Processed, // 1
    Packed, // 2
    ForSale, // 3
    Sold, // 4
    Shipped, // 5
    Received, // 6
    Purchased // 7
}
