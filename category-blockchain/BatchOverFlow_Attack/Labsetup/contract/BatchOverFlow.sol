// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;


contract BatchOverFlow {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;

    constructor(uint256 initialSupply) public {
        balances[msg.sender] = initialSupply;
        totalSupply = initialSupply;
    }

    function batchTransfer(address[] calldata receivers, uint256 value) external returns (bool) {
        uint256 cnt = receivers.length;
        uint256 amount = cnt * value;  // 🛑 Risk of overflow here
        require(value > 0 , "Value should be greater than 0");
        require(balances[msg.sender] >= amount, "Not enough balance");

        for (uint i = 0; i < cnt; i++) {
            balances[receivers[i]] += value;
        }
        balances[msg.sender] -= amount;
        return true;
    }

    function getBalance(address _addr) public view returns (uint) {
        return balances[_addr];
    }

}
