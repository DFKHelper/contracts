// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Upgradeable
import {
AccessControlEnumerableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

import {IHeroCoreDiamondPartial} from "./interfaces/IHeroCoreDiamondPartial.sol";

/**
 * @title NFT Utilities
 * @notice Helper functions for NFTs
 * @dev v1.0.0
 * @author @DirtyCajunRice
 */
contract NFTUtilities is Initializable, PausableUpgradeable, AccessControlEnumerableUpgradeable, UUPSUpgradeable {
    /*************
     * Constants *
     *************/
    // DEV_ROLE is the role that is required to call dev-only gated functions (like upgrades)
    bytes32 public constant DEV_ROLE = keccak256("DEV_ROLE");
    // PAUSER_ROLE is the role that is required to call pause() and unpause()
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    // CONTRACT_ROLE is the role that is required to call contract-only gated functions
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    /*************
     * Errors *
     *************/
    error __TokenIDArrayEmpty();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        // Initialize the inherited pausable contract
        __Pausable_init();
        // Initialize the inherited AccessControlEnumerable contract
        __AccessControlEnumerable_init();
        // Initialize the inherited UUPS contract
        __UUPSUpgradeable_init();

        // Grant the deployer all roles to initialize them
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(DEV_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
    }

    /**********
     * Public *
     **********/

    /**
     * @dev Batch transfer ERC721 NFTs from msg.sender to a specified address
     * @param to The intended destination address
     * @param tokenAddress The address of the ERC721 contract
     * @param tokenIds The array of token IDs to transfer
     */
    function batchTransfer721(
        address to,
        address tokenAddress,
        uint256[] calldata tokenIds
    ) external whenNotPaused {
        // If the tokenIds array is empty, revert
        if (tokenIds.length == 0) revert __TokenIDArrayEmpty();

        // Loop over the tokenIds and transfer each one
        for (uint256 i; i < tokenIds.length; i++) {
            IERC721Upgradeable(tokenAddress).safeTransferFrom(msg.sender, to, tokenIds[i]);
        }
    }

    /**
     * @dev Batch transfer DFK Heroes with equipment/pets from msg.sender to a specified address
     * @param to The intended destination address
     * @param tokenAddress The address of the Hero Core contract
     * @param tokenIds The array of token IDs to transfer
     */
    function batchTransferDFKHeroes(
        address to,
        address tokenAddress,
        uint256[] calldata tokenIds
    ) external whenNotPaused {
        // If the tokenIds array is empty, revert
        if (tokenIds.length == 0) revert __TokenIDArrayEmpty();

        // Loop over the tokenIds and transfer each one
        for (uint256 i; i < tokenIds.length; i++) {
            IHeroCoreDiamondPartial(tokenAddress).transferHeroAndEquipmentFrom(msg.sender, to, tokenIds[i]);
        }
    }

    /*********
     * Admin *
     *********/

    /**
     * @dev Pause the contract - prevents deposits | restricted to PAUSER_ROLE
     */
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
     * @dev Unpause the contract - allows deposits | restricted to PAUSER_ROLE
     */
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _authorizeUpgrade(address newImplementation) internal onlyRole(DEV_ROLE) override {}
}
