// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IManagementContract {
    function transferToBuyer(uint256 watchId, address buyer) external;
}

contract TransactionContract {
    enum Status { AwaitingDeposit, AwaitingConfirmation, Completed, Refunded }

    address public managementContract;

    // Per-watch mappings
    mapping(uint256 => uint256) public watchPrices;
    mapping(uint256 => bool) public forSale;
    mapping(uint256 => address) public buyer;
    mapping(uint256 => uint256) public amount;
    mapping(uint256 => Status) public status;
    mapping(uint256 => bool) public fundsReleased;
    mapping(uint256 => bool) public refunded;

    event PaymentDeposited(address indexed buyer, uint256 watchId, uint256 amount);
    event FundsReleased(address indexed to, uint256 watchId, uint256 amount);
    event BuyerRefunded(address indexed buyer, uint256 watchId, uint256 amount);
    event WatchListed(uint256 indexed watchId, uint256 priceInWei);

    constructor(address _managementContract) {
        managementContract = _managementContract;
    }

    function createListing(uint256 watchId, uint256 priceInWei) external {
        require(priceInWei > 0, "Price must be greater than 0");
        require(!forSale[watchId], "Already listed");

        watchPrices[watchId] = priceInWei;
        forSale[watchId] = true;
        status[watchId] = Status.AwaitingDeposit;

        emit WatchListed(watchId, priceInWei);
    }

    function deposit(uint256 watchId) external payable {
        require(forSale[watchId], "Watch not for sale");
        require(status[watchId] == Status.AwaitingDeposit, "Already funded");
        require(msg.value == watchPrices[watchId], "Incorrect amount");

        buyer[watchId] = msg.sender;
        amount[watchId] = msg.value;
        status[watchId] = Status.AwaitingConfirmation;

        emit PaymentDeposited(msg.sender, watchId, msg.value);

        forSale[watchId] = false;

        IManagementContract(managementContract).transferToBuyer(watchId, msg.sender);
    }


    function releaseFunds(uint256 watchId, address recipient) external {
        require(status[watchId] == Status.AwaitingConfirmation, "Invalid state");
        require(!fundsReleased[watchId], "Already released");

        fundsReleased[watchId] = true;
        status[watchId] = Status.Completed;

        payable(recipient).transfer(amount[watchId]);

        emit FundsReleased(recipient, watchId, amount[watchId]);
    }

    function refundBuyer(uint256 watchId) external {
        require(status[watchId] == Status.AwaitingConfirmation, "Cannot refund");
        require(!refunded[watchId], "Already refunded");

        refunded[watchId] = true;
        status[watchId] = Status.Refunded;

        payable(buyer[watchId]).transfer(amount[watchId]);

        emit BuyerRefunded(buyer[watchId], watchId, amount[watchId]);
    }

    function getPrice(uint256 watchId) external view returns (uint256) {
        return watchPrices[watchId];
    }

    function isForSale(uint256 watchId) external view returns (bool) {
        return forSale[watchId];
    }

    function getStatus(uint256 watchId) external view returns (Status) {
        return status[watchId];
    }
}
