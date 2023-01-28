// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    // state variable -> it's stored permanently in contract storage.
    uint256 totalWaves;

    // it is used to help generate a random number.
    uint256 private seed;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    event NewWave(address indexed from, uint256 timestamp, string message);

    // inidicates that the contract is payable
    constructor() payable {
        console.log("This is a smart contract!!!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    struct Wave {
        address waver; // address of the user who waved
        string message; // the message user sent
        uint256 timestamp; // the timestamp when the user waved
    }

    Wave[] waves;

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Next wave can be done after 15 seconds"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved! with message %s", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        // Give a 10% chance that the user wins the prize.
        if (seed <= 10) {
            console.log("%s won!!!", msg.sender);

            // send eth to users who wave.
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("Woah! We have %d total waves", totalWaves);
        return totalWaves;
    }
}
