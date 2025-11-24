// contracts/Crowdfunder.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; // Pinning to the version in truffle-config.js

contract Crowdfunder {
    // State Variables
    address public immutable projectOwner;
    uint public immutable fundingGoal;
    uint public immutable deadline;
    uint public currentBalance;

    // Mapping to track contributions: contributor address => amount contributed
    mapping(address => uint) public contributions;

    // Events for logging activity
    event Contribution(address indexed contributor, uint amount);
    event GoalReached(uint totalAmount);
    event Payout(address indexed recipient, uint amount);
    event Refund(address indexed contributor, uint amount);

    // Errors for better error handling
    error GoalAlreadyMet();
    error DeadlinePassed();
    error GoalNotMet();
    error GoalMet();
    error NotProjectOwner();
    error NoContribution();

    /**
     * @notice Constructor sets the owner, goal (in Wei), and deadline (in seconds).
     */
    constructor(uint _fundingGoal, uint _durationInDays) {
        projectOwner = msg.sender;
        fundingGoal = _fundingGoal;
        // 1 days = 24 * 60 * 60 seconds
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    /**
     * @notice Allows anyone to contribute funds to the project.
     * This is a 'payable' function.
     */
    function donate() external payable {
        if (currentBalance >= fundingGoal) {
            revert GoalAlreadyMet();
        }
        if (block.timestamp >= deadline) {
            revert DeadlinePassed();
        }
        if (msg.value == 0) {
            revert NoContribution();
        }

        currentBalance += msg.value;
        contributions[msg.sender] += msg.value;

        emit Contribution(msg.sender, msg.value);

        if (currentBalance >= fundingGoal) {
            emit GoalReached(currentBalance);
        }
    }

    /**
     * @notice Scenario A: Allows the project owner to withdraw funds if the goal is met and deadline passed.
     */
    function withdraw() external {
        if (msg.sender != projectOwner) {
            revert NotProjectOwner();
        }
        if (currentBalance < fundingGoal) {
            revert GoalNotMet();
        }
        if (block.timestamp < deadline) {
            revert DeadlinePassed(); 
        }

        uint amountToTransfer = currentBalance;
        currentBalance = 0;

        // Use call for secure ETH transfer
        (bool success, ) = payable(projectOwner).call{value: amountToTransfer}("");
        require(success, "Transfer failed.");

        emit Payout(projectOwner, amountToTransfer);
    }

    /**
     * @notice Scenario B: Allows contributors to get a refund if the goal was NOT met and deadline passed.
     */
    function refund() external {
        if (block.timestamp < deadline) {
            revert DeadlinePassed();
        }
        if (currentBalance >= fundingGoal) {
            revert GoalMet();
        }

        uint amount = contributions[msg.sender];
        if (amount == 0) {
            revert NoContribution();
        }

        contributions[msg.sender] = 0;

        // Use call for secure ETH transfer back to contributor
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed.");

        emit Refund(msg.sender, amount);
    }
}