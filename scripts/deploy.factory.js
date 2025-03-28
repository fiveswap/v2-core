const hre = require("hardhat");


async function main() {

  const [addr1] = await hre.ethers.getSigners();
  const factoryContract = await ethers.getContractFactory("PentaswapV2Factory");
  this.factoryContract = await factoryContract.connect(addr1).deploy(addr1.address);

  console.log("PentaswapV2Factory deployed to:", this.factoryContract.target);
  await new Promise(r => setTimeout(r, 60000));

  try {
    await hre.run("verify:verify", {
      address: this.factoryContract.target,
      constructorArguments: [
        addr1.address,
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
