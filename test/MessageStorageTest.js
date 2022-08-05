const { expect } = require("chai");
const { ethers } = require("hardhat");

const EVM_Only_Owner =
  "VM Exception while processing transaction: reverted with reason string 'Only callable by owner'";

const EVM_Insufficient_Balance =
  "VM Exception while processing transaction: reverted with reason string 'Insufficient LINK Balance'";

describe("MessageStorage", function () {
  let owner, addr1;
  let messageStorageContract;
  let linkContract;

  beforeEach(async () => {
    let _chainlinkToken = process.env.CHAINLINK_TOKEN_ADDRESS;
    let _chainlinkOracle = process.env.CHAINLINK_ORACLE_ADDRESS;
    let _jobId = process.env.CHAINLINK_JOBID;

    [owner, addr1] = await ethers.getSigners();

    // Deploy MockLink
    const linkContractFactory = await ethers.getContractFactory("MockLink");
    linkContract = await linkContractFactory.deploy();

    // Deploy MockMessageStorage
    const messageStorageContractFactory = await ethers.getContractFactory(
      "MockMessageStorage"
    );
    messageStorageContract = await messageStorageContractFactory.deploy(
      linkContract.address,
      _chainlinkOracle,
      _jobId
    );
  });

  it("Default message should be empty", async function () {
    let balanceBefore = await messageStorageContract.linkBalance();
    expect(balanceBefore).to.equal(0);

    let message = await messageStorageContract.get();

    expect(message).to.equal("");
  });

  it("Reverts: Insufficient LINK Balanace", async function () {
    let balanceBefore = await messageStorageContract.linkBalance();
    expect(balanceBefore).to.equal(0);

    let _url = process.env.EXTERNAL_API_URL;
    let _path = process.env.EXTERNAL_API_PATH;

    await expect(
      messageStorageContract.updateMessage(_url, _path)
    ).to.be.revertedWith(EVM_Insufficient_Balance);

    let message = await messageStorageContract.get();

    expect(message).to.equal("");
  });

  it("Default message should have a value", async function () {
    //Before we can do an API request, we need to fund it with LINK
    await linkContract.transfer(messageStorageContract.address, '50000000000000000')
    
    // Validate the balance
    let balanceBefore = await messageStorageContract.linkBalance();
    expect(balanceBefore).to.equal('50000000000000000');

    // Call updateMessage & validate message
    let _url = process.env.EXTERNAL_API_URL;
    let _path = process.env.EXTERNAL_API_PATH;

    let _ = await messageStorageContract.updateMessage(_url, _path);
    let message = await messageStorageContract.get();

    expect(message).to.equal("Cats are lovely");
  });

  it("Reverts: Owner should be the only one to update the message", async function () {
    //Before we can do an API request, we need to fund it with LINK
    await linkContract.transfer(messageStorageContract.address, '50000000000000000')

    let _url = process.env.EXTERNAL_API_URL;
    let _path = process.env.EXTERNAL_API_PATH;

    let messageBefore = await messageStorageContract.get();

    await expect(
      messageStorageContract.connect(addr1).updateMessage(_url, _path)
    ).to.be.revertedWith(EVM_Only_Owner);

    let messageAfter = await messageStorageContract.get();

    expect(messageBefore).to.equal(messageAfter);
  });

  it("Reverts: Owner should be the only one to withdraw", async function () {
    let balanceBefore = await messageStorageContract.linkBalance();

    await expect(
      messageStorageContract.connect(addr1).withdrawLink()
    ).to.be.revertedWith(EVM_Only_Owner);

    let balanceAfter = await messageStorageContract.linkBalance();

    expect(balanceBefore).to.equal(balanceAfter);
  });

  it("Withdraw balance should be zero", async function () {
    //Before we can do an API request, we need to fund it with LINK
    await linkContract.transfer(messageStorageContract.address, '50000000000000000')
    
    // Validate the balance
    let balanceBefore = await messageStorageContract.linkBalance();
    expect(balanceBefore).to.equal('50000000000000000');

    // Withdraw
    await messageStorageContract.withdrawLink()

    let balanceAfter = await messageStorageContract.linkBalance();

    expect(balanceAfter).to.equal('0');
  });
});
