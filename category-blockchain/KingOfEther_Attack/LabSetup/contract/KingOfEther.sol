// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract KingOfEther {
    address public king;
    uint256 public balance;

    function claimThrone() external payable {
        require(msg.value > balance, "Need to pay more to become the king");
        
        // Refund the previous king
        (bool sent, ) = king.call{value: balance}("");
        require(sent, "Failed to send Ether");
        
        balance = msg.value;
        king = msg.sender;
    }
}