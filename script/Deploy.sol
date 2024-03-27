// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

import "forge-std/Script.sol";
import "../src/VotingEscrow.sol";
import "../src/LendingLedger.sol";
import "../src/GaugeController.sol";

contract DeploymentScript is Script {
    string name = "Vote-Escrowed CANTO";
    string symbol = "veCANTO";
    address governance = address(0x169F9dFeBdA65952418BEf58cEe6e79fA3d07BdB); // TODO

    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.readFile(".secret");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        VotingEscrow votingEscrow = new VotingEscrow(name, symbol, governance);
        GaugeController gaugeController = new GaugeController(address(votingEscrow), governance);
        LendingLedger lendingLedger = new LendingLedger(address(gaugeController), governance);
        vm.stopBroadcast();
    }
}
