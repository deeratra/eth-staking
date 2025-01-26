// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MToken} from "../src/MToken.sol";

contract MTokenTest is Test {
    MToken mToken;

    function setUp() public {
        mToken = new MToken();
    }

    function testInitialSupply() public view {
        assert(mToken.totalSupply() == 0);
    }

    function testMint() public {
        mToken.mint(address(this), 100);
        assert(mToken.totalSupply() == 100);
    }

    function testFailMint() public {
        vm.startPrank(0x96959E7417E11A84f0A9032fE3748F300F6978C5);
        mToken.mint(address(this), 100);
    }

    function testChangingStakingContract() public {
        mToken.updateStakingContract(0x96959E7417E11A84f0A9032fE3748F300F6978C5);
        vm.startPrank(0x96959E7417E11A84f0A9032fE3748F300F6978C5); // This means who is calling the function is the staking contract
        mToken.mint(0x96959E7417E11A84f0A9032fE3748F300F6978C5, 100);
        assert(mToken.balanceOf(0x96959E7417E11A84f0A9032fE3748F300F6978C5) == 100);
    }
}
