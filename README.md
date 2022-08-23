# ✨ So you want to sponsor a contest

This `README.md` contains a set of checklists for our contest collaboration.

Your contest will use two repos: 
- **a _contest_ repo** (this one), which is used for scoping your contest and for providing information to contestants (wardens)
- **a _findings_ repo**, where issues are submitted (shared with you after the contest) 

Ultimately, when we launch the contest, this contest repo will be made public and will contain the smart contracts to be reviewed and all the information needed for contest participants. The findings repo will be made public after the contest report is published and your team has mitigated the identified issues.

Some of the checklists in this doc are for **C4 (🐺)** and some of them are for **you as the contest sponsor (⭐️)**.

---

# Contest setup

## ⭐️ Sponsor: Provide contest details

Under "SPONSORS ADD INFO HERE" heading below, include the following:

- [ ] Create a PR to this repo with the below changes:
- [ ] Name of each contract and:
  - [ ] source lines of code (excluding blank lines and comments) in each
  - [ ] external contracts called in each
  - [ ] libraries used in each
- [ ] Describe any novel or unique curve logic or mathematical models implemented in the contracts
- [ ] Does the token conform to the ERC-20 standard? In what specific ways does it differ?
- [ ] Describe anything else that adds any special logic that makes your approach unique
- [ ] Identify any areas of specific concern in reviewing the code
- [ ] Add all of the code to this repo that you want reviewed


---

# Contest prep

