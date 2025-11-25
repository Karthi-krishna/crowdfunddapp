# Crowdfunding Escrow DApp (Truffle & Ganache)

This project is a decentralized application (dApp) for managing a secure, time-locked crowdfunding campaign on an Ethereum Virtual Machine (EVM) blockchain. It functions as a trustless escrow: funds are held by the smart contract and released to the Project Owner only if the goal is met by the deadline, otherwise contributors can get a full refund.

---

## Project Summary

| Component         | Technology                 | Role |
|-------------------|-----------------------------|------|
| Smart Contract    | Solidity (v0.8.20)          | Crowdfunder.sol acts as the escrow vault, enforcing the rules. |
| Local Environment | Truffle & Ganache CLI       | Used for development, fast compilation, and instant, free testing. |
| Frontend          | HTML/JavaScript (Ethers.js v6) | The single-page interface for connecting a wallet, donating, and initiating withdrawal/refund. |
| Core Logic        | Payable functions & block.timestamp | Enables the contract to receive ETH and handle time-based success/failure logic. |

---

## Core Smart Contract Logic (Crowdfunder.sol)

The contract is governed by two parameters set at deployment: Funding Goal (10 ETH) and Deadline (30 Days).

### Donation (donate())

Allows any user to send ETH to the contract. The contract tracks each contributor's amount.

### Scenario A: Success

If the fundingGoal is met and the deadline passes, only the Project Owner can call withdraw(), receiving the total collected funds.

### Scenario B: Failure

If the fundingGoal is not met and the deadline passes, Contributors can call refund() to get their individual contribution back.

---

## Local Setup and Installation

Follow these steps to set up the project and test the contract locally.

### Prerequisites

- Node.js (LTS version, v18+)
- Truffle (Installed globally: `npm install -g truffle`)
- Ganache CLI (Installed globally: `npm install -g ganache`)
- MetaMask Browser Extension
- Git (for version control and publishing)

---

## 1. Initialize Project and Install Dependencies

If you are starting from a clean directory (`C:\CrowdfundDApp`), run these commands:

```sh
npm init -y
npm install
truffle init
2. Compile and Deploy
Ganache will simulate the blockchain.

A. Start the Local Blockchain (Terminal 1)
sh
Copy code
ganache
This starts the server on http://127.0.0.1:8545 and provides 10 funded accounts (1,000 ETH each).

B. Run Deployment (Terminal 2)
sh
Copy code
truffle migrate --reset
This deploys Migrations.sol and Crowdfunder.sol. Copy the Contract Address from the output.

3. Configure MetaMask
Add Network
Network Name: Ganache Local DApp

RPC URL: http://127.0.0.1:8545

Chain ID: 1337

Currency Symbol: ETH

Import Accounts
Import the Private Keys of:

Ganache Account (0) – Project Owner

Ganache Account (1) – Contributor

Testing the DApp Interface
The front-end (index.html) is where the core business logic is tested.

Update index.html
Open index.html and replace the placeholder values in the <script> section with:

Your deployed Contract Address

The full ABI array (found in build/contracts/Crowdfunder.json)

Launch
Open index.html in your browser.

Connect Wallet
Select your imported MetaMask account.

Test Case 1: Successful Withdrawal
Use a Contributor account to send 10 ETH via the Donate box.

To simulate the passage of 31 days:

sh
Copy code
truffle exec 'web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [2678400], id: 0}, console.log)'
Switch to the Project Owner account and click Withdraw.
The Contract Balance should reduce to 0.

Test Case 2: Failed Refund
Reset contract:

sh
Copy code
truffle migrate --reset
Use a Contributor account to send 3 ETH.

Run the time-increase command again.

Switch to the Contributor account and click Refund.
The Contributor's balance should increase by 3 ETH.

## UI Interface is like this:

![DApp Interface Screenshot](./my-dapp-screenshot.png)
