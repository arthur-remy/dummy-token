const hre = require("hardhat");

async function main() {
  const DummyToken = await hre.ethers.getContractFactory("DummyToken");
  const alpha = await DummyToken.deploy('AlphaToken', 'ALPHA', 2);
  await alpha.deployed();
  const beta = await DummyToken.deploy('BetaToken', 'BETA', 10);
  await beta.deployed();
  const gamma = await DummyToken.deploy('GammaToken', 'GAMMA', 30);
  await gamma.deployed();
  console.log(alpha);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
