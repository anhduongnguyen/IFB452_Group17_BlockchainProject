// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoleManager {
    address public admin;

    mapping(address => string) public roles;

    event RoleAssigned(address indexed user, string role);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can assign roles");
        _;
    }

    function setRole(address user, string calldata role) external onlyAdmin {
        roles[user] = role;
        emit RoleAssigned(user, role);
    }

    function getMyRole() external view returns (string memory) {
        return roles[msg.sender];
    }

    function getRole(address user) external view returns (string memory) {
        return roles[user];
    }
}
