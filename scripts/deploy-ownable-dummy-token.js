const hre = require("hardhat");

async function main() {
  const DummyToken = await hre.ethers.getContractFactory("OwnableDummyToken");
  const alpha = await DummyToken.deploy('AlphaToken', 'ALPHA', 2);
  contract = await alpha.deployed();
  console.log(contract.address)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
