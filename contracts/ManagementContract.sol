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
    address public registrationContract;

    mapping(uint256 => address) public watchToOwner;
    mapping(uint256 => address) public assignedRetailer;

    event WatchAssigned(uint256 indexed watchId, address indexed toRetailer);
    event WatchTransferred(uint256 indexed watchId, address indexed from, address indexed to);

    constructor(address _registrationContract) {
        registrationContract = _registrationContract;
    }

    function assignToRetailer(uint256 watchId, address retailer) external {
        require(retailer != address(0), "Invalid retailer address");

        IRegistrationContract reg = IRegistrationContract(registrationContract);
        (, , , , , address issuedTo) = reg.getWatchDetails(watchId);
        require(issuedTo != address(0), "Watch does not exist");

        assignedRetailer[watchId] = retailer;
        watchToOwner[watchId] = retailer;

        emit WatchAssigned(watchId, retailer);
    }

    function transferToBuyer(uint256 watchId, address buyer) external {
        require(buyer != address(0), "Invalid buyer address");

        address previousOwner = watchToOwner[watchId];
        watchToOwner[watchId] = buyer;

        emit WatchTransferred(watchId, previousOwner, buyer);
    }

    function getAssignedRetailer(uint256 watchId) external view returns (address) {
        return assignedRetailer[watchId];
    }

    function getCurrentOwner(uint256 watchId) external view returns (address) {
        return watchToOwner[watchId];
    }

    function isAuthentic(uint256 watchId) external view returns (bool) {
        IRegistrationContract reg = IRegistrationContract(registrationContract);
        (string memory model, string memory serialNumber, , , , address issuedTo) = reg.getWatchDetails(watchId);

        return (
            bytes(model).length > 0 &&
            bytes(serialNumber).length > 0 &&
            issuedTo != address(0)
        );
    }
}