## ⭐️ Sponsor: Contest prep
- [ ] Provide a self-contained repository with working commands that will build (at least) all in-scope contracts, and commands that will run tests producing gas reports for the relevant contracts.
- [ ] Make sure your code is thoroughly commented using the [NatSpec format](https://docs.soliditylang.org/en/v0.5.10/natspec-format.html#natspec-format).
- [ ] Modify the bottom of this `README.md` file to describe how your code is supposed to work with links to any relevent documentation and any other criteria/details that the C4 Wardens should keep in mind when reviewing. ([Here's a well-constructed example.](https://github.com/code-423n4/2021-06-gro/blob/main/README.md))
- [ ] Please have final versions of contracts and documentation added/updated in this repo **no less than 24 hours prior to contest start time.**
- [ ] Be prepared for a 🚨code freeze🚨 for the duration of the contest — important because it establishes a level playing field. We want to ensure everyone's looking at the same code, no matter when they look during the contest. (Note: this includes your own repo, since a PR can leak alpha to our wardens!)
- [ ] Promote the contest on Twitter (optional: tag in relevant protocols, etc.)
- [ ] Share it with your own communities (blog, Discord, Telegram, email newsletters, etc.)
- [ ] Optional: pre-record a high-level overview of your protocol (not just specific smart contract functions). This saves wardens a lot of time wading through documentation.
- [ ] Delete this checklist and all text above the line below when you're ready.

---

# Olympus contest details
- $71,250 USDC main award pot
- $3,750 USDC gas optimization award pot
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2022-08-olympus-dao-contest/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts August 25, 2022 20:00 UTC
- Ends September 01, 2022 20:00 UTC

[ ⭐️ SPONSORS ADD INFO HERE ]

# Contest Scope

## Contract Details

### Kernel
- Default kernel
- Main registry for protocol
- Controlled by the `executor` address
- Has defined `Actions` for mutating state of the registry
- Intended to be used with the `OlympusGovernance` policy
- Includes all of the main dependencies used for Policies and Modules
- Uses a `KernelUtils.sol` file to define common global functions
- LOC: 459

#### KernelUtils
- Define common global utility functions to be used in any contract in the protocol
- LOC: 67

### Modules
All modules have an assigned 5-byte keycode. Also have no dependencies other than the Kernel.
#### OlympusTreasury
- Keycode: `TRSRY`
- Treasury for the protocol
- Holds all assets for the treasury
- Maintains debt balances for contracts that borrow funds
- LOC: 153

#### OlympusMinter
- Keycode: `MINTR`
- Wrapper for minting and burning capabilities of OHM token
- LOC: 40

#### OlympusPrice
- Keycode: `PRICE`
- Holds historical price oracle data for the Range-Bound Stability System
- LOC: 293

#### OlympusRange
- Keycode: `PRICE`
- Holds range data for the Range-Bound Stability System
- LOC: 347

#### OlympusInstructions
- Keycode: `INSTR`
- Used for storing batched Kernel instructions for convenient proposal execution in the Governance policy
- LOC: 80

#### OlympusVotes
- Keycode: `VOTES`
- Dummy votes token for phased governance rollout
- LOC: 64

### Policies
All policies have their module dependencies defined inside the `configureDependencies` function. Policies may also have outside dependencies, which will be listed here.

#### Operator
- Main contract for the Range-Bound Stability system
- Facilitates bond markets (cushions) and treasury swaps (walls) when appropriate.
- Ext. Dependencies: BondAuctioneer (Bond Protocol)
- LOC: 801

#### BondCallback
- Contract to be used by BondAuctioneer to allow minting/burning of OHM for bond payouts.
- Ext. Dependencies: BondAggregator (Bond Protocol)
- LOC: 194

#### Heart
- Policy for keepers to activate regularly scheduled RBS functions and be compensated.
- LOC: 153

#### PriceConfig
- Used for a specified role to adjust parameters in the `PRICE` module
- LOC: 75

#### TreasuryCustodian
- Policy to allow specified role to adjust treasury debt and approvals.
- LOC: 88

#### OlympusGovernance
- Governor contract, has vote locking and net-votes vote counting built in
- Intended to be used as the `executor` role in the Kernel
- LOC: 314

#### VoterRegistration
- Policy for distributing `VOTES` tokens (for phased rollout of governance)
- LOC: 57


## Build and Deploy
// TODO OIGHTY PLZ
`forge build`

# Documentation
## Overview

Olympus V3, aka Bophades, is the next iteration of the Olympus protocol. It is a foundation for the future of the protocol, utilizing the Default framework to allow extensibility at the base layer via fully onchain governance mechanisms. There are a few major pieces to this release: the core registry (Kernel), treasury, minter, governor, and finally, the range-bound stability (RBS) system.

## Olympus Protocol Mechanisms 
### Range-Bound Stability (RBS) system

Range-Bound Stability is a system for algorithmically using treasury assets to support OHM exchange rates with its major liquidity pairs. More details can be found here:
- [Whitepaper](https://ohm.fyi/gentle-pegging)
- [Initial spec](https://docs.google.com/document/d/1AdPex_lMpSC_3U8UEU4hiSZIT1O1FekoCujRtYEJ0ig)
- [Video overview](https://www.loom.com/share/f3b053ad02674383908d53783eccb37e)

### Governance

The Olympus governor is an adaptation of the Default governance contract, which uses token voting to interact with the kernel as its executor. This allows voters to add and remove contracts from the kernel. There are a few unique systems to this governor, like the net-votes vote counting system (vs the regular quorum voting as is common). More information can be found in the doc below.
- [Documentation](https://hackmd.io/iWgqYLFwShGUDBF4zh397w)

## Default Framework: Kernel, Modules and Policies Summary
Bophades uses the [Default Framework](https://github.com/fullyallocated/Default) to configure the protocol’s smart contracts and authorized addresses within the system. In this framework, all contract dependencies and authorizations are managed via “Actions” in the Kernel.sol contract. These actions are as follows:

- Installing/Upgrading a Module
- Activating/Deactivating a Policy
- Changing the Executor
  - Executor is the address able to call major Kernel functions
- Changing the Admin
  - Admin is controller of policy roles
- Migrating the Kernel

All non-Kernel smart contracts in the protocol are either *Module Contracts* or *Policy Contracts*, which you can think of as the protocol's "back-end” and “front-end” logic, respectively. In some ways, this shares similarities to the "core" vs. "periphery" design pattern used by protocols like Uniswap: core contracts (Modules) define the core system capabilities, while periphery contracts (Policies) expose the interfaces that enable EOAs use to interact with the protocol's various features.

#### Ownership Model: The Executor

While most protocols have ownership defined at the contract level, Default's philosophy is to define ownership at the protocol level, within the Kernel. This is the function of the Kernel's Executor—it is the address that has the ability to execute actions within the Kernel. In Default, the executor defaults to the Deployer, but this can be set to any address using the Kernel Action _ChangeExecutor_: it's entirely possible to have a Kernel managed by a single wallet, or a multisig, but it can also be a contract. In Bophades, the Kernel's owner will be the Governance (Policy) contract.

#### Role-Based Access Control: The Admin 

Protocols may sometimes have to call authorized functions to manage protocol operations, such as moving treasury funds or making adjustmenets to protocol parameters, requiring the use of operational multisigs to function correctly. To accomodate these situtations, the Kernel includes a simple role-based access control system. Not to be confused with the `permissioned` module modifier, Policies have their own modifier `onlyRole` to prevent certain functions to be called except by pre-approved addresses. In the Kernel, roles are simply two-way mappings between an address and a typed bytes32 variable, which is assigned in the Kernel via `grantRole()` and `revokeRole()`. These functions can only called by a separate address known as the *Admin*. The Admin cannot execute Kernel Actions—sole purpose is to grant and revoke roles.

Like the Executor, the Admin address defaults to the deployer, but can be changed using the Kernel Action `ChangeAdmin`.

#### Kernel Migration

The last and final action that can be performed by the Kernel is `MigrateKernel`. This action is particularly sensitive and should only be done the utmost care attention to detail. In Default, any contract that is installed or configured in a Kernel.sol needs to have an internal variable that points to the contract address of instance of the Kernel it is intended for. As a result, the same instance of a Module or a Policy cannot be reused across other Kernels. However, there may be circumstances in the future where new changes are made to the Kernel, like new Actions that are developed, gas optimizations found, or security improvements made that warrant porting the protocol contracts to a new instance of a Kernel without redeploying the contracts. 

The `MigrateKernel` Action reconfigures the internal variable for each contract registered in the Kernel, which will brick it. There are no forseeable plans to use this action in Bophades, but it's important to be aware of its' existence.

### Modules

Modules are **internal-facing smart contracts** that store shared state across the protocol, and are used as dependencies for Policies within the protocol. A module is a mix of a microservice and a data model: each Module is responsible for managing a particular data model within the system. Modules should have no dependencies of their own, and their logic should be limited to modifying their own internal state: in other words, a Module contract should not read from or the modify state of an external contract. By and large, EOAs should never call module contracts directly — if ever.
 

In Default protocols, Module contracts are referenced internally as 5 byte uppercase `KEYCODE()` representing their underlying data models. For example, an ERC20 token module might have the keycode `TOKEN`, while a Treasury module might have the keycode `TRSRY`. This abstraction is intended to help clarify and distinguish where side effects occur when the protocol experiences external interactions, which should simplify both reading, writing and auditing its business logic.

In Bophades, we have the following Modules:

- `MINTR` — The Minter Module, used for minting OHM. We use the MINTR module instead of a TOKEN module directly due to requiring backwards compatibility with the legacy OHM token.
- `TRSRY` — The Treasury Module, used for depositing and withdrawing assets within the protocol. Also manages token debt allocated to policies.
- `PRICE` — Used to store historical price oracle data. Used for the functionality of the Range-Bound Stability (RBS) system.
- `RANGE` — Stores range information for the RBS system.
- `INSTR` — The Instructions Module, used for storing batched Kernel instructions for convenient proposal execution in the Governance policy.
- `VOTES` — The Votes Module, used for keeping track of the number of votes an address has in the Governance policy. Used during phased roll-out of the governance.

In addition, Modules have a `VERSION()` and optional initialization logic `INIT()` thats called when the Module is integrated into the Kernel, which is mainly used when an existing module is upgraded and its state needs to be migrated. However, the contracts in Bophades do not utilize either of these properties, so for the purposes of the audit, these can be largely ignored.

Modules often have permissioned functions which should only be called by authorized Policy contracts, such as minting tokens or withdrawing treasury funds. These functions should include a `permissioned` modifier to ensure only authorized contracts can call access them.


### Policies

While Module contracts define _where_ protocol side effects occur, Policy contracts define _how_ they occur. Policy contracts are **external-facing contracts** that intercept inbound calls to the protocol, then compose & route all the changes made in the protocol to the corresponding Modules. As a result, Policy contracts do have external dependencies, which are the Kernel Modules that they read and write from.

In Default protocols, Policies must declare their dependencies to the Kernel as part of the contracts state. You will notice that each Policy contract has two functions `configureDependencies()`, which return a list of Kernel modules by their Keycode, and `requestPermissions()`, which the function selectors of the privileged functions they need to call from within the contract logic.

Policies are not "stateless": they can store their own state. However, unlike Modules, the state in Policies should only be used internally, and never as part of another contract's logic. One mental model you can use is that Policies store local state in the protocol, while Modules store global state: if you find that any state is re-used across multiple Policies, it should most likely be abstracted into a Module.

The following Policies are included in Bophades:


- `TreasuryCustodian.sol` — Utility policy for allowing a specified role to modify treasury state in abnormal circumstances. Used for granting and removing approvals and managing debt.
- `Operator.sol` — Main policy for the Range-Bound Stability system. Inputs market orders, spins up bond markets and facilitates swaps with the treasury in line with the RBS spec (#Range-Bound Stability (RBS) system).
- `BondCallback.sol` — Used as a callback for bond markets. Allows bond markets to mint OHM for payouts.
- `Heart.sol` — Contract to allow easy access for keepers to call RBS keeper functions.
- `PriceConfig.sol` — Used for a specified role to adjust parameters in the `PRICE` module
- `Governance.sol` — Governor contract made to work with the Default framework. // TODO
- `VoterRegistration.sol` — Policy for distributing `VOTES` tokens (for phased rollout of governance)
 


