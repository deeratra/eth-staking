// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMToken {
    function mint(address to, uint256 amount) external;
}

contract StakingContract {
    IMToken public mToken;
    uint256 public totalStaked;
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public unclaimedRewards;
    mapping(address => uint256) public lastUpdatedTime;

    struct WithdrawlRequest {
        uint256 amount;
        uint256 releaseTime;
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
        } else {
            uint256 reward = getRewards(msg.sender);
            unclaimedRewards[msg.sender] = reward;
            lastUpdatedTime[msg.sender] = block.timestamp;
        }
        stakedBalances[msg.sender] += msg.value;
        totalStaked += msg.value;
    }

    function unstake(uint256 _amount) public {
        require(stakedBalances[msg.sender] >= _amount, "insufficient staked balance");

        //Calculate rewards
        uint256 reward = getRewards(msg.sender);
        unclaimedRewards[msg.sender] = reward;
        lastUpdatedTime[msg.sender] = block.timestamp;
        stakedBalances[msg.sender] -= _amount;
        totalStaked -= _amount;
        pendingWithdrawls[msg.sender].push(WithdrawlRequest(_amount, block.timestamp + 1 minutes));
    }

    function getRewards(address _address) public view returns (uint256) {
        uint256 currentReward = unclaimedRewards[_address];
        uint256 timePassed = (block.timestamp - lastUpdatedTime[_address]) / 60;
        uint256 newReward = stakedBalances[_address] * timePassed;
        return currentReward + newReward;
    }

    function claimRewards() public {
        uint256 reward = getRewards(msg.sender);
        unclaimedRewards[msg.sender] = 0;
        lastUpdatedTime[msg.sender] = block.timestamp;
        mToken.mint(msg.sender, reward);
    }

    function withdraw() public {
        uint256 totalWithdrawlAmount;
        WithdrawlRequest[] memory reqs = pendingWithdrawls[msg.sender];
        for (uint256 i = 0; i < reqs.length; i++) {
            if (block.timestamp >= reqs[i].releaseTime) {
                totalWithdrawlAmount += reqs[i].amount;
                delete pendingWithdrawls[msg.sender][i];
            }
        }
        payable(msg.sender).transfer(totalWithdrawlAmount);
    }
}
