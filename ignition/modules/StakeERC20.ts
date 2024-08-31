import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "0x03C65002d5c567632e5c9B233F0d55241644A8b1";

const StakeERC20Module = buildModule("StakeERC20Module", (m) => {

    const erc20 = m.contract("StakeERC20", [tokenAddress]);


    return { erc20 };
});

export default StakeERC20Module;
