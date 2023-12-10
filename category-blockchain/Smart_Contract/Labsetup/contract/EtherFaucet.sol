// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract EtherFaucet{
    uint256 public amount;
    address public owner;
    uint256 public receiveCount;
    uint256 public donationCount;
    uint256 public fallbackCount;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable {
        amount += msg.value;
	    receiveCount += 1;
    }

    fallback() external payable {
        amount += msg.value;
	    fallbackCount += 1;
    }

    function donateEther() external payable {
        amount += msg.value;
	    donationCount += 1;
    }

    function donateEtherWrong() external {
	    donationCount += 1;
    }

    event MyMessage(address indexed sender, string message, uint256 value);

    function sendEtherViaCall(uint256 _amount) external payable {
        address payable to = payable(msg.sender);
        amount -= _amount;
        (bool success, ) = to.call{value: _amount}("");
        require(success, "Failure: Ether not sent");
        emit MyMessage(msg.sender, "sendEtherViaCall: Fund sent to!", _amount);
    }

    function sendEtherViaSend(uint256 _amount) external payable {
        address payable to = payable(msg.sender);
        amount -= _amount;
        bool success = to.send(_amount);
        require(success, "Failure: Ether not sent");
        emit MyMessage(msg.sender, "sendEtherViaSend: Fund sent to!", _amount);
    }

    function sendEtherViaTransfer(uint256 _amount) external payable {
        address payable to = payable(msg.sender);
        amount -= _amount;
        to.transfer(_amount);
        emit MyMessage(msg.sender, "sendEtherViaTransfer: Fund sent to!", _amount);
    }


    function sendEtherToAddress(uint256 _amount, address payable _to) external payable {
        amount -= _amount;
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failure: Ether not sent");
        emit MyMessage(msg.sender, "sendEtherToAddress: Fund sent to!", _amount);
    }

}

