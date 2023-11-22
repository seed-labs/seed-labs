// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Caller {
    uint256 public amount;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    event MyMessage(address indexed sender, string message, uint256 value); 

    receive() external payable {
        amount += msg.value;
        emit MyMessage(msg.sender, "Fund received!", msg.value);
    }


    event ReturnValue(address indexed _from, uint256 _value);

    function invokeHello(address addr, uint _val) public returns (uint) {
       Hello c = Hello(addr);
       uint256 v =  c.increaseCounter(_val);

       emit ReturnValue(msg.sender, v);
       return v;
    }

    modifier onlyOwner {
       require (msg.sender == owner, "Sender is not owner!");
       _;
    }

    function invokeHello2(address addr, uint _val) public onlyOwner returns (uint) {
       Hello c = Hello(addr);
       uint256 v =  c.increaseCounter2{value: 1 ether}(_val);

       emit ReturnValue(msg.sender, v);
       return v;
    }

}

interface Hello{
    function sayHello() external pure returns (string memory);
    function getResult(uint a, uint b) external view returns (uint);
    function increaseCounter(uint k) external returns (uint);
    function increaseCounter2(uint k) external payable returns (uint); 
    function getCounter() external view returns (uint);
    function sendMessage() external returns (uint256);
}
