var Adoption = artifacts.require("Adoption");

module.exports = function(deployer) {
  if(deployer.network =='skipMigrations') {
    return;
  }
  deployer.deploy(Adoption);
};
