// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCheckedBlock;
    uint256 constant public BLOCK_THRESHOLD = 10;

    event FundsTransferred(address indexed from, address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(address _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lastCheckedBlock = block.number;
    }

    function stillAlive() external onlyOwner {
        lastCheckedBlock = block.number;
    }

    function checkStatus() external {
        require(block.number - lastCheckedBlock <= BLOCK_THRESHOLD, "Owner is incapacitated");
        transferFunds();
    }

    function transferFunds() internal {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available to transfer");
        payable(beneficiary).transfer(balance);
        emit FundsTransferred(address(this), beneficiary, balance);
    }

    receive() external payable {} // To receive funds
}
