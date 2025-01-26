// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // This is an alias or remapping of the path to the OpenZeppelin ERC20 contract

contract MToken is ERC20 {
    address stakingContract;
    address owner;

    constructor() ERC20("MToken", "MTK") {
        // stakingContract = _stakingContract;
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == stakingContract, "only staking contract can mint");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }

    function updateStakingContract(address _newStakingContract) public {
        require(msg.sender == owner, "only owner can update staking contract");
        stakingContract = _newStakingContract;
    }
}
