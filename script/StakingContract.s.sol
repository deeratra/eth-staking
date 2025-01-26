// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {StakingContract} from "../src/StakingContract.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployStakingContract is Script{
    function run() public {
        // Replace with the address of your deployed MSD token contract
        address mTokenAddress = 0x47573B2f7A8Af276BF5Ef03Bb529BcE4bA5B5361;
        vm.startBroadcast();

        // Deploy the staking contract
        new StakingContract(mTokenAddress);
        vm.stopBroadcast();
    }
}