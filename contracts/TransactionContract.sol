// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionContract {
    address public retailer;

    enum Status { AwaitingDeposit, AwaitingConfirmation, Completed, Refunded }

    // Per-watch mappings
    mapping(uint256 => uint256) public watchPrices;
    mapping(uint256 => bool) public forSale;
    mapping(uint256 => address) public buyer;
    mapping(uint256 => uint256) public amount;
    mapping(uint256 => Status) public status;
    mapping(uint256 => bool) public fundsReleased;
    mapping(uint256 => bool) public refunded;

    event PaymentDeposited(address indexed buyer, uint256 watchId, uint256 amount);
    event FundsReleased(address indexed retailer, uint256 watchId, uint256 amount);
    event BuyerRefunded(address indexed buyer, uint256 watchId, uint256 amount);
    event WatchListed(uint256 indexed watchId, uint256 priceInWei);

    constructor(address _retailer) {
        retailer = _retailer;
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
    }

    function releaseFunds(uint256 watchId) external {
        require(msg.sender == buyer[watchId], "Only buyer can release");
        require(status[watchId] == Status.AwaitingConfirmation, "Invalid state");
        require(!fundsReleased[watchId], "Funds already released");

        fundsReleased[watchId] = true;
        status[watchId] = Status.Completed;

        payable(retailer).transfer(amount[watchId]);

        emit FundsReleased(retailer, watchId, amount[watchId]);
    }

    function refundBuyer(uint256 watchId) external {
        require(msg.sender == retailer, "Only retailer can refund");
        require(status[watchId] == Status.AwaitingConfirmation, "Cannot refund now");
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
