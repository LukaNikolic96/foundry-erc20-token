// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurToken is Script {
    // pravimo run funkciju
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (OurToken) {
        vm.startBroadcast();
        // ubacujemo nas token s pocetni supply
        OurToken ot = new OurToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ot;
    }
}