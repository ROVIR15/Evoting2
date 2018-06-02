pragma solidity ^0.4.23;

import "./token/ERC20/StandardToken.sol";
import "./ownership/Ownable.sol";

contract MyFirstToken is StandardToken, Ownable {
  string public name;
  string public symbol;
  uint8 public decimals;

  constructor() public {
    name = "MyFirstToken";
    symbol = "MFT";
    decimals = 18;
    totalSupply_ = 100000000 * 10 ** uint256(decimals);
    balances[msg.sender] = totalSupply_;
  }

}
