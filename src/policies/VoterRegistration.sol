// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import {OlympusVotes} from "modules/VOTES.sol";
import "src/Kernel.sol";

/// @notice Policy to mint and burn votes to arbitrary addresses
/// @dev A policy to distribute votes for OlympusGovernance
contract VoterRegistration is Policy {
    OlympusVotes public VOTES;

    /*//////////////////////////////////////////////////////////////
                            POLICY INTERFACE
    //////////////////////////////////////////////////////////////*/

    constructor(Kernel kernel_) Policy(kernel_) {}

    /// @inheritdoc Policy
    function configureDependencies() external override returns (Keycode[] memory dependencies) {
        dependencies = new Keycode[](1);
        dependencies[0] = toKeycode("VOTES");

        VOTES = OlympusVotes(getModuleAddress(dependencies[0]));
    }

    /// @inheritdoc Policy
    function requestPermissions()
        external
        view
        override
        returns (Permissions[] memory permissions)
    {
        permissions = new Permissions[](2);
        permissions[0] = Permissions(VOTES.KEYCODE(), VOTES.mintTo.selector);
        permissions[1] = Permissions(VOTES.KEYCODE(), VOTES.burnFrom.selector);
    }

    /*//////////////////////////////////////////////////////////////
                               CORE LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Issue votes to a wallet
    /// @param  wallet_ - The address receiving the votes.
    /// @param  amount_ - The amount of votes to mint to the wallet.
    function issueVotesTo(address wallet_, uint256 amount_) external onlyRole("voter_admin") {
        // Issue the votes in the VOTES module
        VOTES.mintTo(wallet_, amount_);
    }

    /// @notice Burn votes from a wallet
    /// @param  wallet_ - The address losing the votes.
    /// @param  amount_ - The amount of votes to burn from the wallet.
    function revokeVotesFrom(address wallet_, uint256 amount_) external onlyRole("voter_admin") {
        // Revoke the votes in the VOTES module
        VOTES.burnFrom(wallet_, amount_);
    }
}
