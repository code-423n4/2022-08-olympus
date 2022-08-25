# Overview

Severity: `non-critical`, `code formatting`

The `transfer` function in the `VOTES.sol` module has an unnecessary `return true` statement due to the unconditional `revert`, and it also does not require named parameters due to them never being utilized.

Change to:

```solidity
/// @notice Transfers are locked for this token.
// solhint-disable-next-line no-unused-vars
function transfer(address, uint256) public pure override returns (bool) {
    revert VOTES_TransferDisabled();
}
```