// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "openzeppelin/proxy/utils/Initializable.sol";
import "openzeppelin/utils/Address.sol";
import {console} from "forge-std/console.sol";

contract JettyFuel is Initializable {
    // keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    address public pilot;
    uint256 public horsePower;

    struct AddressSlot {
        address value;
    }

    function initialize() external initializer {
        horsePower = 10000;
        pilot = msg.sender;
    }

    function upgradeToAndCall(address newImplementation, bytes calldata data) external payable {
        _authorizeUpgrade();
        _upgradeToAndCall(newImplementation, data);
    }

    function _authorizeUpgrade() internal view {
        require(msg.sender == pilot, "Can't upgrade");
    }

    function _upgradeToAndCall(address newImplementation, bytes memory data) internal {
        // Initial upgrade and setup call
        _setImplementation(newImplementation);
        if (data.length > 0) {
            (bool success,) = newImplementation.delegatecall(data);
            require(success, "Call failed");
        }
    }

    function _setImplementation(address newImplementation) private {
        require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");

        AddressSlot storage r;
        assembly {
            r.slot := _IMPLEMENTATION_SLOT
        }
        r.value = newImplementation;
    }
}