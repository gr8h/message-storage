async function main() {

	const messageStorageContractFactory = await hre.ethers.getContractFactory("MessageStorage");
	const messageStorageContract = await messageStorageContractFactory.attach(
		"0xC2e4D745F6069933F12c859f0C24313d4fB44ee3" // The deployed contract address
	);
	console.log("Contract deployed to:", messageStorageContract.address);

	let linkbalance = await messageStorageContract.linkBalance();
	console.log("Balance:", linkbalance.toString());

	//let requestId = await messageStorageContract.update();
	//console.log("RequestId:", requestId);

	let message = await messageStorageContract.get();
	console.log("Current message:", message);

	//await messageStorageContract.withdrawLink();
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});