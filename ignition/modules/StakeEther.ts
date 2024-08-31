import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const StakeEtherModule = buildModule("StakeEther", (m) => {

    const lockedAmount = m.getParameter("lockedAmount",);


    const erth = m.contract("StakeEther");


    return { erth };
});

export default StakeEtherModule;
