// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMToken {
    function mint(address to, uint amount) external;
}

contract StakingContract {
    IMToken public mToken;
    uint public totalStaked;
    mapping(address => uint) public stakedBalances;
    mapping(address => uint) public unclaimedRewards;
    mapping(address => uint) public lastUpdatedTime;

    struct WithdrawlRequest{
        uint amount;
        uint releaseTime;
    }

    mapping(address => WithdrawlRequest[]) public pendingWithdrawls;

    constructor(address _mToken) {
        mToken = IMToken(_mToken);
    }

    function stake() public payable {
        require(msg.value > 0, "stake amount must be greater than 0");
        // Calculate rewards
        if (lastUpdatedTime[msg.sender] == 0) {
            lastUpdatedTime[msg.sender] = block.timestamp;
        }

        else {
            uint reward = getRewards(msg.sender);
            unclaimedRewards[msg.sender] = reward;
            lastUpdatedTime[msg.sender] = block.timestamp;
        }
        stakedBalances[msg.sender] += msg.value;
        totalStaked += msg.value;
    }

    function unstake(uint _amount) public {
        require(stakedBalances[msg.sender] >= _amount, "insufficient staked balance");

        //Calculate rewards
        uint reward = getRewards(msg.sender);
        unclaimedRewards[msg.sender] = reward;
        lastUpdatedTime[msg.sender] = block.timestamp;
        stakedBalances[msg.sender] -= _amount;
        totalStaked -= _amount;
        pendingWithdrawls[msg.sender].push(WithdrawlRequest(_amount, block.timestamp + 1 minutes));
        
    }

    function getRewards(address _address) public view returns(uint) {
        uint currentReward = unclaimedRewards[_address];
        uint timePassed = (block.timestamp - lastUpdatedTime[_address])/60;
        uint newReward = stakedBalances[_address] * timePassed;
        return currentReward + newReward;
    }

    function claimRewards() public {
        uint reward = getRewards(msg.sender);
        unclaimedRewards[msg.sender] = 0;
        lastUpdatedTime[msg.sender] = block.timestamp;
        mToken.mint(msg.sender, reward);
    }

    function withdraw() public{
        uint totalWithdrawlAmount;
        WithdrawlRequest[] memory reqs = pendingWithdrawls[msg.sender];
        for (uint i = 0; i < reqs.length; i++) {
            if (block.timestamp >= reqs[i].releaseTime) {
                totalWithdrawlAmount += reqs[i].amount;
                delete pendingWithdrawls[msg.sender][i];
            }
        }
        payable(msg.sender).transfer(totalWithdrawlAmount);
    }
}