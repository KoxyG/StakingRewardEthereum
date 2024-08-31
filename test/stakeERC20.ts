import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("StakeERC20", function () {
  async function deployToken() {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const ERC20Token = await hre.ethers.getContractFactory("MyERC20");
    const token = await ERC20Token.deploy();

    return { token, owner, otherAccount };
  }


  async function deployStakeERC20() {
    const { token, owner, otherAccount } = await loadFixture(deployToken);

    const StakeERC20 = await hre.ethers.getContractFactory("StakeERC20");
    const stakeErc20 = await StakeERC20.deploy(token);

    // Transfer tokens to the other account for staking
    await token.transfer(otherAccount.address, hre.ethers.parseUnits("1000", 18));

    return { token, stakeErc20, owner, otherAccount };
  }

  // describe("Stake", function () {
  //   it("Should stake tokens successfully", async function () {
  //     const { stakeErc20, token, otherAccount } = await loadFixture(deployStakeERC20);

  //     const stakeAmount = hre.ethers.parseUnits("200", 18);

  //     // Approve the contract to spend the staker's tokens
  //     await token.connect(otherAccount).approve(stakeErc20.address, stakeAmount);

  //     // Stake tokens
  //     await expect(stakeErc20.connect(otherAccount).stake(stakeAmount))
  //       .to.emit(stakeErc20, "Skaked")
  //       .withArgs(otherAccount.address, stakeAmount);

  //     const stakerInfo = await stakeErc20._stakers(otherAccount.address);
  //     expect(stakerInfo.amountStaked).to.equal(stakeAmount);
  //     expect(stakerInfo.isStaked).to.be.true;
  //   });

  //   it("Should calculate interest correctly over time", async function () {
  //     const { stakeErc20, token, otherAccount } = await loadFixture(deployStakeERC20);

  //     const stakeAmount = hre.ethers.parseUnits("200", 18);

  //     // Approve and stake tokens
  //     await token.connect(otherAccount).approve(stakeErc20.address, stakeAmount);
  //     await stakeErc20.connect(otherAccount).stake(stakeAmount);

  //     // Increase time by 30 days
  //     await time.increase(30 * 24 * 60 * 60);

  //     const expectedInterest = stakeAmount.mul(10).mul(30).div(100);
  //     const totalWithInterest = stakeAmount.add(expectedInterest);

  //     const currentInterest = await stakeErc20.connect(otherAccount).showCurrentInterest();
  //     expect(currentInterest).to.equal(totalWithInterest);
  //   });

  //   it("Should allow unstaking and transfer correct amount with interest", async function () {
  //     const { stakeErc20, token, otherAccount } = await loadFixture(deployStakeERC20);

  //     const stakeAmount = hre.ethers.parseUnits("200", 18);

  //     // Approve and stake tokens
  //     await token.connect(otherAccount).approve(stakeErc20.address, stakeAmount);
  //     await stakeErc20.connect(otherAccount).stake(stakeAmount);

  //     // Increase time by 30 days
  //     await time.increase(30 * 24 * 60 * 60);

  //     const expectedInterest = stakeAmount.mul(10).mul(30).div(100);
  //     const totalWithInterest = stakeAmount.add(expectedInterest);

  //     await expect(stakeErc20.connect(otherAccount).unstake())
  //       .to.emit(stakeErc20, "Unstaked")
  //       .withArgs(otherAccount.address, totalWithInterest);

  //     const stakerInfo = await stakeErc20._stakers(otherAccount.address);
  //     expect(stakerInfo.amountStaked).to.equal(0);
  //     expect(stakerInfo.isStaked).to.be.false;

  //     const finalBalance = await token.balanceOf(otherAccount.address);
  //     expect(finalBalance).to.equal(hre.ethers.parseUnits("1000", 18));
  //   });

  //   it("Should not allow unstaking if no stake exists", async function () {
  //     const { stakeErc20, otherAccount } = await loadFixture(deployStakeERC20);

  //     await expect(stakeErc20.connect(otherAccount).unstake()).to.be.revertedWith("No stake found");
  //   });
  // });

  // describe("Security", function () {
  //   it("Should not allow staking 0 tokens", async function () {
  //     const { stakeErc20, otherAccount } = await loadFixture(deployStakeERC20);

  //     await expect(stakeErc20.connect(otherAccount).stake(0)).to.be.revertedWith("Amount must be greater than 0");
  //   });

  //   it("Should correctly return the contract's token balance", async function () {
  //     const { stakeErc20, token, otherAccount } = await loadFixture(deployStakeERC20);

  //     const stakeAmount = hre.ethers.parseUnits("200", 18);

  //     // Approve and stake tokens
  //     await token.connect(otherAccount).approve(stakeErc20.address, stakeAmount);
  //     await stakeErc20.connect(otherAccount).stake(stakeAmount);

  //     const contractBalance = await stakeErc20.getContractBalance();
  //     expect(contractBalance).to.equal(stakeAmount);
  //   });
  // });
});
