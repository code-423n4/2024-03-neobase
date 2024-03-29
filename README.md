# Neobase audit details

- Total Prize Pool: $21,600
  - HM awards: $16,200
  - Analysis awards: $900
  - QA awards: $400
  - Gas awards: $400
  - Judge awards: $3,200
  - Scout awards: $500
 
❗️Awarding Note for Wardens, Judges, and Lookouts: If you want to claim your awards in $ worth of CANTO, you must follow the steps outlined in this thread; otherwise you'll be paid out in USDC.

- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-03-neobase/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts March 29, 2024 20:00 UTC
- Ends April 3, 2024 20:00 UTC

## This is a Private audit

This audit repo and its Discord channel are accessible to **certified wardens only.** Participation in private audits is bound by:

1. Code4rena's [Certified Contributor Terms and Conditions](https://github.com/code-423n4/code423n4.com/blob/main/_data/pages/certified-contributor-terms-and-conditions.md)
2. C4's [Certified Contributor Code of Professional Conduct](https://code4rena.notion.site/Code-of-Professional-Conduct-657c7d80d34045f19eee510ae06fef55)

*All discussions regarding private audits should be considered private and confidential, unless otherwise indicated.*

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-03-neobase/blob/main/4naly3er-report.md).

*Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards.*

**Mistakes by Governance:**

- We assume that all calls that are performed by the governance address are performed with the correct parameters.
- Moreover, it is the responsibility of the governance to ensure that LendingLedger always contains enough CANTO.

**Checkpoint is called at least once in five years:**

- Curve and FIAT DAO have the assumption that the VotingEscrow._checkpoint function is called at least once in a five year period. Because we use the same contracts, we also inherit this assumption.

# Overview

The contracts implement a voting-escrow incentivization model for Canto RWA (Real World Assets) similar to [veCRV](https://curve.readthedocs.io/dao-vecrv.html) with its [liquidity gauge](https://curve.readthedocs.io/dao-gauges.html). Users can lock up CANTO (for five years) in the `VotingEscrow` contract to get veCANTO. They can then vote within `GaugeController` for different markets that are white-listed by governance. Users that provide liquidity within these markets can claim CANTO (that is provided by CANTO governance) from `LendingLedger` according to their share.

For instance, there might be markets X, Y, and Z where Alice, Bob, and Charlie provide liquidity. In lending market X, Alice provides 60% of the liquidity, Bob 30%, and Charlie 10% at a particular epoch (point in time). At this epoch, market X receives 40% of all votes. Therefore, the allocations are:
- Alice: 40% * 60% = 24% of all CANTO that is allocated for this epoch.
- Bob: 40% * 30% = 12% of all CANTO that is allocated for this epoch.
- Charlie: 40% * 10% = 4% of all CANTO that is allocated for this epoch.

## Links

- Previous audits: <https://github.com/code-423n4/2023-08-verwa>
- Documentation: <https://github.com/mkt-market/canto-neofinance-coordinator/blob/master/README.md>
- Website: <https://canto.io/>
- X/Twitter: <https://twitter.com/CantoPublic>
- Discord: <https://discord.com/invite/63GmEXZsVf>

# Scope

*See [scope.txt](https://github.com/code-423n4/2024-03-neobase/blob/main/scope.txt)*

### Files in scope

File                     | Logic Contracts | Interfaces | Lines    | nLines   | SLOC
-------------------------|-----------------|------------|----------|----------|--------
/src/GaugeController.sol | 1               | ****       | 495      | 495      | 330
/src/LendingLedger.sol   | 1               | ****       | 188      | 176      | 136
/src/LiquidityGauge.sol  | 1               | 1          | 59       | 52       | 44
/src/VotingEscrow.sol    | 1               | ****       | 564      | 552      | 385
**Totals**               | **4**           | **1**      | **1306** | **1275** | **895**

## Out of scope
*See [out_of_scope.txt](https://github.com/code-423n4/2024-03-neobase/blob/main/out_of_scope.txt)*


- interface/Turnstile.sol
- script/Deploy.sol
- src/test/GaugeController.t.sol
- src/test/LendingLedger.t.sol
- src/test/LiquidityGauge.t.sol
- src/test/VotingEscrow.t.sol
- src/test/utils/Console.sol
- src/test/utils/Utilities.sol


## Scoping Q &amp; A

### General questions

| Question                                | Answer                                                      |
|-----------------------------------------|-------------------------------------------------------------|
| ERC20 used by the protocol              | any except non-standard ERC20 tokens (eg, rebase mechanism) |
| Test coverage                           | 85.15%                                                      |
| ERC721 used  by the protocol            | None                                                        |
| ERC777 used by the protocol             | None                                                        |
| ERC1155 used by the protocol            | None                                                        |
| Chains the protocol will be deployed on | Canto (chainId: 7700)                                       |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
|------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      | No     |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  | No     |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | No     |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 | Yes    |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | No     |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | No     |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | No     |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | No     |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | No     |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | No     |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | No     |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | No     |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   | No     |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | No     |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 | No     |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | No     |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | No     |

### External integrations (e.g., Uniswap) behavior in scope

| Question                                                  | Answer |
|-----------------------------------------------------------|--------|
| Enabling/disabling fees (e.g. Blur disables/enables fees) | No     |
| Pausability (e.g. Uniswap pool gets paused)               | No     |
| Upgradeability (e.g. Uniswap gets upgraded)               | No     |

### EIP compliance checklist

| Question               | Answer                   |
|------------------------|--------------------------|
| src/LiquidityGauge.sol | Should comply with ERC20 |

# Additional context

## Main invariants

Liquidity Gauge ERC20 token is always backed 1:1 by the underlying LP token

## Attack ideas (where to focus for bugs)

None

## All trusted roles in the protocol

Governance

## Describe any novel or unique curve logic or mathematical models implemented in the contracts

None, it uses the standard curve VE model (linear)

## Running tests

```bash
# Either clone with recurse
git clone https://github.com/code-423n4/2024-03-neobase.git --recurse
cd 2024-03-neobase
# Or update submodules
git submodule update --init --recursive
# To run tests
forge test
# To run code coverage
forge coverage --ir-minimum
# To run gas benchmarks
forge test --gas-report
```

**Gas report**

![](https://github.com/code-423n4/2024-03-neobase/assets/47150934/072c2d9c-6e05-4475-afc5-54fe7444aea1")

**Test coverage (inaccurate due to --ir-minimum)**

![](https://github.com/code-423n4/2024-03-neobase/assets/47150934/7fe07d56-1154-4ff9-b192-d2de24a5dc74")

## Miscellaneous

Employees of Canto and employees' family members are ineligible to participate in this audit.
