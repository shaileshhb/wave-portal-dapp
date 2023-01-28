const main = async () => {

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");

  // this will fund the contract with 0.1 eth
  const waveContract = await waveContractFactory.deploy({ 
    value: hre.ethers.utils.parseEther("0.1"), 
  });
  await waveContract.deployed();

  console.log("contract deployed to: ", waveContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );

  console.log("contract balance: ->", hre.ethers.utils.formatEther(contractBalance))

  await waveContract.getTotalWaves();

  const waveTxn = await waveContract.wave("This is test message 1 from run.js");
  await waveTxn.wait();

  await waveContract.getTotalWaves();
  
  const waveTxn2 = await waveContract.wave("This is test message 2 from run.js");
  await waveTxn2.wait();

  await waveContract.getTotalWaves();


  let waves = await waveContract.getAllWaves()
  console.log(waves)

  contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );

  console.log("contract balance: ->", hre.ethers.utils.formatEther(contractBalance))

};

const runMain = async () => {
  try {
    await main()
    process.exit(1)
  } catch (error) {
    console.log(error);
    process.exit(1)
  }
}

runMain()