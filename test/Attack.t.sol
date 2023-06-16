// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {JettyFuel} from "../src/JettyFuel.sol";
import {FighterJets} from "../src/FighterJets.sol";
import {Attack} from "../src/Attack.sol";
import "openzeppelin/utils/Address.sol";
import {console} from "forge-std/console.sol";

contract TestAttack is Test {

    JettyFuel public faultyImplemenation;
    JettyFuel public proxied;

    function setUp() public{

        faultyImplemenation = new JettyFuel();
        FighterJets proxy = new FighterJets(address(faultyImplemenation));
        proxied = JettyFuel(address(proxy));

        ///@notice Code to prove selfdestruct is not working in setup as well
        /**
            Attack attack = new Attack(address(faultyImplemenation));
            attack.destroy();

            assertTrue(isContract(address(attack)));
            attack.attack2();
            assertFalse(isContract(address(faultyImplemenation)));
        */
    }

    function isContract(address _addr) public view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
    /**
     * @notice This Test is working cause self destruct has no effect in foundry
     * https://github.com/foundry-rs/foundry/issues/1543
     * selfdestruct is also not working in setUp in latest patches owing to the fact that its 
     * going to deprecated soon.
     */
    function testAttackWillNotWork() public {

        assertTrue(isContract(address(faultyImplemenation)));

        vm.startPrank(makeAddr("alice"));
        Attack attack = new Attack(address(faultyImplemenation));
        attack.attack();

        vm.stopPrank();
        assertTrue(isContract(address(faultyImplemenation)));
        assertEq(faultyImplemenation.horsePower(),10000);
    }

    /**
     * @notice Simple Test proving selfdestruct is not working in foundry
     */
    function testSelfDestructDoesNotWorkInFoundry() public {

        Attack attack = new Attack(address(faultyImplemenation));
        assertTrue(isContract(address(attack)));

        attack.destroy();

        attack.faultyImplementation();
        assertTrue(isContract(address(attack)));
    }

}