async function main() {

	const messageStorageContractFactory = await hre.ethers.getContractFactory("MessageStorage");
	const messageStorageContract = await messageStorageContractFactory.attach(
		"0xe456466336D2ab1744495a381Fc181B40e85887b" // The deployed contract address
	);
	console.log("Contract deployed to:", messageStorageContract.address);

	let linkbalance = await messageStorageContract.linkBalance();
	console.log("Balance:", linkbalance.toString());

	//let requestId = await messageStorageContract.requestVolumeData();
	//console.log("RequestId:", requestId);

	//let message = await messageStorageContract.get();
	//console.log("Current message:", message);

	//await messageStorageContract.withdrawLink();
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});