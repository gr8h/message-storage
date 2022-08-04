// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract MessageStorage is ChainlinkClient, ConfirmedOwner{
    using Chainlink for Chainlink.Request;

    // Variables
    bytes public data;

    bytes32 private jobId;
    uint256 private fee;

    // Events
    event UpdatedMessages(bytes32 indexed requestId, bytes message);

    // Functions
    constructor() ConfirmedOwner(msg.sender) {
        
        setChainlinkToken(0x01BE23585060835E02B77ef475b0Cc51aA1e0709);
        setChainlinkOracle(0x188b71C9d27cDeE01B9b0dfF5C1aff62E8D6F434);
        jobId = 'a84b561bd8f64300a0832682f208321f';
        fee = ((1 * LINK_DIVISIBILITY) / 100) * 5; // 0.05LINK

        console.log("Deploying a MessageStorage with message:");
    }

    function update() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        // Set the URL to perform the GET request on
        req.add('get', 'https://catfact.ninja/fact?max_length=32');
        req.add('path', 'fact');
        
        // Sends the request
        return sendOperatorRequest(req, fee);
    }

    function fulfill(bytes32 _requestId, bytes memory _data) public recordChainlinkFulfillment(_requestId) {
        data = _data;

        emit UpdatedMessages(_requestId, _data);
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
        return string(data);
    }
}
