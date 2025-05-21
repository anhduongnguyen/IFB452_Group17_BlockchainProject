// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionContract {
    address public buyer;
    address public seller;
    uint256 public amount;
    bool public fundsDeposited;
    bool public fundsReleased;
    bool public refunded;

    enum Status { AwaitingDeposit, AwaitingConfirmation, Completed, Refunded }
    Status public status;

    mapping(uint256 => uint256) public watchPrices;

    event PaymentDeposited(address indexed buyer, uint256 amount);
    event FundsReleased(address indexed seller, uint256 amount);
    event BuyerRefunded(address indexed buyer, uint256 amount);

    constructor(address _seller) {
        seller = _seller;
        status = Status.AwaitingDeposit;
    }

    // Buyer deposits the funds
    function deposit() external payable {
        require(status == Status.AwaitingDeposit, "Already funded");
        require(msg.value > 0, "Must send some ETH");

        buyer = msg.sender;
        amount = msg.value;
        fundsDeposited = true;
        status = Status.AwaitingConfirmation;

        emit PaymentDeposited(buyer, amount);
    }

    // Release funds to seller when certificate is confirmed valid
    function releaseFunds() external {
        require(msg.sender == buyer, "Only buyer can approve release");
        require(status == Status.AwaitingConfirmation, "Invalid state");
        require(!fundsReleased, "Funds already released");

        fundsReleased = true;
        status = Status.Completed;
        payable(seller).transfer(amount);

        emit FundsReleased(seller, amount);
    }

    // Refund the buyer if details are invalid
    function refundBuyer() external {
        require(msg.sender == seller, "Only seller can trigger refund");
        require(status == Status.AwaitingConfirmation, "Cannot refund now");
        require(!refunded, "Already refunded");

        refunded = true;
        status = Status.Refunded;
        payable(buyer).transfer(amount);

        emit BuyerRefunded(buyer, amount);
    }

    // Utility function to get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Set price for a watch (by retailer)
    function setPrice(uint256 watchId, uint256 priceInWei) external {
        watchPrices[watchId] = priceInWei;
    }

    // Get price for a specific watch
    function getPrice(uint256 watchId) external view returns (uint256) {
        return watchPrices[watchId];
    }
}
