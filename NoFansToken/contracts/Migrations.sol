pragma solidity ^0.5.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    _;
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
