var mindtoken = artifacts.require("./MindToken.sol");
var mindapp = artifacts.require("./MindApp.sol");
module.exports = async function(deployer) {

  deployer.deploy(mindtoken);
  let mtkinstance = await mindtoken.deployed();

  deployer.deploy(mindapp, mtkinstance);
};
