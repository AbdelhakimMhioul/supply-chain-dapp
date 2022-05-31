// migrating the appropriate contracts
const Farmer = artifacts.require("./Roles/Farmer.sol");
const Distributor = artifacts.require("./Roles/Distributor.sol");
const Retailer = artifacts.require("./Roles/Retailer.sol");
const Consumer = artifacts.require("./Roles/Consumer.sol");
const SupplyChain = artifacts.require("SupplyChain.sol");

module.exports = function (deployer) {
   // Deploy the Roles contracts
   deployer.deploy(Farmer);
   deployer.deploy(Distributor);
   deployer.deploy(Retailer);
   deployer.deploy(Consumer);
   // Deploy the Supply Chain contracts
   deployer.deploy(SupplyChain);
};
