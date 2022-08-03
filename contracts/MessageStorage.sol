// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract MessageStorage {
  constructor(string memory _message) {
    console.log("Deploying a MessageStorage with message:", _message);
  }
}
