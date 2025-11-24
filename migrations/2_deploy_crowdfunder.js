// migrations/2_deploy_crowdfunder.js

const Crowdfunder = artifacts.require("Crowdfunder");

// Deployment Parameters: 10 ETH goal, 30-day duration
const fundingGoalInWei = web3.utils.toWei("10", "ether"); 
const durationInDays = 30; 

module.exports = function (deployer) {
  // Deploy the contract with the required constructor arguments
  deployer.deploy(Crowdfunder, fundingGoalInWei, durationInDays);
};