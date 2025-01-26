// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import "../src/MToken.sol";

contract DeployMToken is Script {
    function run() public {
        vm.startBroadcast();
        MToken mToken = new MToken();
        console.log("MSD deployed to:", address(mToken));
        vm.stopBroadcast();
    }
}
