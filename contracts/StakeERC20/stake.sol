// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//ERC20 Staking Smart Contract

//Objective: Write an ERC20 staking smart contract that allows users to stake a specific ERC20 token for rewards.

//Requirements:
//Users should be able to stake the ERC20 token by transferring the tokens to the contract.
//The contract should track the amount and duration of each user’s stake.
//Implement a reward mechanism similar to the Ether staking contract, where rewards are based on the staking duration.
//Users should be able to withdraw their staked tokens and the rewards after the staking period.
//The contract should handle ERC20 token transfers securely and efficiently.


contract StakeERC20 {

    
    mapping(address => uint256) private _balances;
   

    uint256 public constant DURATION = 7 days;

    function deposit(uint256 amount) external payable {
        // Deposit Ether to stake


    }

    function withdraw() external payable {
        // Withdraw staked Ether and rewards
    }

    function stakingInterest(uint256 amount, uint256 noOfDays, uint256 year) private pure returns (uint256) {
      
       // Simple Interest = Principal × Rate × Time
        // divide days by year to get the APY
       return amount * (noOfDays / year);
    }

    

    function claimReward() external {
        // Claim the reward earned by the user
    }
}