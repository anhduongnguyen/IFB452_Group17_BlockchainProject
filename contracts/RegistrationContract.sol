// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegistrationContract {
    address public owner;
    uint256 public watchCount;

    struct Watch {
        string model;
        string serialNumber;
        string manufacturer;
        string productionDate;
        uint256 timestamp;
        address issuedTo;  // Who minted it (manufacturer)
    }

    mapping(uint256 => Watch) public watches;

    event WatchRegistered(uint256 indexed watchId, address indexed issuedTo, string model);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerWatch(
        string memory _model,
        string memory _serialNumber,
        string memory _manufacturer,
        string memory _productionDate
    ) public {
        watchCount++;

        watches[watchCount] = Watch({
            model: _model,
            serialNumber: _serialNumber,
            manufacturer: _manufacturer,
            productionDate: _productionDate,
            timestamp: block.timestamp,
            issuedTo: msg.sender  // initial issuer is the manufacturer
        });

        emit WatchRegistered(watchCount, msg.sender, _model);
    }

    function getWatchDetails(uint256 watchId)
        public
        view
        returns (
            string memory model,
            string memory serialNumber,
            string memory manufacturer,
            string memory productionDate,
            uint256 timestamp,
            address issuedTo
        )
    {
        Watch memory w = watches[watchId];
        return (
            w.model,
            w.serialNumber,
            w.manufacturer,
            w.productionDate,
            w.timestamp,
            w.issuedTo
        );
    }
}
