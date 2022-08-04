// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract MessageStorage is ChainlinkClient, ConfirmedOwner{
    using Chainlink for Chainlink.Request;

    // Variables
    bytes public message;

    bytes32 private jobId;
    uint256 private fee;

    // Events
    event UpdatedMessages(bytes32 indexed requestId, bytes message);

    // Functions
    constructor(address _chainlinkToken, address _chainlinkOracle, string memory _jobId) ConfirmedOwner(msg.sender) {
        
        setChainlinkToken(_chainlinkToken);
        setChainlinkOracle(_chainlinkOracle);
        jobId = stringToBytes32(_jobId);
        fee = ((1 * LINK_DIVISIBILITY) / 100) * 5; // 0.05LINK
    }

    function updateMessage(string memory _url, string memory _path) public onlyOwner returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.returnedMessage.selector);

        // Set the URL to perform the GET request on
        req.add('get', _url);
        req.add('path', _path);
        
        // Sends the request
        return sendOperatorRequest(req, fee);
    }

    function returnedMessage(bytes32 _requestId, bytes memory _message) public recordChainlinkFulfillment(_requestId) {
        message = _message;

        emit UpdatedMessages(_requestId, _message);
    }

    function linkBalance() public view onlyOwner returns(uint256){
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        return link.balanceOf(address(this));
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
}
