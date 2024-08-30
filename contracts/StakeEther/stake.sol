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

    uint256 private annualRate;

   struct Stake {
        uint256 stakingStartTime;
        uint256 amountStaked;
        bool isStaked;
    }
    mapping(address => Stake) private _stakers;



    // deploy contract with ether to use as reward in paying stakers
    constructor(uint256 _annualRate) payable {
        annualRate = _annualRate;
    }



    function stake(uint256 daysToStake) external payable {
        require(msg.value > 0, "Amount must be greater than 0");
        require(!_stakers[msg.sender].isStaked, "Already staked");

        
         // Calculate the end time for staking
        uint256 stakingEndTime = block.timestamp;
        Stake memory newStake = Stake(
            {
                daysToStake: stakingEndTime,
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


        uint256 calculateInterest = stakingInterest(staker.amountStaked, staker.stakingStartTime);
        
        uint256 amountToPay = staker.amountStaked + calculateInterest;

        (bool sent, bytes memory data) = msg.sender.call{value: amountToPay}("");
        require(sent, "Failed to send Ether");
    }

    function showCurrentInterest() external view returns (uint256) {

        Stake storage staker = _stakers[msg.sender];

        require(staker.isStaked == true, "Not staked");
        
        uint256 interest = calculateInterest(staker.amountStaked, staker.daysToStake);

        return interest + staker.amountStaked;
    }


    function calculateInterest(uint256 amount, uint256 stakingStartTime) private view returns (uint256) {
           
       // simple interest = principal * rate * time


        // Calculate the duration in days
        uint256 stakingDuration = (block.timestamp - stakingStartTime) / 1 days;
         // Calculate the fraction of the year
        uint256 fractionOfYear = (stakingDuration * 1e18) / 365 days; // Using 365 days for a year
         // Calculate the interest rate for the given period
        uint256 interest = (annualRate * fractionOfYear) / 1e18;


        return interest;
    }

    


}