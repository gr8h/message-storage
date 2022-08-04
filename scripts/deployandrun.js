async function main() {
	const [owner, randomPerson] = await hre.ethers.getSigners();
	const messageStorageContractFactory = await hre.ethers.getContractFactory("MessageStorage");
	const messageStorageContract = await messageStorageContractFactory.deploy();

	await messageStorageContract.deployed();

	console.log("Contract deployed to:", messageStorageContract.address);
	console.log("Contract deployed by:", owner.address);

	let linkbalance = await messageStorageContract.linkBalance();
	console.log("Balance:", linkbalance.toString());

	let requestId = await messageStorageContract.update();
	console.log("RequestId:", requestId);

	let message = await messageStorageContract.get();
	console.log("Current message:", message);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});