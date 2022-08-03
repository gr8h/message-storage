async function main() {
	const [owner, randomPerson] = await hre.ethers.getSigners();
	const messageStorageContractFactory = await hre.ethers.getContractFactory("MessageStorage");
	const messageStorageContract = await messageStorageContractFactory.deploy("Hello, Hello!");

	await messageStorageContract.deployed();

	console.log("Contract deployed to:", messageStorageContract.address);
	console.log("Contract deployed by:", owner.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});