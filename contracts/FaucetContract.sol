// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Owned.sol";
import "./Logger.sol";
import "./IFaucet.sol";

contract Faucet is Owned, Logger, IFaucet { //Contract definition and Inheritance
  uint public numOfFunders; //State variable unisgned integer of 256bytes

  mapping(address => bool) private funders;// Mapping of address key value to boolean value
  mapping(uint => address) private lutFunders;// Mapping of integer key value to address value

  modifier limitWithdraw(uint withdrawAmount) {//Modifier to limit the transaction value to 0.1 ETH
    require(
      withdrawAmount <= 100000000000000000,
      "You dont need more than 0.1 ETH"
    );
    _;
  }

  receive() external payable {}//Default function to recieve value

  function emitLog() public override pure returns(bytes32) {//Basic log function
    return "Just a log";
  }

  function addFunds() override external payable {//Function to add value in contract balance and map sender's address as funders
    address funder = msg.sender;
    test3(); //Inherited function call
    if (!funders[funder]) {
      uint index = numOfFunders++;
      funders[funder] = true;
      lutFunders[index] = funder;
    }
  }
  
  function test1() external onlyOwner {
    // some managing stuff that only admin should have access to
  }

  function test2() external onlyOwner {
    // some managing stuff that only admin should have access to
  }

  function withdraw(uint withdrawAmount) override external limitWithdraw(withdrawAmount) {
    payable(msg.sender).transfer(withdrawAmount);
  }

  function getAllFunders() external view returns (address[] memory) {
    address[] memory _funders = new address[](numOfFunders);

    for (uint i = 0; i < numOfFunders; i++) {
      _funders[i] = lutFunders[i];
    }

    return _funders;
  }

  function getFunderAtIndex(uint8 index) external view returns(address) {
    return lutFunders[index];
  }
}



