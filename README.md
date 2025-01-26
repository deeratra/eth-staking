# MToken and Staking Contract

## Overview

This repository contains the smart contracts for an ERC20 token called **MToken** and a **Staking Contract** where users can stake Ether (ETH) and earn rewards in **MToken**.

### Key Features:

- **MToken**: An ERC20 token given as rewards for staking.
- **Staking Contract**: Allows users to stake Ether and earn MToken rewards over time.
- **Rewards**: Users earn rewards in the form of MTokens based on the amount of ETH they stake and the duration they stake for.
- **Withdrawal Locking**: Users can only withdraw staked ETH after a specified lock period (e.g., 1 hour).

## Contracts

### MToken (ERC20 Token)

The **MToken** is a simple ERC20 token that is used as a reward for users who stake their ETH in the **Staking Contract**.

#### Key Functions:

- `mint(address to, uint amount)`: Mints new MTokens to the specified address.

### StakingContract

The **StakingContract** allows users to stake their Ether and earn MToken rewards.

#### Key Functions:

- `stake()`: Allows users to stake Ether. Users receive MToken rewards for the amount and time they stake.
- `unstake(uint _amount)`: Allows users to unstake their Ether. The amount becomes pending for withdrawal after the lock period (e.g., 1 hour).
- `getRewards(address _address)`: Calculates the total rewards a user has accumulated, based on the time staked.
- `claimRewards()`: Allows users to claim their accumulated MToken rewards.
- `withdraw()`: Allows users to withdraw the ETH that has completed the lock period.

#### Lock Periods:

- After unstaking, users need to wait for a lock period before withdrawing their ETH. This prevents farming and incentivizes longer-term staking.
