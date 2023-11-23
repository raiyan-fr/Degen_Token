# DegenToken Smart Contract

## Overview

This Solidity smart contract, named DegenToken, implements an ERC-20 token with additional functionalities for an in-game store. It includes features such as token minting, transferring, redeeming for in-game items, checking token balances, and burning tokens.

## Key Features

1. **Token Minting:**
   - The contract allows the owner to mint new tokens using the `MintTokens` function. Only the owner has the authority to mint new tokens.

2. **Token Transferring:**
   - Players can transfer their tokens to others using the `transferTokens` function, which checks the sender's balance before proceeding with the transfer.

3. **Token Redeeming:**
   - Players can redeem their tokens for in-game items from the store using the `redeemTokens` function. The function ensures the player has a sufficient token balance, the item is valid and available, and then transfers the item to the player while burning the required tokens.

4. **Checking Token Balance:**
   - Players can check their token balance at any time using the `getBalance` function.

5. **Token Burning:**
   - The contract allows anyone to burn their own tokens using the `burnTokens` function when they no longer need them.

6. **Gemstone Store Initialization:**
   - The contract initializes an in-game store with 20 different gemstones during deployment. Each gemstone has a name, price, and availability status.

7. **Gemstone and Item Information:**
   - The contract defines structs (`GemStones` and `ItemInfo`) to hold information about gemstones and in-game items, respectively.

## Dependencies

- This contract relies on the following OpenZeppelin contracts:
  - [ERC20](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol) for ERC-20 token functionality.
  - [Ownable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol) for ownership management.
  - [ERC20Burnable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol) for token burning functionality.

## Deployment

Deploy it using [Remix](https://remix.ethereum.org/) to a given inejected provider specifically [Metamask](https://metamask.io/), also in any EVM networks (in this case, fuji avalanche test net).
you can also use hardhat or any other method as per your desire.

## License

This smart contract is licensed under the MIT License.


