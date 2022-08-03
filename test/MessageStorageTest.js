const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Deoply MessageStorage", function () {
  it("Should return default message", async function () {
    const messageStorageContractFactory = await ethers.getContractFactory("MessageStorage");
    const messageStorageContract = await messageStorageContractFactory.deploy("Hello, Hello!");
    await messageStorageContract.deployed();

    expect(await messageStorageContract.get()).to.equal("Hello, Hello!");
  });
});

describe("Call MessageStorage", function () {
  it("Should return updated message", async function () {
    const messageStorageContractFactory = await ethers.getContractFactory("MessageStorage");
    const messageStorageContract = await messageStorageContractFactory.deploy("Hello, Hello!");
    await messageStorageContract.deployed();

    expect(await messageStorageContract.get()).to.equal("Hello, Hello!");

    await messageStorageContract.update("Goodby, Goodby!");
	expect(await messageStorageContract.get()).to.equal("Goodby, Goodby!");
  });
});
