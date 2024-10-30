
const GoblinGold = artifacts.require("GoblinGold");

module.exports = function (deployer) {
  const treasuryAddress = "0xYourTreasuryAddress";  // Replace with actual treasury address
  deployer.deploy(GoblinGold, treasuryAddress);
};
