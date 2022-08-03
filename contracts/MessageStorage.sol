// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract MessageStorage {
    // Variables
    string public message;
    address owner;

    // Events
    event UpdatedMessages(string oldMsg, string newMsg);

    // Modifiers
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    // Functions
    constructor(string memory _message) {
        message = _message;
        owner = msg.sender;

        console.log("Deploying a MessageStorage with message:", _message);
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function update(string memory newMessage) public onlyOwner {
        string memory oldMsg = message;
        message = newMessage;
        emit UpdatedMessages(oldMsg, newMessage);
    }

    function get() public view returns (string memory) {
        return message;
    }
}
