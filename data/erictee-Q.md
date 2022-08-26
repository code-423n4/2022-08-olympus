### [L-01] ```approve()``` and ```safeApprove()``` should be replaced with ```safeIncreaseAllowance()``` / ```safeDecreaseAllowance()```


#### Impact
```approve()``` & ```safeApprove()``` are deprecated and subject to a known front-running attack. Consider using  ```safeIncreaseAllowance()``` & ```safeDecreaseAllowance()``` instead.


#### Findings:
```
src/policies/Operator.sol:L167                 ohm.safeApprove(address(MINTR), type(uint256).max);

src/policies/BondCallback.sol:L57                 ohm.safeApprove(address(MINTR), type(uint256).max);

```

### [L-02] ```decimals()``` not part of ERC20 standard.


#### Impact
```decimals()``` is not part of the official ERC20 standard and might fall for tokens that do not implement it. While in practice it is very unlikely, as usually most of the tokens implement it, this should still be considered as a potential issue.


#### Findings:
```
src/modules/PRICE.sol:L84        uint8 ohmEthDecimals = _ohmEthPriceFeed.decimals();

src/modules/PRICE.sol:L87        uint8 reserveEthDecimals = _reserveEthPriceFeed.decimals();

src/policies/Operator.sol:L122        ohmDecimals = tokens_[0].decimals();

src/policies/Operator.sol:L124        reserveDecimals = tokens_[1].decimals();

src/policies/Operator.sol:L375            uint256 oracleScale = 10**uint8(int8(PRICE.decimals()) - priceDecimals);

src/policies/Operator.sol:L418            uint8 oracleDecimals = PRICE.decimals();

src/policies/Operator.sol:L493        return decimals - int8(PRICE.decimals());

src/policies/Operator.sol:L754                10**ohmDecimals * 10**PRICE.decimals()

src/policies/Operator.sol:L764                10**ohmDecimals * 10**PRICE.decimals(),

src/policies/Operator.sol:L784                    10**ohmDecimals * 10**PRICE.decimals(),

```

### [L-03] Avoid floating pragmas for non-library contracts.


#### Impact
While floating pragmas make sense for libraries to allow them to be included with multiple different versions of applications, it may be a security risk for application implementations.

A known vulnerable compiler version may accidentally be selected or security tools might fall-back to an older compiler version ending up checking a different EVM compilation that is ultimately deployed on the blockchain.

It is recommended to pin to a concrete compiler version.

#### Findings:
```
src/interfaces/IBondCallback.sol:L2     pragma solidity >=0.8.0;

src/policies/interfaces/IOperator.sol:L2     pragma solidity >=0.8.0;

src/policies/interfaces/IHeart.sol:L2     pragma solidity >=0.8.0;
```

### [L-04] ```_safemint()``` should be used rather than ```_mint()``` wherever possible


#### Impact
```_mint()``` is [discouraged](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d4d8d2ed9798cc3383912a23b5e8d5cb602f7d4b/contracts/token/ERC721/ERC721.sol#L271) in favor of ```_safeMint()``` which ensures that the recipient is either an EOA or implements ```IERC721Receiver```. Both [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d4d8d2ed9798cc3383912a23b5e8d5cb602f7d4b/contracts/token/ERC721/ERC721.sol#L238-L250) and [solmate](https://github.com/transmissions11/solmate/blob/4eaf6b68202e36f67cab379768ac6be304c8ebde/src/tokens/ERC721.sol#L180) have versions of this function


#### Findings:
```
src/modules/VOTES.sol:L36        _mint(wallet_, amount_);

```

### [L-05] Unsafe ERC20 Operation(s)


#### Impact
ERC20 operations can be unsafe due to different implementations and vulnerabilities in the standard.

It is therefore recommended to always either use OpenZeppelin's SafeERC20 library or at least to wrap each operation in a require statement.


#### Findings:
```
src/policies/Governance.sol:L259        VOTES.transferFrom(msg.sender, address(this), userVotes);

src/policies/Governance.sol:L312        VOTES.transferFrom(address(this), msg.sender, userVotes);

```

### [L-06] Events not emitted for important state changes.


#### Impact
When changing state variables events are not emitted. Emitting events allows monitoring activities with off-chain monitoring tools.


#### Findings:
```
src/policies/Operator.sol:L498             function setSpreads(uint256 cushionSpread_, uint256 wallSpread_)

src/policies/Operator.sol:L510             function setThresholdFactor(uint256 thresholdFactor_) external onlyRole("operator_policy") {

src/policies/Operator.sol:L586             function setBondContracts(IBondAuctioneer auctioneer_, IBondCallback callback_)

src/policies/BondCallback.sol:L190             function setOperator(Operator operator_) external onlyRole("callback_admin") {
```


### [N-01] Open TODOs


#### Impact
Code architecture, incentives, and error handling/reporting questions/issues should be resolved before deployment.


#### Findings:
```
src/policies/Operator.sol:L657        /// TODO determine if this should use the last price from the MA or recalculate the current price, ideally last price is ok since it should have been just updated and should include check against secondary?

src/policies/TreasuryCustodian.sol:L51    // TODO Currently allows anyone to revoke any approval EXCEPT activated policies.

src/policies/TreasuryCustodian.sol:L52    // TODO must reorg policy storage to be able to check for deactivated policies.

src/policies/TreasuryCustodian.sol:L56        // TODO Make sure `policy_` is an actual policy and not a random address.

```
