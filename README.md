# Message Storage

## Gas Optimization

### Using String

|  Methods         |||||||
|------------------|----------|--------------|-------------|-------------|---------------|-------------|
|  Contract        |  Method  |  Min         |  Max        |  Avg        |  # calls      |  eur (avg)  |
|  MessageStorage  |  update  |           -  |         -   |  **36544**  |            1  |        -    |
|  Deployments     |          |              |             |             |  % of limit   |             |
|  MessageStorage  |          |           -  |         -   |    559122   |       1.9 %   |        -    |

### Using calldata instead of memory
```
// Storing information inside calldata is always less expensive than storing it on memory

function update(string calldata newMessage) public onlyOwner {}
```

|  Methods         |||||||
|------------------|----------|--------------|-------------|-------------|---------------|-------------|
|  Contract        |  Method  |  Min         |  Max        |  Avg        |  # calls      |  eur (avg)  |
|  MessageStorage  |  update  |           -  |         -   |  **35906**  |            1  |        -    |
|  Deployments     |          |              |             |             |  % of limit   |             |
|  MessageStorage  |          |           -  |         -   |    538067   |       1.8 %   |        -    |