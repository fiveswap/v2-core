const hre = require("hardhat");


async function main() {

  const [addr1] = await hre.ethers.getSigners();
  const factoryContract = await ethers.getContractFactory("FiveswapV2Factory");
  this.factoryContract = await factoryContract.connect(addr1).deploy("0xAd62D8f006cF20543c11fc842B54Cc4AD08285F6");

  console.log("FiveswapV2Factory deployed to:", this.factoryContract.target);
  await new Promise(r => setTimeout(r, 60000));

  try {
    await hre.run("verify:verify", {
      address: this.factoryContract.target,
      constructorArguments: [
        "0xAd62D8f006cF20543c11fc842B54Cc4AD08285F6",
      ],
    });
  } catch (err) {
    console.log(err)
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
