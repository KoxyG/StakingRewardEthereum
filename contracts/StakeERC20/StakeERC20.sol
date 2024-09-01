// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "../Interfaces/IERC20.sol";


//Write an Ether staking smart contract that allows users to stake Ether for a specified period.

//Requirements:
//Users should be able to stake Ether by sending a transaction to the contract.
//The contract should record the staking time for each user.
//Implement a reward mechanism where users earn rewards based on how long they have staked their Ether.
//The rewards should be proportional to the duration of the stake.
//Users should be able to withdraw both their staked Ether and the earned rewards after the staking period ends.
//Ensure the contract is secure, especially in handling users’ funds and calculating rewards.


contract StakeERC20 {
    struct Stake {
        uint256 stakingStartTime;
        uint256 amountStaked;
        bool isStaked;
    }
    mapping(address => Stake) public _stakers;


    IERC20 public rewardToken;
    uint256 public interestRate = 10; // Interest rate as a percentage

    event Skaked(address indexed sender, uint256 amount);
    event Unstaked(address indexed to, uint256 amount);



    constructor(address _rewardToken) {
        rewardToken = IERC20(_rewardToken);
    }

    // function to stake tokens
    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");

        uint256 stakingStart = block.timestamp;

        // Transfer tokens from the user to the contract
        bool success = rewardToken.transferFrom(msg.sender, address(this), _amount);
        require(success, "Token transfer failed");

        // Record the stake
        Stake memory newStake = Stake({
            stakingStartTime: stakingStart,
            amountStaked: _amount,
            isStaked: true
        });

        _stakers[msg.sender] = newStake;

        emit Skaked(msg.sender, _amount);
    }

    function unstake() external {
        Stake storage staker = _stakers[msg.sender];
        require(staker.isStaked, "No stake found");


        // calculate interest
        uint256 interest = calculateInterest(staker.stakingStartTime, staker.amountStaked);
        uint256 amountToPay = staker.amountStaked + interest;


        // Transfer the staked amount and interest to the user
        bool success = rewardToken.transfer(msg.sender, amountToPay);
        require(success, "Token transfer failed");
        staker.amountStaked = 0;
        staker.stakingStartTime = 0;

        // Update stake status
        staker.isStaked = false;

        emit Unstaked(msg.sender, amountToPay);
    }

    function showCurrentInterest() external view returns (uint256) {
        Stake storage staker = _stakers[msg.sender];
        require(staker.isStaked, "No stake found");

        // calculate interest
        uint256 interest = calculateInterest(staker.stakingStartTime, staker.amountStaked);
        return interest + staker.amountStaked;
    }


    // function to calculate interest based on staking duration
    function calculateInterest(uint256 stakingStartTime, uint256 amountStaked) private view returns (uint256) {
        uint256 stakingDuration = block.timestamp - stakingStartTime;
        uint256 stakingDurationInDays = stakingDuration / 1 days;

         // work on the total staked an also add option on the days to staked.
        uint256 interest = (amountStaked * interestRate * stakingDurationInDays) / 100;

        return interest;
    }

    // function to get the contract balance
    function getContractBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }
}
