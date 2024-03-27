
NB: This report has been created using [Solidity-Metrics](https://github.com/Consensys/solidity-metrics)
<sup>

# Solidity Metrics for Scoping for mkt-market - canto-neofinance-coordinator

## Table of contents

- [Scope](#t-scope)
    - [Source Units in Scope](#t-source-Units-in-Scope)
    - [Out of Scope](#t-out-of-scope)
        - [Excluded Source Units](#t-out-of-scope-excluded-source-units)
        - [Duplicate Source Units](#t-out-of-scope-duplicate-source-units)
        - [Doppelganger Contracts](#t-out-of-scope-doppelganger-contracts)
- [Report Overview](#t-report)
    - [Risk Summary](#t-risk)
    - [Source Lines](#t-source-lines)
    - [Inline Documentation](#t-inline-documentation)
    - [Components](#t-components)
    - [Exposed Functions](#t-exposed-functions)
    - [StateVariables](#t-statevariables)
    - [Capabilities](#t-capabilities)
    - [Dependencies](#t-package-imports)
    - [Totals](#t-totals)

## <span id=t-scope>Scope</span>

This section lists files that are in scope for the metrics report.

- **Project:** `Scoping for mkt-market - canto-neofinance-coordinator`
- **Included Files:** 
4
- **Excluded Files:** 
8
- **Project analysed:** `https://github.com/mkt-market/canto-neofinance-coordinator` (`@af4e3ed3607e2a589af89270330fd9da500cec13`)

### <span id=t-source-Units-in-Scope>Source Units in Scope</span>

Source Units Analyzed: **`4`**<br>
Source Units in Scope: **`4`** (**100%**)

| Type | File   | Logic Contracts | Interfaces | Lines | nLines | SLOC | Comment Lines | Complex. Score | Capabilities |
| ---- | ------ | --------------- | ---------- | ----- | ------ | ----- | ------------- | -------------- | ------------ |
| 📝 | /src/GaugeController.sol | 1 | **** | 495 | 495 | 330 | 104 | 171 | **** |
| 📝 | /src/LendingLedger.sol | 1 | **** | 188 | 176 | 136 | 44 | 96 | **<abbr title='Payable Functions'>💰</abbr><abbr title='create/create2'>🌀</abbr>** |
| 📝🔍 | /src/LiquidityGauge.sol | 1 | 1 | 59 | 52 | 44 | 5 | 39 | **** |
| 📝 | /src/VotingEscrow.sol | 1 | **** | 564 | 552 | 385 | 131 | 199 | **<abbr title='Payable Functions'>💰</abbr>** |
| 📝🔍 | **Totals** | **4** | **1** | **1306**  | **1275** | **895** | **284** | **505** | **<abbr title='Payable Functions'>💰</abbr><abbr title='create/create2'>🌀</abbr>** |

##### <span>Legend</span>
<ul>
<li> <b>Lines</b>: total lines of the source unit </li>
<li> <b>nLines</b>: normalized lines of the source unit (e.g. normalizes functions spanning multiple lines) </li>
<li> <b>SLOC</b>: source lines of code</li>
<li> <b>Comment Lines</b>: lines containing single or block comments </li>
<li> <b>Complexity Score</b>: a custom complexity score derived from code statements that are known to introduce code complexity (branches, loops, calls, external interfaces, ...) </li>
</ul>

### <span id=t-out-of-scope>Out of Scope</span>

### <span id=t-out-of-scope-excluded-source-units>Excluded Source Units</span>
Source Units Excluded: **`8`**

| File |
| ---- |
| /src/test/utils/Utilities.sol |
| /src/test/utils/Console.sol |
| /src/test/VotingEscrow.t.sol |
| /src/test/LiquidityGauge.t.sol |
| /src/test/LendingLedger.t.sol |
| /src/test/GaugeController.t.sol |
| /script/Deploy.sol |
| /interface/Turnstile.sol |

## <span id=t-report>Report</span>

## Overview

The analysis finished with **`0`** errors and **`0`** duplicate files.





### <span style="font-weight: bold" id=t-inline-documentation>Inline Documentation</span>

- **Comment-to-Source Ratio:** On average there are`3.15` code lines per comment (lower=better).
- **ToDo's:** `0`

### <span style="font-weight: bold" id=t-components>Components</span>

| 📝Contracts   | 📚Libraries | 🔍Interfaces | 🎨Abstract |
| ------------- | ----------- | ------------ | ---------- |
| 4 | 0  | 1  | 0 |

### <span style="font-weight: bold" id=t-exposed-functions>Exposed Functions</span>

This section lists functions that are explicitly declared public or payable. Please note that getter methods for public stateVars are not included.

| 🌐Public   | 💰Payable |
| ---------- | --------- |
| 40 | 3  |

| External   | Internal | Private | Pure | View |
| ---------- | -------- | ------- | ---- | ---- |
| 34 | 51  | 2 | 2 | 16 |

### <span style="font-weight: bold" id=t-statevariables>StateVariables</span>

| Total      | 🌐Public  |
| ---------- | --------- |
| 48  | 41 |

### <span style="font-weight: bold" id=t-capabilities>Capabilities</span>

| Solidity Versions observed | 🧪 Experimental Features | 💰 Can Receive Funds | 🖥 Uses Assembly | 💣 Has Destroyable Contracts |
| -------------------------- | ------------------------ | -------------------- | ---------------- | ---------------------------- |
| `^0.8.16` |  | `yes` | **** | **** |

| 📤 Transfers ETH | ⚡ Low-Level Calls | 👥 DelegateCall | 🧮 Uses Hash Functions | 🔖 ECRecover | 🌀 New/Create/Create2 |
| ---------------- | ----------------- | --------------- | ---------------------- | ------------ | --------------------- |
| **** | **** | **** | **** | **** | `yes`<br>→ `NewContract:LiquidityGauge` |

| ♻️ TryCatch | Σ Unchecked |
| ---------- | ----------- |
| **** | **** |

### <span style="font-weight: bold" id=t-package-imports>Dependencies / External Imports</span>

| Dependency / Import Path | Count  |
| ------------------------ | ------ |
| @openzeppelin/contracts/security/ReentrancyGuard.sol | 1 |
| @openzeppelin/contracts/token/ERC20/ERC20.sol | 1 |
| @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol | 1 |
| @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol | 2 |
| @openzeppelin/contracts/utils/math/Math.sol | 2 |


##### Contract Summary

 Sūrya's Description Report

 Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| /src/GaugeController.sol | 7288d1cf6e7b5cab7f400c14fa310e3e8e6c1a13 |
| /src/LendingLedger.sol | 20a4e66f7e18b4bbeac34c2706bf95e0fcef6d5d |
| /src/LiquidityGauge.sol | ca1799724019bb4afb4ba751cfb7e5f727cebf45 |
| /src/VotingEscrow.sol | acca7f215f2c7b585aa0c04c3b43b53e6555649d |


 Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **GaugeController** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | setGovernance | External ❗️ | 🛑  | onlyGovernance |
| └ | gauge_types | External ❗️ |   |NO❗️ |
| └ | _get_type_weight | Internal 🔒 | 🛑  | |
| └ | _get_sum | Internal 🔒 | 🛑  | |
| └ | _get_total | Internal 🔒 | 🛑  | |
| └ | _get_weight | Private 🔐 | 🛑  | |
| └ | add_gauge | External ❗️ | 🛑  | onlyGovernance |
| └ | remove_gauge | External ❗️ | 🛑  | onlyGovernance |
| └ | checkpoint | External ❗️ | 🛑  |NO❗️ |
| └ | checkpoint_gauge | External ❗️ | 🛑  |NO❗️ |
| └ | _gauge_relative_weight | Private 🔐 |   | |
| └ | gauge_relative_weight | External ❗️ |   |NO❗️ |
| └ | gauge_relative_weight_write | External ❗️ | 🛑  |NO❗️ |
| └ | _change_type_weight | Internal 🔒 | 🛑  | |
| └ | add_type | External ❗️ | 🛑  | onlyGovernance |
| └ | change_type_weight | External ❗️ | 🛑  | onlyGovernance |
| └ | _change_gauge_weight | Internal 🔒 | 🛑  | |
| └ | change_gauge_weight | External ❗️ | 🛑  | onlyGovernance |
| └ | _remove_gauge_weight | Internal 🔒 | 🛑  | |
| └ | remove_gauge_weight | Public ❗️ | 🛑  | onlyGovernance |
| └ | vote_for_gauge_weights | External ❗️ | 🛑  |NO❗️ |
| └ | get_gauge_weight | External ❗️ |   |NO❗️ |
| └ | get_type_weight | External ❗️ |   |NO❗️ |
| └ | get_total_weight | External ❗️ |   |NO❗️ |
| └ | get_weights_sum_per_type | External ❗️ |   |NO❗️ |
||||||
| **LendingLedger** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | setGovernance | External ❗️ | 🛑  | onlyGovernance |
| └ | update_market | Public ❗️ | 🛑  |NO❗️ |
| └ | sync_ledger | External ❗️ | 🛑  |NO❗️ |
| └ | claim | External ❗️ | 🛑  |NO❗️ |
| └ | setRewards | External ❗️ | 🛑  | onlyGovernance |
| └ | whiteListLendingMarket | External ❗️ | 🛑  | onlyGovernance |
| └ | setBlockTimeParameters | External ❗️ | 🛑  | onlyGovernance |
| └ | <Receive Ether> | External ❗️ |  💵 |NO❗️ |
||||||
| **LendingLedger** | Interface |  |||
| └ | sync_ledger | External ❗️ | 🛑  |NO❗️ |
||||||
| **LiquidityGauge** | Implementation | ERC20, ERC20Burnable |||
| └ | <Constructor> | Public ❗️ | 🛑  | ERC20 |
| └ | depositUnderlying | External ❗️ | 🛑  |NO❗️ |
| └ | withdrawUnderlying | External ❗️ | 🛑  |NO❗️ |
| └ | _afterTokenTransfer | Internal 🔒 | 🛑  | |
||||||
| **VotingEscrow** | Implementation | ReentrancyGuard |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | setGovernance | External ❗️ | 🛑  | onlyGovernance |
| └ | toggleUnlockOverride | External ❗️ | 🛑  | onlyGovernance |
| └ | lockEnd | External ❗️ |   |NO❗️ |
| └ | getLastUserPoint | External ❗️ |   |NO❗️ |
| └ | _checkpoint | Internal 🔒 | 🛑  | |
| └ | checkpoint | External ❗️ | 🛑  |NO❗️ |
| └ | createLock | External ❗️ |  💵 | nonReentrant |
| └ | increaseAmount | External ❗️ |  💵 | nonReentrant |
| └ | withdraw | External ❗️ | 🛑  | nonReentrant |
| └ | _copyLock | Internal 🔒 |   | |
| └ | _floorToWeek | Internal 🔒 |   | |
| └ | _findBlockEpoch | Internal 🔒 |   | |
| └ | _findUserBlockEpoch | Internal 🔒 |   | |
| └ | balanceOf | Public ❗️ |   |NO❗️ |
| └ | balanceOfAt | Public ❗️ |   |NO❗️ |
| └ | totalSupply | Public ❗️ |   |NO❗️ |
| └ | totalSupplyAt | Public ❗️ |   |NO❗️ |
| └ | _supplyAt | Internal 🔒 |   | |


 Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |

____

