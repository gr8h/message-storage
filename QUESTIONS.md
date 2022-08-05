# Questions

## Storage:-
-------------
### How would you store a message upon a creation of a smart contract?
    - We could use the Constructor to update the message
    - In this implementation it's only possible to have a default value for the message, as the contract needs to have LINK balance before calling external API to update the message
### What is the fastest approach?
    - Store it on chain & try to optimize the code to reduce cost
### What is the most cost-efficient approach?
    - Optimize the code to reduce cost
    - Storing long strings could be very expensive in smart contract, we could store the data off-chain
      - Save the text in IPFS and save the returned hash in the blockchain
      - Save the text in DB and save the record-id in the blockchain
### Should we be able to update previously stored text or not?
    - It's based on what we need, but we need to consider that every update will cost gas and fee
### How would this choice affect the code?
    - New function that can update the message
-------------
## API
-------------
### Smart contracts cannot access off-chain data (our API) directly. What is a typical solution for this?
    - Avoid calling the API from the smart contract and send the API output to the smart contract
    - Use Oracle as intermediate between the blockchain and the API
      - [provable](https://docs.provable.xyz/#ethereum), [chainlink](https://docs.chain.link/docs/single-word-response/)

### This is a very simple task, and you can implement a solution by yourself but what risks would it pose for the larger project?
    - The Job is hosted on only one node, for production the job should be scalled/replicated to many nodes
      - Regardles of the decision to choose between Centralized or Decentralized Oracles

### How would you develop production-ready code that needs to access off-chain data? 
    - By developing Oracles that are customized to our needs for better performance
    - Scale the Oracle to multiple nodes
    - Monitor Oracles performance & availability
      - Oracle fee changes: can we get the proce on-chain?
      - Oracle logic is upgraded: how? when?
      - Oracle slow or now longer available
    - In-case of Oracle dependancy failure, we should have fallback Oracles ready to be used
-------------
## Testing
-------------
### What tests would you suggest to make sure that this smart contract is ready to use?
    - Integration testing aginist the external API
    - The dependancy on the oracle should be tested

##### Ref: [Test](https://blog.chain.link/testing-chainlink-smart-contracts/)
-------------
## Security risks
-------------
### What are the potential security risks of your solution and how to minimize them?
    - Account’s powers should be documented
    - Identify the risks if ownership is compromised
    - Off-chain Infrastructure
      - The off-chain component could the affecting on-chain if its not secured
      - The software which provides the oracel service must be secured and follow best practices such as the OWASP Secure Coding Practices
    - Centralized VS Decentralized Oracles
      - Centralized Oracles: Oracles will be protected by the owner only, however, authorized users can abuse their power
      - Decentralized Oracle: Distribute & diversify to group of nodes to a point where disrupting a quorum of nodes become not possible for an attacker.
        - How participants are incentivized and what sort of misbehavior if left unpunished
        - Participants providing (valid) data to the oracle system are economically rewarded

##### Ref: [oracle-manipulation](https://consensys.github.io/smart-contract-best-practices/attacks/oracle-manipulation/)
-------------
## Monitization
-------------
### How would you make this solution profitable?
    - Allow this smart-contract to be used by other smart-contracts to store messages for a fee
    - Optimize to reduce gas cost


-------------
## Other
-------------
    - If you can fit your data in 32 bytes, then you should use bytes32 datatype rather than bytes or strings as it is much cheaper in solidity. Basically, Any fixed size variable in solidity is cheaper than variable size.
    - Storing information inside calldata is always less expensive than storing it on memory, but it has a clear downside to it. When calldata is used, the value stored in it can’t be mutated during the function execution
    - Use bytes for arbitrary-length raw byte data and string for arbitrary-length string (UTF-8) data

##### Ref[1](https://coinsbench.com/advanced-gas-optimizations-tips-for-solidity-85c47f413dc5)
##### Ref[2](https://medium.com/@MuditG/solidity-gas-optimization-tips-1658c2bf37e8)
##### Ref[3](https://yamenmerhi.medium.com/gas-optimization-in-solidity-75945e12322f)
##### Ref[4](https://blog.openzeppelin.com/secure-smart-contract-guidelines-the-dangers-of-price-oracles/)
##### Ref[5](https://docs.chain.link/docs/single-word-response/)
##### Ref[6](https://github.com/tweether-protocol/tweether)
