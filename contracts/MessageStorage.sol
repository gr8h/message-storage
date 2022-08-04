// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract MessageStorage is ChainlinkClient, ConfirmedOwner{
    using Chainlink for Chainlink.Request;

    // Variables
    //string public message;

    bytes public data;
    string public stringData;

    bytes32 private jobId;
    uint256 private fee;

    // Events
    event UpdatedMessages(string oldMsg, string newMsg);
    event RequestVolume(bytes32 indexed requestId, bytes data);

    // Functions
    constructor() ConfirmedOwner(msg.sender) {
        
        setChainlinkToken(0x01BE23585060835E02B77ef475b0Cc51aA1e0709);
        setChainlinkOracle(0xf3FBB7f3391F62C8fe53f89B41dFC8159EE9653f);
        jobId = 'ca98366cc7314957b8c012c72f05aeeb';
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)

        console.log("Deploying a MessageStorage with message:");
    }


    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        // Set the URL to perform the GET request on
        req.add('get', 'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD');

        // Set the path to find the desired data in the API response, where the response format is:
        // {"RAW":
        //   {"ETH":
        //    {"USD":
        //     {
        //      "VOLUME24HOUR": xxx.xxx,
        //     }
        //    }
        //   }
        //  }
        // request.add("path", "RAW.ETH.USD.VOLUME24HOUR"); // Chainlink nodes prior to 1.0.0 support this format
        req.add('path', 'RAW,ETH,USD,MARKET'); // Chainlink nodes 1.0.0 and later support this format
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int256 timesAmount = 10**18;
        req.addInt('times', timesAmount);
        
        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    function fulfill(bytes32 _requestId, bytes memory _data) public recordChainlinkFulfillment(_requestId) {
        emit RequestVolume(_requestId, _data);
        data = _data;
        stringData = string(data);
    }

    function linkBalance() public view onlyOwner returns(uint256){
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        return link.balanceOf(address(this));
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }

	// Storing information inside calldata is always less expensive than storing it on memory
    //function update(string calldata newMessage) public onlyOwner {
    //    string memory oldMsg = message;
    //    message = newMessage;
    //    emit UpdatedMessages(oldMsg, newMessage);
    //}

    function get() public view returns (string memory) {
        return stringData;
    }
}
