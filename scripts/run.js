require("dotenv").config();

async function main() {

	const messageStorageContractFactory = await hre.ethers.getContractFactory("MessageStorage");
	const messageStorageContract = await messageStorageContractFactory.attach(
		"0xD841b6e9479E708735C51dea7EC5Ba165EA523c9" // The deployed contract address
	);
	console.log("Contract deployed to:", messageStorageContract.address);

	let linkbalance = await messageStorageContract.linkBalance();
	console.log("Balance:", linkbalance.toString());

	let _url = process.env.EXTERNAL_API_URL; //'https://catfact.ninja/fact?max_length=32';
	let _path = process.env.EXTERNAL_API_PATH; //'fact'

	let requestId = await messageStorageContract.updateMessage(_url, _path);
	console.log("RequestId:", requestId);

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