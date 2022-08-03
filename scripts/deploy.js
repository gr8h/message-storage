async function main() {
	const [deployer] = await hre.ethers.getSigners();

    const accountBalance = await deployer.getBalance();
	console.log("Contract deployer:", deployer.address);
    console.log("Deployer account balance: ", accountBalance.toString());

	const messageStorageContractFactory = await hre.ethers.getContractFactory("MessageStorage");
	const messageStorageContract = await messageStorageContractFactory.deploy("Hello, Hello!");

	await messageStorageContract.deployed();

	console.log("Contract address:", messageStorageContract.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});