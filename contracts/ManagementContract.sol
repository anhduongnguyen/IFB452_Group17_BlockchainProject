// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRegistrationContract {
    function getWatchDetails(uint256 watchId)
        external
        view
        returns (
            string memory model,
            string memory serialNumber,
            string memory manufacturer,
            string memory productionDate,
            uint256 timestamp,
            address issuedTo
        );

    function watchCount() external view returns (uint256);
}

contract ManagementContract {
    address public admin;
    address public registrationContract;

    // Track watch ownership: watchId => current owner
    mapping(uint256 => address) public watchToOwner;

    // Track retailer assignments: watchId => assigned retailer
    mapping(uint256 => address) public assignedRetailer;

    event WatchAssigned(uint256 indexed watchId, address indexed toRetailer);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can assign");
        _;
    }

    constructor(address _registrationContract) {
        admin = msg.sender;
        registrationContract = _registrationContract;
    }

    function assignToRetailer(uint256 watchId, address retailer) external onlyAdmin {
        require(retailer != address(0), "Invalid retailer address");

        IRegistrationContract reg = IRegistrationContract(registrationContract);

        // Validate watch exists
        (, , , , , address issuedTo) = reg.getWatchDetails(watchId);
        require(issuedTo != address(0), "Watch does not exist");

        assignedRetailer[watchId] = retailer;
        watchToOwner[watchId] = retailer;

        emit WatchAssigned(watchId, retailer);
    }

    function getAssignedRetailer(uint256 watchId) external view returns (address) {
        return assignedRetailer[watchId];
    }

    function getCurrentOwner(uint256 watchId) external view returns (address) {
        return watchToOwner[watchId];
    }
}
