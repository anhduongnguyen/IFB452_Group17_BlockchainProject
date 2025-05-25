// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface to interact with the RegistrationContract for fetching watch details
interface IRegistrationContract {
    function getWatchDetails(
        uint256 watchId
    )
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
    address public transactionContract;

    mapping(uint256 => address) public watchToOwner;
    mapping(uint256 => address) public assignedRetailer;
    mapping(address => bool) public isRetailer;

    event WatchAssigned(uint256 indexed watchId, address indexed toRetailer);
    event WatchTransferred(uint256 indexed watchId, address indexed from, address indexed to);
    event DebugOwnershipTransferred(uint256 indexed watchId, address indexed newOwner);

    constructor(address _registrationContract) {
        registrationContract = _registrationContract;
    }

    // Allow setting the TransactionContract address only once
    function setTransactionContract(address _txContract) external {
        require(transactionContract == address(0), "Already set");
        require(_txContract != address(0), "Invalid address");
        transactionContract = _txContract;
    }

    // Assign a watch to a retailer
    function assignToRetailer(uint256 watchId, address retailer) external {
        require(retailer != address(0), "Invalid retailer address");

        IRegistrationContract reg = IRegistrationContract(registrationContract);
        (, , , , , address issuedTo) = reg.getWatchDetails(watchId);
        require(issuedTo != address(0), "Watch does not exist");

        assignedRetailer[watchId] = retailer;
        watchToOwner[watchId] = retailer;
        isRetailer[retailer] = true;

        emit WatchAssigned(watchId, retailer);
    }

    // Transfer ownership of a watch to a buyer (only callable by TransactionContract)
    function transferToBuyer(uint256 watchId, address buyer) external {
        require(msg.sender == transactionContract, "Only TransactionContract can call");
        require(buyer != address(0), "Invalid buyer address");

        address previousOwner = watchToOwner[watchId];
        watchToOwner[watchId] = buyer;

        emit WatchTransferred(watchId, previousOwner, buyer);
        emit DebugOwnershipTransferred(watchId, buyer);
    }

    // View the retailer a watch was assigned to
    function getAssignedRetailer(uint256 watchId) external view returns (address) {
        return assignedRetailer[watchId];
    }

    // View the current owner of a watch
    function getCurrentOwner(uint256 watchId) external view returns (address) {
        return watchToOwner[watchId];
    }

    // Verify that a watch is authentic by checking its registered details
    function isAuthentic(uint256 watchId) external view returns (bool) {
        IRegistrationContract reg = IRegistrationContract(registrationContract);
        (
            string memory model,
            string memory serialNumber,
            ,
            ,
            ,
            address issuedTo
        ) = reg.getWatchDetails(watchId);

        return (bytes(model).length > 0 &&
                bytes(serialNumber).length > 0 &&
                issuedTo != address(0));
    }
}
