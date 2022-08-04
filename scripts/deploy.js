require("dotenv").config();

async function main() {
	const [deployer] = await hre.ethers.getSigners();

	let _chainlinkToken = process.env.CHAINLINK_TOKEN_ADDRESS; //'0x01BE23585060835E02B77ef475b0Cc51aA1e0709';
	let _chainlinkOracle = process.env.CHAINLINK_ORACLE_ADDRESS; //'0x188b71C9d27cDeE01B9b0dfF5C1aff62E8D6F434';
	let _jobId = process.env.CHAINLINK_JOBID; //'a84b561bd8f64300a0832682f208321f';

	const messageStorageContractFactory = await hre.ethers.getContractFactory("MessageStorage");
	const messageStorageContract = await messageStorageContractFactory.deploy(_chainlinkToken, _chainlinkOracle, _jobId);

	await messageStorageContract.deployed();

	console.log("Contract address:", messageStorageContract.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});