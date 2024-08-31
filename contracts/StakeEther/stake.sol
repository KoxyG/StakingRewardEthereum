// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//Write an Ether staking smart contract that allows users to stake Ether for a specified period.

//Requirements:
//Users should be able to stake Ether by sending a transaction to the contract.
//The contract should record the staking time for each user.
//Implement a reward mechanism where users earn rewards based on how long they have staked their Ether.
//The rewards should be proportional to the duration of the stake.
//Users should be able to withdraw both their staked Ether and the earned rewards after the staking period ends.
//Ensure the contract is secure, especially in handling users’ funds and calculating rewards.


contract StakeEther {

    uint public immutable rewardsPerHour = 1000; // 0.01%

   struct Stake {
        uint256 stakingStartTime;
        uint256 amountStaked;
        bool isStaked;
    }
    mapping(address => Stake) public _stakers;



    // deploy contract with ether to use as reward in paying stakers
    constructor() payable {
        require(msg.value > 0, "Must deploy with Ether");
      
    }



    function stake() external payable {
        require(msg.value > 0, "Amount must be greater than 0");

        
         // Calculate the end time for staking
        uint256 stakingStart = block.timestamp;
        Stake memory newStake = Stake(
            {
                stakingStartTime: stakingStart,
                amountStaked: msg.value,
                isStaked: true
            }
         );
        _stakers[msg.sender] = newStake;
       
    }

    function unstake() external payable {
        Stake storage staker = _stakers[msg.sender];
        // Withdraw staked Ether and rewards
        require(staker.isStaked == true, "Not staked");


        uint256 Interest = calculateInterest(staker.stakingStartTime);
        
        uint256 amountToPay = staker.amountStaked + Interest;

        (bool sent,) = msg.sender.call{value: amountToPay}("");
        require(sent, "Failed to send Ether");
        staker.isStaked = false;
    }


    function showCurrentInterest() external view returns (uint256) {

        Stake storage staker = _stakers[msg.sender];

        require(staker.isStaked == true, "Not staked");

        
        uint256 interest = calculateInterest(staker.stakingStartTime);
     
        
        return interest + staker.amountStaked;
    }


    function calculateInterest(uint256 stakingStartTime) private view returns (uint256) {
        Stake storage staker = _stakers[msg.sender]; 
        // Calculate the duration
        uint256 stakingDuration = (block.timestamp - stakingStartTime) / 365 days;
      
         // Calculate the interest rate for the given period
        uint256 interest = (stakingDuration * staker.amountStaked);
        return interest;
    }

    function getContractBalance() external view returns  (uint256) {
        return address(this).balance;
    }

    


}