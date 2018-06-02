var MyFirstToken = artifacts.require("./MyFirstToken.sol");
var Votetime = artifacts.require("./Evoting.sol");

module.exports = function(deployer){
  deployer.deploy(MyFirstToken).then(function(){
      return deployer.deploy(Votetime, MyFirstToken.address);
  });
};
