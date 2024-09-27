const { ethers, upgrades} = require('hardhat');

const path = require('path');
const fs = require('fs');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

const pathOutputJson = path.join(__dirname, '../deploy_output.json');
let deployOutput = {};
if (fs.existsSync(pathOutputJson)) {
  deployOutput = require(pathOutputJson);
}
async function main() {
    // let deployer = new ethers.Wallet(process.env.PRIVATE_KEY, ethers.provider);
    let [owner] = await ethers.getSigners();
    console.log(`Using owner account: ${await owner.getAddress()}`)
    console.log('deployOutput.generalInfoContract = ', deployOutput.generalInfoContract)

    const factory = await ethers.getContractFactory("GeneralInfo", owner);
   // let bridgeContract;
    if (deployOutput.generalInfoContract === undefined) {
      bridgeContract = await upgrades.deployProxy(
          factory,
        [],
        {
            initializer: false,
            constructorArgs: [],
            unsafeAllow: ['constructor', 'state-variable-immutable'],
        });
    console.log('tx hash:', bridgeContract.deploymentTransaction().hash);
    } else {
        bridgeContract = factory.attach(deployOutput.generalInfoContract);
    }

    console.log('bridgeContract deployed to:', bridgeContract.target);
    deployOutput.generalInfoContract = bridgeContract.target;
    fs.writeFileSync(pathOutputJson, JSON.stringify(deployOutput, null, 1));

    const tx = await bridgeContract.initialize(process.env.INITIAL_OWNER);
    await tx.wait(1);
    console.log("init ok")

    deployOutput.generalInfoContract = bridgeContract.target;
    fs.writeFileSync(pathOutputJson, JSON.stringify(deployOutput, null, 1));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
