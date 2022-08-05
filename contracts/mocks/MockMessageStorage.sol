// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract MockMessageStorage is ChainlinkClient, ConfirmedOwner{
    using Chainlink for Chainlink.Request;

    // Variables
    bytes public message;

    bytes32 private jobId;
    uint256 private fee;

    // Events
    event UpdatedMessages(bytes32 indexed requestId, bytes message);
    event SendMessages(bytes32 indexed requestId, bytes message);

    // Functions
    constructor(address _chainlinkToken, address _chainlinkOracle, string memory _jobId) ConfirmedOwner(msg.sender) {
        
        setChainlinkToken(_chainlinkToken);
        setChainlinkOracle(_chainlinkOracle);
        jobId = stringToBytes32(_jobId);
        fee = ((1 * LINK_DIVISIBILITY) / 100) * 5; // 0.05LINK
    }

    function updateMessage(string calldata _url, string calldata _path) public onlyOwner returns (bytes32 requestId) {
        console.log("Balance ---- >", getLinkBalance(), fee);
        require(getLinkBalance() >= fee, "Insufficient LINK Balance");

        _url;
        _path;
        
        message = "Cats are lovely";
        emit UpdatedMessages('', message);
        return '';
    }

    function returnedMessage(bytes32 _requestId, bytes calldata _message) public recordChainlinkFulfillment(_requestId) {
        message = _message;

        emit UpdatedMessages('', _message);
    }

    function linkBalance() public view returns(uint256){
        return getLinkBalance();
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }

    function get() public view returns (string memory) {
        return string(message);
    }

    // Private
    function stringToBytes32(string memory source) private pure returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }

    function getLinkBalance() private view returns(uint256) {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        uint256 balance = link.balanceOf(address(this));

        return balance;
    }
}
