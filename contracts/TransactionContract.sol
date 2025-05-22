// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionContract {
    address public buyer;
    address public retailer;
    uint256 public amount;
    bool public fundsDeposited;
    bool public fundsReleased;
    bool public refunded;

    enum Status { AwaitingDeposit, AwaitingConfirmation, Completed, Refunded }
    Status public status;

    mapping(uint256 => uint256) public watchPrices;
    mapping(uint256 => bool) public forSale; // NEW: track if a watch is listed

    event PaymentDeposited(address indexed buyer, uint256 amount);
    event FundsReleased(address indexed retailer, uint256 amount);
    event BuyerRefunded(address indexed buyer, uint256 amount);

    constructor(address _retailer) {
        retailer = _retailer;
        status = Status.AwaitingDeposit;
    }

    function deposit() external payable {
        require(status == Status.AwaitingDeposit, "Already funded");
        require(msg.value > 0, "Must send some ETH");

        buyer = msg.sender;
        amount = msg.value;
        fundsDeposited = true;
        status = Status.AwaitingConfirmation;

        emit PaymentDeposited(buyer, amount);
    }

    function releaseFunds() external {
        require(msg.sender == buyer, "Only buyer can approve release");
        require(status == Status.AwaitingConfirmation, "Invalid state");
        require(!fundsReleased, "Funds already released");

        fundsReleased = true;
        status = Status.Completed;
        payable(retailer).transfer(amount);

        emit FundsReleased(retailer, amount);
    }

    function refundBuyer() external {
        require(msg.sender == retailer, "Only retailer can trigger refund");
        require(status == Status.AwaitingConfirmation, "Cannot refund now");
        require(!refunded, "Already refunded");

        refunded = true;
        status = Status.Refunded;
        payable(buyer).transfer(amount);

        emit BuyerRefunded(buyer, amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function setPrice(uint256 watchId, uint256 priceInWei) external {
        watchPrices[watchId] = priceInWei;
    }

    function getPrice(uint256 watchId) external view returns (uint256) {
        return watchPrices[watchId];
    }

    function listForSale(uint256 watchId) external {
        require(watchPrices[watchId] > 0, "Set price first");
        forSale[watchId] = true;
    }

    function isForSale(uint256 watchId) external view returns (bool) {
        return forSale[watchId];
    }
}
