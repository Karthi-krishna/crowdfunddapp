// contracts/Migrations.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; // Pinned to the version in truffle-config.js

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  constructor() {
    owner = msg.sender;
  }

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}