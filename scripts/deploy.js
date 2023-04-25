const hre = require("hardhat");

async function main() {
  const DummyToken = await hre.ethers.getContractFactory("TestnetToken");
  const alpha = await TestnetToken.deploy('AlphaToken', 'ALPHA', 18, 2);
  await alpha.deployed();
  const beta = await TestnetToken.deploy('BetaToken', 'BETA', 18, 10);
  await beta.deployed();
  const gamma = await TestnetToken.deploy('GammaToken', 'GAMMA', 18, 30);
  await gamma.deployed();
  console.log(alpha);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
