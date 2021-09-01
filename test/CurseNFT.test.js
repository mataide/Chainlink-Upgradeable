const { ethers, upgrades } = require('hardhat');

contract("CurseNFT", () => {

  let ETHTrackerNFT;

  beforeEach(async function () {
    ETHTrackerNFT = await ethers.getContractFactory("CurseNFT");

  });

// Start test block
  describe('CurseNFT (proxy)', function () {
    it('deploys a contract', async () => {
      //console.log(inbox);
      const box = await upgrades.deployProxy(ETHTrackerNFT);
      assert.ok(await box.name() === 'CurseNFT');
    });
  });

});