// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Automated Royalties Payment
 * @dev A smart contract to automate royalty distribution among creators.
 */
contract AutomatedRoyaltiesPayment {
    address public owner;
    mapping(address => uint256) public royalties;
    uint256 public totalFunds;

    event RoyaltyPaid(address indexed recipient, uint256 amount);
    event FundsDeposited(address indexed sender, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Deposit funds into the contract for royalty distribution.
     */
    function depositFunds() external payable {
        require(msg.value > 0, "Must deposit some funds");
        totalFunds += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    /**
     * @dev Set royalty share for a recipient.
     * @param recipient Address of the royalty recipient.
     * @param amount Amount of royalty share in wei.
     */
    function setRoyalty(address recipient, uint256 amount) external {
        require(msg.sender == owner, "Only owner can set royalties");
        royalties[recipient] = amount;
    }

    /**
     * @dev Distribute royalties to all recipients.
     */
    function distributeRoyalties(address[] calldata recipients) external {
        require(msg.sender == owner, "Only owner can distribute royalties");
        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 amount = royalties[recipient];
            require(amount > 0, "No royalty set for recipient");
            require(totalFunds >= amount, "Insufficient funds");

            totalFunds -= amount;
            payable(recipient).transfer(amount);
            emit RoyaltyPaid(recipient, amount);
        }
    }
}
