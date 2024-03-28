# Report

- [Report](#report)
  - [Gas Optimizations](#gas-optimizations)
    - [\[GAS-1\] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)](#gas-1-a--a--b-is-more-gas-effective-than-a--b-for-state-variables-excluding-arrays-and-mappings)
    - [\[GAS-2\] Use assembly to check for `address(0)`](#gas-2-use-assembly-to-check-for-address0)
    - [\[GAS-3\] Using bools for storage incurs overhead](#gas-3-using-bools-for-storage-incurs-overhead)
    - [\[GAS-4\] State variables should be cached in stack variables rather than re-reading them from storage](#gas-4-state-variables-should-be-cached-in-stack-variables-rather-than-re-reading-them-from-storage)
    - [\[GAS-5\] Use calldata instead of memory for function arguments that do not get mutated](#gas-5-use-calldata-instead-of-memory-for-function-arguments-that-do-not-get-mutated)
    - [\[GAS-6\] For Operations that will not overflow, you could use unchecked](#gas-6-for-operations-that-will-not-overflow-you-could-use-unchecked)
    - [\[GAS-7\] Use Custom Errors instead of Revert Strings to save Gas](#gas-7-use-custom-errors-instead-of-revert-strings-to-save-gas)
    - [\[GAS-8\] Stack variable used as a cheaper cache for a state variable is only used once](#gas-8-stack-variable-used-as-a-cheaper-cache-for-a-state-variable-is-only-used-once)
    - [\[GAS-9\] State variables only set in the constructor should be declared `immutable`](#gas-9-state-variables-only-set-in-the-constructor-should-be-declared-immutable)
    - [\[GAS-10\] Functions guaranteed to revert when called by normal users can be marked `payable`](#gas-10-functions-guaranteed-to-revert-when-called-by-normal-users-can-be-marked-payable)
    - [\[GAS-11\] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)](#gas-11-i-costs-less-gas-compared-to-i-or-i--1-same-for---i-vs-i---or-i---1)
    - [\[GAS-12\] Using `private` rather than `public` for constants, saves gas](#gas-12-using-private-rather-than-public-for-constants-saves-gas)
    - [\[GAS-13\] Use shift right/left instead of division/multiplication if possible](#gas-13-use-shift-rightleft-instead-of-divisionmultiplication-if-possible)
    - [\[GAS-14\] Splitting require() statements that use \&\& saves gas](#gas-14-splitting-require-statements-that-use--saves-gas)
    - [\[GAS-15\] Increments/decrements can be unchecked in for-loops](#gas-15-incrementsdecrements-can-be-unchecked-in-for-loops)
    - [\[GAS-16\] Use != 0 instead of \> 0 for unsigned integer comparison](#gas-16-use--0-instead-of--0-for-unsigned-integer-comparison)
  - [Non Critical Issues](#non-critical-issues)
    - [\[NC-1\] Missing checks for `address(0)` when assigning values to address state variables](#nc-1-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[NC-2\] Array indices should be referenced via `enum`s rather than via numeric literals](#nc-2-array-indices-should-be-referenced-via-enums-rather-than-via-numeric-literals)
    - [\[NC-3\] `constant`s should be defined rather than using magic numbers](#nc-3-constants-should-be-defined-rather-than-using-magic-numbers)
    - [\[NC-4\] Control structures do not follow the Solidity Style Guide](#nc-4-control-structures-do-not-follow-the-solidity-style-guide)
    - [\[NC-5\] Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function](#nc-5-duplicated-requirerevert-checks-should-be-refactored-to-a-modifier-or-function)
    - [\[NC-6\] Event is never emitted](#nc-6-event-is-never-emitted)
    - [\[NC-7\] Events should use parameters to convey information](#nc-7-events-should-use-parameters-to-convey-information)
    - [\[NC-8\] Event missing indexed field](#nc-8-event-missing-indexed-field)
    - [\[NC-9\] Function ordering does not follow the Solidity style guide](#nc-9-function-ordering-does-not-follow-the-solidity-style-guide)
    - [\[NC-10\] Functions should not be longer than 50 lines](#nc-10-functions-should-not-be-longer-than-50-lines)
    - [\[NC-11\] Change int to int256](#nc-11-change-int-to-int256)
    - [\[NC-12\] Interfaces should be defined in separate files from their usage](#nc-12-interfaces-should-be-defined-in-separate-files-from-their-usage)
    - [\[NC-13\] Lack of checks in setters](#nc-13-lack-of-checks-in-setters)
    - [\[NC-14\] Lines are too long](#nc-14-lines-are-too-long)
    - [\[NC-15\] Missing Event for critical parameters change](#nc-15-missing-event-for-critical-parameters-change)
    - [\[NC-16\] NatSpec is completely non-existent on functions that should have them](#nc-16-natspec-is-completely-non-existent-on-functions-that-should-have-them)
    - [\[NC-17\] Incomplete NatSpec: `@param` is missing on actually documented functions](#nc-17-incomplete-natspec-param-is-missing-on-actually-documented-functions)
    - [\[NC-18\] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor](#nc-18-use-a-modifier-instead-of-a-requireif-statement-for-a-special-msgsender-actor)
    - [\[NC-19\] Constant state variables defined more than once](#nc-19-constant-state-variables-defined-more-than-once)
    - [\[NC-20\] Consider using named mappings](#nc-20-consider-using-named-mappings)
    - [\[NC-21\] Adding a `return` statement when the function defines a named return variable, is redundant](#nc-21-adding-a-return-statement-when-the-function-defines-a-named-return-variable-is-redundant)
    - [\[NC-22\] `require()` / `revert()` statements should have descriptive reason strings](#nc-22-requirerevertstatements-should-have-descriptive-reason-strings)
    - [\[NC-23\] Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`)](#nc-23-use-scientific-notation-eg-1e18-rather-than-exponentiation-eg-1018)
    - [\[NC-24\] Use scientific notation for readability reasons for large multiples of ten](#nc-24-use-scientific-notation-for-readability-reasons-for-large-multiples-of-ten)
    - [\[NC-25\] Avoid the use of sensitive terms](#nc-25-avoid-the-use-of-sensitive-terms)
    - [\[NC-26\] Contract does not follow the Solidity style guide's suggested layout ordering](#nc-26-contract-does-not-follow-the-solidity-style-guides-suggested-layout-ordering)
    - [\[NC-27\] Use Underscores for Number Literals (add an underscore every 3 digits)](#nc-27-use-underscores-for-number-literals-add-an-underscore-every-3-digits)
    - [\[NC-28\] Internal and private variables and functions names should begin with an underscore](#nc-28-internal-and-private-variables-and-functions-names-should-begin-with-an-underscore)
    - [\[NC-29\] Event is missing `indexed` fields](#nc-29-event-is-missing-indexed-fields)
    - [\[NC-30\] `public` functions not called by the contract should be declared `external` instead](#nc-30-public-functions-not-called-by-the-contract-should-be-declared-external-instead)
    - [\[NC-31\] Variables need not be initialized to zero](#nc-31-variables-need-not-be-initialized-to-zero)
  - [Low Issues](#low-issues)
    - [\[L-1\] Some tokens may revert when zero value transfers are made](#l-1-some-tokens-may-revert-when-zero-value-transfers-are-made)
    - [\[L-2\] Missing checks for `address(0)` when assigning values to address state variables](#l-2-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[L-3\] Division by zero not prevented](#l-3-division-by-zero-not-prevented)
    - [\[L-4\] Empty `receive()/payable fallback()` function does not authenticate requests](#l-4-empty-receivepayable-fallback-function-does-not-authenticate-requests)
    - [\[L-5\] External call recipient may consume all transaction gas](#l-5-external-call-recipient-may-consume-all-transaction-gas)
    - [\[L-6\] Signature use at deadlines should be allowed](#l-6-signature-use-at-deadlines-should-be-allowed)
    - [\[L-7\] Prevent accidentally burning tokens](#l-7-prevent-accidentally-burning-tokens)
    - [\[L-8\] Possible rounding issue](#l-8-possible-rounding-issue)
    - [\[L-9\] Loss of precision](#l-9-loss-of-precision)
    - [\[L-10\] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`](#l-10-solidity-version-0820-may-not-work-on-other-chains-due-to-push0)
    - [\[L-11\] `symbol()` is not a part of the ERC-20 standard](#l-11-symbol-is-not-a-part-of-the-erc-20-standard)
  - [Medium Issues](#medium-issues)
    - [\[M-1\] Contracts are vulnerable to fee-on-transfer accounting-related issues](#m-1-contracts-are-vulnerable-to-fee-on-transfer-accounting-related-issues)
    - [\[M-2\] `block.number` means different things on different L2s](#m-2-blocknumber-means-different-things-on-different-l2s)

## Gas Optimizations

| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 21 |
| [GAS-2](#GAS-2) | Use assembly to check for `address(0)` | 7 |
| [GAS-3](#GAS-3) | Using bools for storage incurs overhead | 2 |
| [GAS-4](#GAS-4) | State variables should be cached in stack variables rather than re-reading them from storage | 1 |
| [GAS-5](#GAS-5) | Use calldata instead of memory for function arguments that do not get mutated | 1 |
| [GAS-6](#GAS-6) | For Operations that will not overflow, you could use unchecked | 162 |
| [GAS-7](#GAS-7) | Use Custom Errors instead of Revert Strings to save Gas | 30 |
| [GAS-8](#GAS-8) | Stack variable used as a cheaper cache for a state variable is only used once | 1 |
| [GAS-9](#GAS-9) | State variables only set in the constructor should be declared `immutable` | 6 |
| [GAS-10](#GAS-10) | Functions guaranteed to revert when called by normal users can be marked `payable` | 10 |
| [GAS-11](#GAS-11) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 4 |
| [GAS-12](#GAS-12) | Using `private` rather than `public` for constants, saves gas | 6 |
| [GAS-13](#GAS-13) | Use shift right/left instead of division/multiplication if possible | 2 |
| [GAS-14](#GAS-14) | Splitting require() statements that use && saves gas | 4 |
| [GAS-15](#GAS-15) | Increments/decrements can be unchecked in for-loops | 11 |
| [GAS-16](#GAS-16) | Use != 0 instead of > 0 for unsigned integer comparison | 15 |

### <a name="GAS-1"></a>[GAS-1] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)

This saves **16 gas per instance.**

*Instances (21)*:

```solidity
File: src/GaugeController.sol

102:                 t += WEEK;

120:                 t += WEEK;

158:             t += WEEK;

163:                 pt += type_sum * type_weight;

184:                 t += WEEK;

440:             points_weight[_gauge_addr][next_time].slope += new_slope.slope;

441:             points_sum[gauge_type][next_time].slope += new_slope.slope;

458:         changes_weight[_gauge_addr][new_slope.end] += new_slope.slope;

459:         changes_sum[gauge_type][new_slope.end] += new_slope.slope;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

80:                     market.accCantoPerShare += uint128(

85:                     market.secRewardsPerShare += uint128((blockDelta * 1e36) / marketSupply); // Scale by 1e18, consumers need to divide by it

86:                     i += blockDelta;

106:             user.amount += uint256(_delta);

107:             user.rewardDebt += int256((uint256(_delta) * market.accCantoPerShare) / 1e18);

108:             user.secRewardDebt += int256((uint256(_delta) * market.secRewardsPerShare) / 1e18);

146:         for (uint256 i = _fromEpoch; i <= _toEpoch; i += BLOCK_EPOCH) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

303:         locked_.amount += int128(int256(_value));

305:         locked_.delegated += int128(int256(_value));

327:         newLocked.amount += int128(int256(_value));

332:             newLocked.delegated += int128(int256(_value));

344:             newLocked.delegated += int128(int256(_value));

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-2"></a>[GAS-2] Use assembly to check for `address(0)`

*Saves 6 gas per instance*

*Instances (7)*:

```solidity
File: src/LendingLedger.sol

99:         if (liquidityGauges[lendingMarket] != address(0)) lendingMarket = liquidityGauges[lendingMarket];

160:         if (_hasGauge && liquidityGauges[_market] == address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

52:         if (from != address(0)) {

55:         if (to != address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

153:         if (_addr != address(0)) {

250:         if (_addr != address(0)) {

266:         if (_addr != address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-3"></a>[GAS-3] Using bools for storage incurs overhead

Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (2)*:

```solidity
File: src/LendingLedger.sol

20:     mapping(address => bool) public lendingMarketWhitelist;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

42:     bool public unlockOverride;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-4"></a>[GAS-4] State variables should be cached in stack variables rather than re-reading them from storage

The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (1)*:

```solidity
File: src/LiquidityGauge.sol

56:             LendingLedger(lendingLedger).sync_ledger(to, int256(amount));

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

### <a name="GAS-5"></a>[GAS-5] Use calldata instead of memory for function arguments that do not get mutated

When a function with a `memory` array is called externally, the `abi.decode()` step has to use a for-loop to copy each index of the `calldata` to the `memory` index. Each iteration of this for-loop costs at least 60 gas (i.e. `60 * <mem_array>.length`). Using `calldata` directly bypasses this loop.

If the array is passed to an `internal` function which passes the array to another internal function where the array is modified and therefore `memory` is used in the `external` call, it's still more gas-efficient to use `calldata` when the `external` function uses modifiers, since the modifiers may prevent the internal functions from being called. Structs have the same overhead as an array of length one.

 *Saves 60 gas per instance*

*Instances (1)*:

```solidity
File: src/GaugeController.sol

303:     function add_type(string memory _name, uint256 _weight) external onlyGovernance {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

### <a name="GAS-6"></a>[GAS-6] For Operations that will not overflow, you could use unchecked

*Instances (162)*:

```solidity
File: src/GaugeController.sol

4: import {VotingEscrow} from "./VotingEscrow.sol";

5: import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

16:     uint256 public constant MULTIPLIER = 10**18;

72:         uint256 last_epoch = (block.timestamp / WEEK) * WEEK;

89:         return gauge_type - 1;

100:             for (uint256 i; i < 500; ++i) {

102:                 t += WEEK;

118:             for (uint256 i; i < 500; ++i) {

120:                 t += WEEK;

121:                 uint256 d_bias = pt.slope * WEEK;

123:                     pt.bias -= d_bias;

125:                     pt.slope -= d_slope;

147:             t -= WEEK;

151:         for (int128 gauge_type; gauge_type < _n_gauge_types; ++gauge_type) {

156:         for (uint256 i; i < 500; ++i) {

158:             t += WEEK;

160:             for (int128 gauge_type; gauge_type < _n_gauge_types; ++gauge_type) {

163:                 pt += type_sum * type_weight;

182:             for (uint256 i; i < 500; ++i) {

184:                 t += WEEK;

185:                 uint256 d_bias = pt.slope * WEEK;

187:                     pt.bias -= d_bias;

189:                     pt.slope -= d_slope;

210:         gauge_types_[addr] = gauge_type + 1;

211:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

250:         uint256 t = (_time / WEEK) * WEEK;

253:             int128 gauge_type = gauge_types_[_gauge] - 1;

256:             return (MULTIPLIER * _type_weight * gauge_weight) / total_weight;

291:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

293:         _total_weight = _total_weight + old_sum * weight - old_sum * old_weight;

306:         n_gauge_types = type_id + 1;

324:         int128 gauge_type = gauge_types_[addr] - 1;

329:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

334:         uint256 new_sum = old_sum + weight - old_gauge_weight;

338:         _total_weight = _total_weight + new_sum * type_weight - old_sum * type_weight;

351:         int128 gauge_type = gauge_types_[_gauge] - 1;

352:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

361:         uint256 new_sum = old_sum_bias - old_weight_bias;

363:         points_sum[gauge_type][next_time].slope -= old_weight_slope;

366:         for (uint256 i; i < 263; ++i) {

367:             uint256 time_to_check = next_time + i * WEEK;

371:                 changes_sum[gauge_type][time_to_check] -= gauge_weight_change;

387:         require(_user_weight == 0 || gauge_types_[_gauge_addr] != 0, "Can only vote 0 on non-gauges"); // We allow withdrawing voting power from invalid (removed) gauges

392:             int128 slope_, /*uint256 ts*/

398:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

401:         int128 gauge_type = gauge_types_[_gauge_addr] - 1;

406:         if (old_slope.end > next_time) old_dt = old_slope.end - next_time;

407:         uint256 old_bias = old_slope.slope * old_dt;

409:             slope: (slope * _user_weight) / 10_000,

413:         uint256 new_dt = lock_end - next_time;

414:         uint256 new_bias = new_slope.slope * new_dt;

418:         power_used = power_used + new_slope.power - old_slope.power;

430:         points_weight[_gauge_addr][next_time].bias = Math.max(old_weight_bias + new_bias, old_bias) - old_bias;

431:         points_sum[gauge_type][next_time].bias = Math.max(old_sum_bias + new_bias, old_bias) - old_bias;

434:                 Math.max(old_weight_slope + new_slope.slope, old_slope.slope) -

437:                 Math.max(old_sum_slope + new_slope.slope, old_slope.slope) -

440:             points_weight[_gauge_addr][next_time].slope += new_slope.slope;

441:             points_sum[gauge_type][next_time].slope += new_slope.slope;

447:                 changes_weight[_gauge_addr][old_slope.end] -= old_slope.slope;

452:                 changes_sum[gauge_type][old_slope.end] -= old_slope.slope;

458:         changes_weight[_gauge_addr][new_slope.end] += new_slope.slope;

459:         changes_sum[gauge_type][new_slope.end] += new_slope.slope;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

4: import {VotingEscrow} from "./VotingEscrow.sol";

5: import {GaugeController} from "./GaugeController.sol";

6: import {LiquidityGauge} from "./LiquidityGauge.sol";

7: import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

8: import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

12:     uint256 public constant BLOCK_EPOCH = 100_000; // 100000 blocks, roughly 1 week

13:     uint256 public averageBlockTime = 5700; // Average block time in milliseconds

15:     uint256 public referenceBlockTime; // Used to convert block numbers to timestamps together with averageBlockTime

24:         uint256 amount; // Amount of cNOTE that the user has provided.

25:         int256 rewardDebt; // Amount of CANTO entitled to the user.

26:         int256 secRewardDebt; // Amount of secondary rewards entitled to the user.

36:     mapping(address => mapping(address => UserInfo)) public userInfo; // Info of each user for the different lending markets

37:     mapping(address => MarketInfo) public marketInfo; // Info of each lending market

39:     mapping(uint256 => uint256) public cantoPerBlock; // CANTO per block for each epoch

42:     mapping(address => uint256) public lendingMarketTotalBalance; // Total balance locked within the market

44:     mapping(address => address) public liquidityGauges; // Two way mapping for markets with liquidity gauge enabled

72:                     uint256 epoch = (i / BLOCK_EPOCH) * BLOCK_EPOCH; // Rewards and voting weights are aligned on a weekly basis

73:                     uint256 nextEpoch = epoch + BLOCK_EPOCH;

74:                     uint256 blockDelta = Math.min(nextEpoch, block.number) - i;

77:                     uint256 epochTime = referenceBlockTime +

78:                         ((block.number - referenceBlockNumber) * averageBlockTime) /

80:                     market.accCantoPerShare += uint128(

81:                         (blockDelta *

82:                             cantoPerBlock[epoch] *

83:                             gaugeController.gauge_relative_weight_write(_market, epochTime)) / marketSupply

85:                     market.secRewardsPerShare += uint128((blockDelta * 1e36) / marketSupply); // Scale by 1e18, consumers need to divide by it

86:                     i += blockDelta;

101:         update_market(lendingMarket); // Checks if the market is whitelisted

106:             user.amount += uint256(_delta);

107:             user.rewardDebt += int256((uint256(_delta) * market.accCantoPerShare) / 1e18);

108:             user.secRewardDebt += int256((uint256(_delta) * market.secRewardsPerShare) / 1e18);

110:             user.amount -= uint256(-_delta);

111:             user.rewardDebt -= int256((uint256(-_delta) * market.accCantoPerShare) / 1e18);

112:             user.secRewardDebt -= int256((uint256(-_delta) * market.secRewardsPerShare) / 1e18);

114:         int256 updatedMarketBalance = int256(lendingMarketTotalBalance[lendingMarket]) + _delta;

115:         require(updatedMarketBalance >= 0, "Market balance underflow"); // Sanity check performed here, but the market should ensure that this never happens

122:         update_market(_market); // Checks if the market is whitelisted

125:         int256 accumulatedCanto = int256((uint256(user.amount) * market.accCantoPerShare) / 1e18);

126:         int256 cantoToSend = accumulatedCanto - user.rewardDebt;

146:         for (uint256 i = _fromEpoch; i <= _toEpoch; i += BLOCK_EPOCH) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

4: import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

5: import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

6: import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

21:             string.concat(ERC20(_underlyingToken).symbol(), "-gauge")

53:             LendingLedger(lendingLedger).sync_ledger(from, -int256(amount));

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

4: import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

33:     uint256 public constant MULTIPLIER = 10**18;

37:     Point[1000000000000000000] public pointHistory; // 1e9 * userPointHistory-length, so sufficient for 1e9 users

157:                 userOldPoint.slope = _oldLocked.delegated / int128(int256(LOCKTIME));

158:                 userOldPoint.bias = userOldPoint.slope * int128(int256(_oldLocked.end - block.timestamp));

161:                 userNewPoint.slope = _newLocked.delegated / int128(int256(LOCKTIME));

162:                 userNewPoint.bias = userNewPoint.slope * int128(int256(_newLocked.end - block.timestamp));

170:                 userPointHistory[_addr][uEpoch + 1] = userOldPoint;

173:             userPointEpoch[_addr] = uEpoch + 1;

176:             userPointHistory[_addr][uEpoch + 1] = userNewPoint;

203:         uint256 blockSlope = 0; // dblock/dt

205:             blockSlope = (MULTIPLIER * (block.number - lastPoint.blk)) / (block.timestamp - lastPoint.ts);

212:         for (uint256 i = 0; i < 255; i++) {

215:             iterativeTime = iterativeTime + WEEK;

222:             int128 biasDelta = lastPoint.slope * int128(int256((iterativeTime - lastCheckpoint)));

223:             lastPoint.bias = lastPoint.bias - biasDelta;

224:             lastPoint.slope = lastPoint.slope + dSlope;

235:             lastPoint.blk = initialLastPoint.blk + (blockSlope * (iterativeTime - initialLastPoint.ts)) / MULTIPLIER;

238:             epoch = epoch + 1;

253:             lastPoint.slope = lastPoint.slope + userNewPoint.slope - userOldPoint.slope;

254:             lastPoint.bias = lastPoint.bias + userNewPoint.bias - userOldPoint.bias;

272:                 oldSlopeDelta = oldSlopeDelta + userOldPoint.slope;

274:                     oldSlopeDelta = oldSlopeDelta - userNewPoint.slope; // It was a new deposit, not extension

280:                     newSlopeDelta = newSlopeDelta - userNewPoint.slope; // old slope disappeared at this point

296:         uint256 unlock_time = _floorToWeek(block.timestamp + LOCKTIME); // Locktime is rounded down to weeks

303:         locked_.amount += int128(int256(_value));

305:         locked_.delegated += int128(int256(_value));

327:         newLocked.amount += int128(int256(_value));

328:         newLocked.end = _floorToWeek(block.timestamp + LOCKTIME);

332:             newLocked.delegated += int128(int256(_value));

344:             newLocked.delegated += int128(int256(_value));

364:         newLocked.delegated -= int128(int256(amountToSend));

392:         return (_t / WEEK) * WEEK;

403:         for (uint256 i = 0; i < 128; i++) {

405:             uint256 mid = (min + max + 1) / 2;

409:                 max = mid - 1;

421:         for (uint256 i = 0; i < 128; i++) {

425:             uint256 mid = (min + max + 1) / 2;

429:                 max = mid - 1;

446:         lastPoint.bias = lastPoint.bias - (lastPoint.slope * int128(int256(block.timestamp - lastPoint.ts)));

475:             Point memory point1 = pointHistory[epoch + 1];

476:             dBlock = point1.blk - point0.blk;

477:             dTime = point1.ts - point0.ts;

479:             dBlock = block.number - point0.blk;

480:             dTime = block.timestamp - point0.ts;

485:             blockTime = blockTime + ((dTime * (_blockNumber - point0.blk)) / dBlock);

488:         upoint.bias = upoint.bias - (upoint.slope * int128(int256(blockTime - upoint.ts)));

519:             Point memory pointNext = pointHistory[targetEpoch + 1];

521:                 dTime = ((_blockNumber - point.blk) * (pointNext.ts - point.ts)) / (pointNext.blk - point.blk);

524:             dTime = ((_blockNumber - point.blk) * (block.timestamp - point.ts)) / (block.number - point.blk);

527:         return _supplyAt(point, point.ts + dTime);

539:         for (uint256 i = 0; i < 255; i++) {

540:             iterativeTime = iterativeTime + WEEK;

551:             lastPoint.bias = lastPoint.bias - (lastPoint.slope * int128(int256(iterativeTime - lastPoint.ts)));

555:             lastPoint.slope = lastPoint.slope + dSlope;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-7"></a>[GAS-7] Use Custom Errors instead of Revert Strings to save Gas

Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (30)*:

```solidity
File: src/GaugeController.sol

87:         require(gauge_type != 0, "Invalid gauge address");

207:         require(gauge_type >= 0 && gauge_type < n_gauge_types, "Invalid gauge type");

208:         require(gauge_types_[addr] == 0, "Gauge already exists");

225:         require(gauge_types_[_gauge] != 0, "Invalid gauge address");

386:         require(_user_weight >= 0 && _user_weight <= 10_000, "Invalid user weight");

387:         require(_user_weight == 0 || gauge_types_[_gauge_addr] != 0, "Can only vote 0 on non-gauges"); // We allow withdrawing voting power from invalid (removed) gauges

395:         require(slope_ >= 0, "Invalid slope");

399:         require(lock_end > next_time, "Lock expires too soon");

402:         require(gauge_type >= 0, "Gauge not added");

419:         require(power_used >= 0 && power_used <= 10_000, "Used too much power");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

65:         require(lendingMarketWhitelist[_market], "Market not whitelisted");

115:         require(updatedMarketBalance >= 0, "Market balance underflow"); // Sanity check performed here, but the market should ensure that this never happens

132:             require(success, "Failed to send CANTO");

145:         require(_fromEpoch % BLOCK_EPOCH == 0 && _toEpoch % BLOCK_EPOCH == 0, "Invalid block number");

159:         require(lendingMarketWhitelist[_market] != _isWhiteListed, "No change");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

299:         require(_value > 0, "Only non zero amount");

300:         require(msg.value == _value, "Invalid value");

301:         require(locked_.amount == 0, "Lock exists");

318:         require(_value > 0, "Only non zero amount");

319:         require(msg.value == _value, "Invalid value");

320:         require(locked_.amount > 0, "No lock");

321:         require(locked_.end > block.timestamp, "Lock expired");

341:             require(locked_.amount > 0, "Delegatee has no lock");

342:             require(locked_.end > block.timestamp, "Delegatee lock expired");

356:         require(locked_.amount > 0, "No lock");

357:         require(locked_.end <= block.timestamp || unlockOverride, "Lock not expired");

358:         require(locked_.delegatee == msg.sender, "Lock delegated");

374:         require(success, "Failed to send CANTO");

455:         require(_blockNumber <= block.number, "Only past block number");

505:         require(_blockNumber <= block.number, "Only past block number");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-8"></a>[GAS-8] Stack variable used as a cheaper cache for a state variable is only used once

If the variable is only accessed once, it's cheaper to use the state variable directly that one time, and save the **3 gas** the extra stack assignment would spend

*Instances (1)*:

```solidity
File: src/VotingEscrow.sol

498:         uint256 epoch_ = globalEpoch;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-9"></a>[GAS-9] State variables only set in the constructor should be declared `immutable`

Variables only set in the constructor and never edited afterwards should be marked as immutable, as it would avoid the expensive storage-writing operation in the constructor (around **20 000 gas** per variable) and replace the expensive storage-reading operations (around **2100 gas** per reading) to a less expensive value reading (**3 gas**)

*Instances (6)*:

```solidity
File: src/GaugeController.sol

70:         votingEscrow = VotingEscrow(_votingEscrow);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

52:         gaugeController = GaugeController(_gaugeController);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

24:         underlyingToken = _underlyingToken;

25:         lendingLedger = _lendingLedger;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

85:         name = _name;

86:         symbol = _symbol;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-10"></a>[GAS-10] Functions guaranteed to revert when called by normal users can be marked `payable`

If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (10)*:

```solidity
File: src/GaugeController.sol

78:     function setGovernance(address _governance) external onlyGovernance {

206:     function add_gauge(address addr, int128 gauge_type) external onlyGovernance {

224:     function remove_gauge(address _gauge) external onlyGovernance {

303:     function add_type(string memory _name, uint256 _weight) external onlyGovernance {

316:     function change_type_weight(int128 type_id, uint256 weight) external onlyGovernance {

346:     function change_gauge_weight(address addr, uint256 weight) external onlyGovernance {

378:     function remove_gauge_weight(address _gauge) public onlyGovernance {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

60:     function setGovernance(address _governance) external onlyGovernance {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

96:     function setGovernance(address _governance) external onlyGovernance {

101:     function toggleUnlockOverride() external onlyGovernance {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-11"></a>[GAS-11] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)

Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (4)*:

```solidity
File: src/VotingEscrow.sol

212:         for (uint256 i = 0; i < 255; i++) {

403:         for (uint256 i = 0; i < 128; i++) {

421:         for (uint256 i = 0; i < 128; i++) {

539:         for (uint256 i = 0; i < 255; i++) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-12"></a>[GAS-12] Using `private` rather than `public` for constants, saves gas

If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (6)*:

```solidity
File: src/GaugeController.sol

15:     uint256 public constant WEEK = 7 days;

16:     uint256 public constant MULTIPLIER = 10**18;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

12:     uint256 public constant BLOCK_EPOCH = 100_000; // 100000 blocks, roughly 1 week

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

31:     uint256 public constant WEEK = 7 days;

32:     uint256 public constant LOCKTIME = 1825 days;

33:     uint256 public constant MULTIPLIER = 10**18;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-13"></a>[GAS-13] Use shift right/left instead of division/multiplication if possible

While the `DIV` / `MUL` opcode uses 5 gas, the `SHR` / `SHL` opcode only uses 3 gas. Furthermore, beware that Solidity's division operation also includes a division-by-0 prevention which is bypassed using shifting. Eventually, overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated, so the calculation can be unchecked in Solidity version `0.8+`

- Use `>> 1` instead of `/ 2`
- Use `>> 2` instead of `/ 4`
- Use `<< 3` instead of `* 8`
- ...
- Use `>> 5` instead of `/ 2^5 == / 32`
- Use `<< 6` instead of `* 2^6 == * 64`

TL;DR:

- Shifting left by N is like multiplying by 2^N (Each bits to the left is an increased power of 2)
- Shifting right by N is like dividing by 2^N (Each bits to the right is a decreased power of 2)

*Saves around 2 gas + 20 for unchecked per instance*

*Instances (2)*:

```solidity
File: src/VotingEscrow.sol

405:             uint256 mid = (min + max + 1) / 2;

425:             uint256 mid = (min + max + 1) / 2;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-14"></a>[GAS-14] Splitting require() statements that use && saves gas

*Instances (4)*:

```solidity
File: src/GaugeController.sol

207:         require(gauge_type >= 0 && gauge_type < n_gauge_types, "Invalid gauge type");

386:         require(_user_weight >= 0 && _user_weight <= 10_000, "Invalid user weight");

419:         require(power_used >= 0 && power_used <= 10_000, "Used too much power");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

145:         require(_fromEpoch % BLOCK_EPOCH == 0 && _toEpoch % BLOCK_EPOCH == 0, "Invalid block number");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

### <a name="GAS-15"></a>[GAS-15] Increments/decrements can be unchecked in for-loops

In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (11)*:

```solidity
File: src/GaugeController.sol

100:             for (uint256 i; i < 500; ++i) {

118:             for (uint256 i; i < 500; ++i) {

151:         for (int128 gauge_type; gauge_type < _n_gauge_types; ++gauge_type) {

156:         for (uint256 i; i < 500; ++i) {

160:             for (int128 gauge_type; gauge_type < _n_gauge_types; ++gauge_type) {

182:             for (uint256 i; i < 500; ++i) {

366:         for (uint256 i; i < 263; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

212:         for (uint256 i = 0; i < 255; i++) {

403:         for (uint256 i = 0; i < 128; i++) {

421:         for (uint256 i = 0; i < 128; i++) {

539:         for (uint256 i = 0; i < 255; i++) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="GAS-16"></a>[GAS-16] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (15)*:

```solidity
File: src/GaugeController.sol

98:         if (t > 0) {

116:         if (t > 0) {

180:         if (t > 0) {

252:         if (total_weight > 0) {

369:             if (gauge_weight_change > 0) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

69:             if (marketSupply > 0) {

130:         if (cantoToSend > 0) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

156:             if (_oldLocked.end > block.timestamp && _oldLocked.delegated > 0) {

160:             if (_newLocked.end > block.timestamp && _newLocked.delegated > 0) {

194:         if (epoch > 0) {

299:         require(_value > 0, "Only non zero amount");

318:         require(_value > 0, "Only non zero amount");

320:         require(locked_.amount > 0, "No lock");

341:             require(locked_.amount > 0, "Delegatee has no lock");

356:         require(locked_.amount > 0, "No lock");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

## Non Critical Issues

| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 8 |
| [NC-2](#NC-2) | Array indices should be referenced via `enum`s rather than via numeric literals | 1 |
| [NC-3](#NC-3) | `constant`s should be defined rather than using magic numbers | 17 |
| [NC-4](#NC-4) | Control structures do not follow the Solidity Style Guide | 14 |
| [NC-5](#NC-5) | Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function | 10 |
| [NC-6](#NC-6) | Event is never emitted | 1 |
| [NC-7](#NC-7) | Events should use parameters to convey information | 1 |
| [NC-8](#NC-8) | Event missing indexed field | 1 |
| [NC-9](#NC-9) | Function ordering does not follow the Solidity style guide | 3 |
| [NC-10](#NC-10) | Functions should not be longer than 50 lines | 43 |
| [NC-11](#NC-11) | Change int to int256 | 21 |
| [NC-12](#NC-12) | Interfaces should be defined in separate files from their usage | 1 |
| [NC-13](#NC-13) | Lack of checks in setters | 4 |
| [NC-14](#NC-14) | Lines are too long | 1 |
| [NC-15](#NC-15) | Missing Event for critical parameters change | 6 |
| [NC-16](#NC-16) | NatSpec is completely non-existent on functions that should have them | 8 |
| [NC-17](#NC-17) | Incomplete NatSpec: `@param` is missing on actually documented functions | 1 |
| [NC-18](#NC-18) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 5 |
| [NC-19](#NC-19) | Constant state variables defined more than once | 4 |
| [NC-20](#NC-20) | Consider using named mappings | 24 |
| [NC-21](#NC-21) | Adding a `return` statement when the function defines a named return variable, is redundant | 2 |
| [NC-22](#NC-22) | `require()` / `revert()` statements should have descriptive reason strings | 3 |
| [NC-23](#NC-23) | Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`) | 2 |
| [NC-24](#NC-24) | Use scientific notation for readability reasons for large multiples of ten | 1 |
| [NC-25](#NC-25) | Avoid the use of sensitive terms | 9 |
| [NC-26](#NC-26) | Contract does not follow the Solidity style guide's suggested layout ordering | 4 |
| [NC-27](#NC-27) | Use Underscores for Number Literals (add an underscore every 3 digits) | 4 |
| [NC-28](#NC-28) | Internal and private variables and functions names should begin with an underscore | 7 |
| [NC-29](#NC-29) | Event is missing `indexed` fields | 4 |
| [NC-30](#NC-30) | `public` functions not called by the contract should be declared `external` instead | 5 |
| [NC-31](#NC-31) | Variables need not be initialized to zero | 11 |

### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (8)*:

```solidity
File: src/GaugeController.sol

71:         governance = _governance;

79:         governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

53:         governance = _governance;

61:         governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

24:         underlyingToken = _underlyingToken;

25:         lendingLedger = _lendingLedger;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

87:         governance = _governance;

97:         governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-2"></a>[NC-2] Array indices should be referenced via `enum`s rather than via numeric literals

*Instances (1)*:

```solidity
File: src/VotingEscrow.sol

84:         pointHistory[0] = Point({bias: int128(0), slope: int128(0), ts: block.timestamp, blk: block.number});

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-3"></a>[NC-3] `constant`s should be defined rather than using magic numbers

Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (17)*:

```solidity
File: src/GaugeController.sol

100:             for (uint256 i; i < 500; ++i) {

118:             for (uint256 i; i < 500; ++i) {

156:         for (uint256 i; i < 500; ++i) {

182:             for (uint256 i; i < 500; ++i) {

366:         for (uint256 i; i < 263; ++i) {

386:         require(_user_weight >= 0 && _user_weight <= 10_000, "Invalid user weight");

409:             slope: (slope * _user_weight) / 10_000,

419:         require(power_used >= 0 && power_used <= 10_000, "Used too much power");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

13:     uint256 public averageBlockTime = 5700; // Average block time in milliseconds

79:                         1000;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

27:     uint256 public decimals = 18;

212:         for (uint256 i = 0; i < 255; i++) {

403:         for (uint256 i = 0; i < 128; i++) {

405:             uint256 mid = (min + max + 1) / 2;

421:         for (uint256 i = 0; i < 128; i++) {

425:             uint256 mid = (min + max + 1) / 2;

539:         for (uint256 i = 0; i < 255; i++) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-4"></a>[NC-4] Control structures do not follow the Solidity Style Guide

See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (14)*:

```solidity
File: src/GaugeController.sol

101:                 if (t > block.timestamp) break;

104:                 if (t > block.timestamp) time_type_weight[gauge_type] = t;

119:                 if (t > block.timestamp) break;

131:                 if (t > block.timestamp) time_sum[gauge_type] = t;

157:             if (t > block.timestamp) break;

183:                 if (t > block.timestamp) break;

195:                 if (t > block.timestamp) time_weight[_gauge_addr] = t;

215:         if (time_sum[gauge_type] == 0) time_sum[gauge_type] = next_time;

406:         if (old_slope.end > next_time) old_dt = old_slope.end - next_time;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

36:     mapping(address => mapping(address => UserInfo)) public userInfo; // Info of each user for the different lending markets

99:         if (liquidityGauges[lendingMarket] != address(0)) lendingMarket = liquidityGauges[lendingMarket];

101:         update_market(lendingMarket); // Checks if the market is whitelisted

122:         update_market(_market); // Checks if the market is whitelisted

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

404:             if (min >= max) break;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-5"></a>[NC-5] Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function

*Instances (10)*:

```solidity
File: src/GaugeController.sol

87:         require(gauge_type != 0, "Invalid gauge address");

225:         require(gauge_types_[_gauge] != 0, "Invalid gauge address");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

299:         require(_value > 0, "Only non zero amount");

300:         require(msg.value == _value, "Invalid value");

318:         require(_value > 0, "Only non zero amount");

319:         require(msg.value == _value, "Invalid value");

320:         require(locked_.amount > 0, "No lock");

356:         require(locked_.amount > 0, "No lock");

455:         require(_blockNumber <= block.number, "Only past block number");

505:         require(_blockNumber <= block.number, "Only past block number");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-6"></a>[NC-6] Event is never emitted

The following are defined but never emitted. They can be removed to make the code cleaner.

*Instances (1)*:

```solidity
File: src/VotingEscrow.sol

22:     event Unlock();

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-7"></a>[NC-7] Events should use parameters to convey information

For example, rather than using `event Paused()` and `event Unpaused()`, use `event PauseState(address indexed whoChangedIt, bool wasPaused, bool isNowPaused)`

*Instances (1)*:

```solidity
File: src/VotingEscrow.sol

22:     event Unlock();

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-8"></a>[NC-8] Event missing indexed field

Index event fields make the field more quickly accessible [to off-chain tools](https://ethereum.stackexchange.com/questions/40396/can-somebody-please-explain-the-concept-of-event-indexing) that parse events. This is especially useful when it comes to filtering based on an address. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Where applicable, each `event` should use three `indexed` fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three applicable fields, all of the applicable fields should be indexed.

*Instances (1)*:

```solidity
File: src/GaugeController.sol

19:     event NewType(string mame, int128 type_id);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

### <a name="NC-9"></a>[NC-9] Function ordering does not follow the Solidity style guide

According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (3)*:

```solidity
File: src/GaugeController.sol

1: 
   Current order:
   external setGovernance
   external gauge_types
   internal _get_type_weight
   internal _get_sum
   internal _get_total
   private _get_weight
   external add_gauge
   external remove_gauge
   external checkpoint
   external checkpoint_gauge
   private _gauge_relative_weight
   external gauge_relative_weight
   external gauge_relative_weight_write
   internal _change_type_weight
   external add_type
   external change_type_weight
   internal _change_gauge_weight
   external change_gauge_weight
   internal _remove_gauge_weight
   public remove_gauge_weight
   external vote_for_gauge_weights
   external get_gauge_weight
   external get_type_weight
   external get_total_weight
   external get_weights_sum_per_type
   
   Suggested order:
   external setGovernance
   external gauge_types
   external add_gauge
   external remove_gauge
   external checkpoint
   external checkpoint_gauge
   external gauge_relative_weight
   external gauge_relative_weight_write
   external add_type
   external change_type_weight
   external change_gauge_weight
   external vote_for_gauge_weights
   external get_gauge_weight
   external get_type_weight
   external get_total_weight
   external get_weights_sum_per_type
   public remove_gauge_weight
   internal _get_type_weight
   internal _get_sum
   internal _get_total
   internal _change_type_weight
   internal _change_gauge_weight
   internal _remove_gauge_weight
   private _get_weight
   private _gauge_relative_weight

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

1: 
   Current order:
   external setGovernance
   public update_market
   external sync_ledger
   external claim
   external setRewards
   external whiteListLendingMarket
   external setBlockTimeParameters
   
   Suggested order:
   external setGovernance
   external sync_ledger
   external claim
   external setRewards
   external whiteListLendingMarket
   external setBlockTimeParameters
   public update_market

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

1: 
   Current order:
   external setGovernance
   external toggleUnlockOverride
   external lockEnd
   external getLastUserPoint
   internal _checkpoint
   external checkpoint
   external createLock
   external increaseAmount
   external withdraw
   internal _copyLock
   internal _floorToWeek
   internal _findBlockEpoch
   internal _findUserBlockEpoch
   public balanceOf
   public balanceOfAt
   public totalSupply
   public totalSupplyAt
   internal _supplyAt
   
   Suggested order:
   external setGovernance
   external toggleUnlockOverride
   external lockEnd
   external getLastUserPoint
   external checkpoint
   external createLock
   external increaseAmount
   external withdraw
   public balanceOf
   public balanceOfAt
   public totalSupply
   public totalSupplyAt
   internal _checkpoint
   internal _copyLock
   internal _floorToWeek
   internal _findBlockEpoch
   internal _findUserBlockEpoch
   internal _supplyAt

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-10"></a>[NC-10] Functions should not be longer than 50 lines

Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability

*Instances (43)*:

```solidity
File: src/GaugeController.sol

78:     function setGovernance(address _governance) external onlyGovernance {

85:     function gauge_types(address _addr) external view returns (int128) {

96:     function _get_type_weight(int128 gauge_type) internal returns (uint256) {

114:     function _get_sum(int128 gauge_type) internal returns (uint256) {

142:     function _get_total() internal returns (uint256) {

178:     function _get_weight(address _gauge_addr) private returns (uint256) {

206:     function add_gauge(address addr, int128 gauge_type) external onlyGovernance {

224:     function remove_gauge(address _gauge) external onlyGovernance {

238:     function checkpoint_gauge(address _gauge) external {

249:     function _gauge_relative_weight(address _gauge, uint256 _time) private view returns (uint256) {

268:     function gauge_relative_weight(address _gauge, uint256 _time) external view returns (uint256) {

278:     function gauge_relative_weight_write(address _gauge, uint256 _time) external returns (uint256) {

287:     function _change_type_weight(int128 type_id, uint256 weight) internal {

303:     function add_type(string memory _name, uint256 _weight) external onlyGovernance {

316:     function change_type_weight(int128 type_id, uint256 weight) external onlyGovernance {

323:     function _change_gauge_weight(address addr, uint256 weight) internal {

346:     function change_gauge_weight(address addr, uint256 weight) external onlyGovernance {

350:     function _remove_gauge_weight(address _gauge) internal {

378:     function remove_gauge_weight(address _gauge) public onlyGovernance {

385:     function vote_for_gauge_weights(address _gauge_addr, uint256 _user_weight) external {

472:     function get_gauge_weight(address _gauge) external view returns (uint256) {

479:     function get_type_weight(int128 type_id) external view returns (uint256) {

485:     function get_total_weight() external view returns (uint256) {

492:     function get_weights_sum_per_type(int128 type_id) external view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

60:     function setGovernance(address _governance) external onlyGovernance {

96:     function sync_ledger(address _lender, int256 _delta) external {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

9:     function sync_ledger(address _lender, int256 _delta) external;

30:     function depositUnderlying(uint256 _amount) external {

39:     function withdrawUnderlying(uint256 _amount) external {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

96:     function setGovernance(address _governance) external onlyGovernance {

101:     function toggleUnlockOverride() external onlyGovernance {

112:     function lockEnd(address _addr) external view returns (uint256) {

295:     function createLock(uint256 _value) external payable nonReentrant {

315:     function increaseAmount(uint256 _value) external payable nonReentrant {

379:     function _copyLock(LockedBalance memory _locked) internal pure returns (LockedBalance memory) {

391:     function _floorToWeek(uint256 _t) internal pure returns (uint256) {

398:     function _findBlockEpoch(uint256 _block, uint256 _maxEpoch) internal view returns (uint256) {

418:     function _findUserBlockEpoch(address _addr, uint256 _block) internal view returns (uint256) {

440:     function balanceOf(address _owner) public view returns (uint256) {

454:     function balanceOfAt(address _owner, uint256 _blockNumber) public view returns (uint256) {

497:     function totalSupply() public view returns (uint256) {

504:     function totalSupplyAt(uint256 _blockNumber) public view returns (uint256) {

534:     function _supplyAt(Point memory _point, uint256 _t) internal view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-11"></a>[NC-11] Change int to int256

Throughout the code base, some variables are declared as `int`. To favor explicitness, consider changing all instances of `int` to `int256`

*Instances (21)*:

```solidity
File: src/GaugeController.sol

51:     struct Point {

117:             Point memory pt = points_sum[gauge_type][t];

181:             Point memory pt = points_weight[_gauge_addr][t];

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

45:     struct Point {

134:         Point memory point = userPointHistory[_addr][uepoch];

147:         Point memory userOldPoint;

148:         Point memory userNewPoint;

193:         Point memory lastPoint = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number});

195:             lastPoint = pointHistory[epoch];

197:         uint256 lastCheckpoint = lastPoint.ts;

202:         Point memory initialLastPoint = Point({bias: 0, slope: 0, ts: lastPoint.ts, blk: lastPoint.blk});

233:             lastCheckpoint = iterativeTime;

445:         Point memory lastPoint = userPointHistory[_owner][epoch];

462:         Point memory upoint = userPointHistory[_owner][userEpoch];

467:         Point memory point0 = pointHistory[epoch];

475:             Point memory point1 = pointHistory[epoch + 1];

499:         Point memory lastPoint = pointHistory[epoch_];

510:         Point memory point = pointHistory[targetEpoch];

519:             Point memory pointNext = pointHistory[targetEpoch + 1];

534:     function _supplyAt(Point memory _point, uint256 _t) internal view returns (uint256) {

535:         Point memory lastPoint = _point;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-12"></a>[NC-12] Interfaces should be defined in separate files from their usage

The interfaces below should be defined in separate files, so that it's easier for future projects to import them, and to avoid duplication later on if they need to be used elsewhere in the project

*Instances (1)*:

```solidity
File: src/LiquidityGauge.sol

8: interface LendingLedger {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

### <a name="NC-13"></a>[NC-13] Lack of checks in setters

Be it sanity checks (like checks against `0`-values) or initial setting checks: it's best for Setter functions to have them

*Instances (4)*:

```solidity
File: src/GaugeController.sol

78:     function setGovernance(address _governance) external onlyGovernance {
            governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

60:     function setGovernance(address _governance) external onlyGovernance {
            governance = _governance;

177:     function setBlockTimeParameters(
             uint256 _averageBlockTime,
             uint256 _referenceBlockTime,
             uint256 _referenceBlockNumber
         ) external onlyGovernance {
             averageBlockTime = _averageBlockTime;
             referenceBlockTime = _referenceBlockTime;
             referenceBlockNumber = _referenceBlockNumber;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

96:     function setGovernance(address _governance) external onlyGovernance {
            governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-14"></a>[NC-14] Lines are too long

Usually lines in source code are limited to [80](https://softwareengineering.stackexchange.com/questions/148677/why-is-80-characters-the-standard-limit-for-code-width) characters. Today's screens are much larger so it's reasonable to stretch this in some cases. Since the files will most likely reside in GitHub, and GitHub starts using a scroll bar in all cases when the length is over [164](https://github.com/aizatto/character-length) characters, the lines below should be split when they reach that length

*Instances (1)*:

```solidity
File: src/GaugeController.sol

387:         require(_user_weight == 0 || gauge_types_[_gauge_addr] != 0, "Can only vote 0 on non-gauges"); // We allow withdrawing voting power from invalid (removed) gauges

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

### <a name="NC-15"></a>[NC-15] Missing Event for critical parameters change

Events help non-contract tools to track changes, and events prevent users from being surprised by changes.

*Instances (6)*:

```solidity
File: src/GaugeController.sol

78:     function setGovernance(address _governance) external onlyGovernance {
            governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

60:     function setGovernance(address _governance) external onlyGovernance {
            governance = _governance;

64:     function update_market(address _market) public {
            require(lendingMarketWhitelist[_market], "Market not whitelisted");
            MarketInfo storage market = marketInfo[_market];
            if (block.number > market.lastRewardBlock) {

140:     function setRewards(
             uint256 _fromEpoch,
             uint256 _toEpoch,
             uint256 _amountPerBlock
         ) external onlyGovernance {
             require(_fromEpoch % BLOCK_EPOCH == 0 && _toEpoch % BLOCK_EPOCH == 0, "Invalid block number");
             for (uint256 i = _fromEpoch; i <= _toEpoch; i += BLOCK_EPOCH) {

177:     function setBlockTimeParameters(
             uint256 _averageBlockTime,
             uint256 _referenceBlockTime,
             uint256 _referenceBlockNumber
         ) external onlyGovernance {
             averageBlockTime = _averageBlockTime;
             referenceBlockTime = _referenceBlockTime;
             referenceBlockNumber = _referenceBlockNumber;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

96:     function setGovernance(address _governance) external onlyGovernance {
            governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-16"></a>[NC-16] NatSpec is completely non-existent on functions that should have them

Public and external functions that aren't view or pure should have NatSpec comments

*Instances (8)*:

```solidity
File: src/GaugeController.sol

303:     function add_type(string memory _name, uint256 _weight) external onlyGovernance {

316:     function change_type_weight(int128 type_id, uint256 weight) external onlyGovernance {

346:     function change_gauge_weight(address addr, uint256 weight) external onlyGovernance {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

64:     function update_market(address _market) public {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

9:     function sync_ledger(address _lender, int256 _delta) external;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

295:     function createLock(uint256 _value) external payable nonReentrant {

315:     function increaseAmount(uint256 _value) external payable nonReentrant {

353:     function withdraw() external nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-17"></a>[NC-17] Incomplete NatSpec: `@param` is missing on actually documented functions

The following functions are missing `@param` NatSpec comments.

*Instances (1)*:

```solidity
File: src/LendingLedger.sol

151:     /// @notice Used by governance to whitelist a lending market
         /// @param _market Address of the market to whitelist
         /// @param _isWhiteListed Whether the market is whitelisted or not
         function whiteListLendingMarket(
             address _market,
             bool _isWhiteListed,
             bool _hasGauge

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

### <a name="NC-18"></a>[NC-18] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor

If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (5)*:

```solidity
File: src/GaugeController.sol

63:         require(msg.sender == governance);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

47:         require(msg.sender == governance);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

71:         require(msg.sender == governance);

329:         if (delegatee == msg.sender) {

358:         require(locked_.delegatee == msg.sender, "Lock delegated");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-19"></a>[NC-19] Constant state variables defined more than once

Rather than redefining state variable constant, consider using a library to store all constants as this will prevent data redundancy

*Instances (4)*:

```solidity
File: src/GaugeController.sol

15:     uint256 public constant WEEK = 7 days;

16:     uint256 public constant MULTIPLIER = 10**18;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

31:     uint256 public constant WEEK = 7 days;

33:     uint256 public constant MULTIPLIER = 10**18;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-20"></a>[NC-20] Consider using named mappings

Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (24)*:

```solidity
File: src/GaugeController.sol

28:     mapping(int128 => string) public gauge_type_names;

31:     mapping(address => int128) public gauge_types_;

33:     mapping(address => mapping(address => VotedSlope)) public vote_user_slopes;

34:     mapping(address => uint256) public vote_user_power;

35:     mapping(address => mapping(address => uint256)) public last_user_vote;

37:     mapping(address => mapping(uint256 => Point)) public points_weight;

38:     mapping(address => mapping(uint256 => uint256)) public changes_weight;

39:     mapping(address => uint256) time_weight;

41:     mapping(int128 => mapping(uint256 => Point)) points_sum;

42:     mapping(int128 => mapping(uint256 => uint256)) changes_sum;

43:     mapping(int128 => uint256) public time_sum;

45:     mapping(uint256 => uint256) points_total;

48:     mapping(int128 => mapping(uint256 => uint256)) points_type_weight;

49:     mapping(int128 => uint256) time_type_weight;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

20:     mapping(address => bool) public lendingMarketWhitelist;

36:     mapping(address => mapping(address => UserInfo)) public userInfo; // Info of each user for the different lending markets

37:     mapping(address => MarketInfo) public marketInfo; // Info of each lending market

39:     mapping(uint256 => uint256) public cantoPerBlock; // CANTO per block for each epoch

42:     mapping(address => uint256) public lendingMarketTotalBalance; // Total balance locked within the market

44:     mapping(address => address) public liquidityGauges; // Two way mapping for markets with liquidity gauge enabled

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

38:     mapping(address => Point[1000000000]) public userPointHistory;

39:     mapping(address => uint256) public userPointEpoch;

40:     mapping(uint256 => int128) public slopeChanges;

41:     mapping(address => LockedBalance) public locked;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-21"></a>[NC-21] Adding a `return` statement when the function defines a named return variable, is redundant

*Instances (2)*:

```solidity
File: src/VotingEscrow.sol

116:     /// @notice Returns the last available user point for a user
         /// @param _addr User address
         /// @return bias i.e. y
         /// @return slope i.e. linear gradient
         /// @return ts i.e. time point was logged
         function getLastUserPoint(address _addr)
             external
             view
             returns (
                 int128 bias,
                 int128 slope,
                 uint256 ts
             )
         {
             uint256 uepoch = userPointEpoch[_addr];
             if (uepoch == 0) {
                 return (0, 0, 0);
             }
             Point memory point = userPointHistory[_addr][uepoch];
             return (point.bias, point.slope, point.ts);

116:     /// @notice Returns the last available user point for a user
         /// @param _addr User address
         /// @return bias i.e. y
         /// @return slope i.e. linear gradient
         /// @return ts i.e. time point was logged
         function getLastUserPoint(address _addr)
             external
             view
             returns (
                 int128 bias,
                 int128 slope,
                 uint256 ts
             )
         {
             uint256 uepoch = userPointEpoch[_addr];
             if (uepoch == 0) {
                 return (0, 0, 0);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-22"></a>[NC-22] `require()` / `revert()` statements should have descriptive reason strings

*Instances (3)*:

```solidity
File: src/GaugeController.sol

63:         require(msg.sender == governance);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

47:         require(msg.sender == governance);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

71:         require(msg.sender == governance);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-23"></a>[NC-23] Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`)

While this won't save gas in the recent solidity versions, this is shorter and more readable (this is especially true in calculations).

*Instances (2)*:

```solidity
File: src/GaugeController.sol

16:     uint256 public constant MULTIPLIER = 10**18;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

33:     uint256 public constant MULTIPLIER = 10**18;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-24"></a>[NC-24] Use scientific notation for readability reasons for large multiples of ten

The more a number has zeros, the harder it becomes to see with the eyes if it's the intended value. To ease auditing and bug bounty hunting, consider using the scientific notation

*Instances (1)*:

```solidity
File: src/LendingLedger.sol

12:     uint256 public constant BLOCK_EPOCH = 100_000; // 100000 blocks, roughly 1 week

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

### <a name="NC-25"></a>[NC-25] Avoid the use of sensitive terms

Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (9)*:

```solidity
File: src/LendingLedger.sol

20:     mapping(address => bool) public lendingMarketWhitelist;

65:         require(lendingMarketWhitelist[_market], "Market not whitelisted");

101:         update_market(lendingMarket); // Checks if the market is whitelisted

122:         update_market(_market); // Checks if the market is whitelisted

154:     function whiteListLendingMarket(

156:         bool _isWhiteListed,

159:         require(lendingMarketWhitelist[_market] != _isWhiteListed, "No change");

167:         lendingMarketWhitelist[_market] = _isWhiteListed;

168:         if (_isWhiteListed) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

### <a name="NC-26"></a>[NC-26] Contract does not follow the Solidity style guide's suggested layout ordering

The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (4)*:

```solidity
File: src/GaugeController.sol

1: 
   Current order:
   VariableDeclaration.WEEK
   VariableDeclaration.MULTIPLIER
   EventDefinition.NewType
   EventDefinition.NewGauge
   EventDefinition.GaugeRemoved
   VariableDeclaration.votingEscrow
   VariableDeclaration.governance
   VariableDeclaration.n_gauge_types
   VariableDeclaration.gauge_type_names
   VariableDeclaration.gauge_types_
   VariableDeclaration.vote_user_slopes
   VariableDeclaration.vote_user_power
   VariableDeclaration.last_user_vote
   VariableDeclaration.points_weight
   VariableDeclaration.changes_weight
   VariableDeclaration.time_weight
   VariableDeclaration.points_sum
   VariableDeclaration.changes_sum
   VariableDeclaration.time_sum
   VariableDeclaration.points_total
   VariableDeclaration.time_total
   VariableDeclaration.points_type_weight
   VariableDeclaration.time_type_weight
   StructDefinition.Point
   StructDefinition.VotedSlope
   ModifierDefinition.onlyGovernance
   FunctionDefinition.constructor
   FunctionDefinition.setGovernance
   FunctionDefinition.gauge_types
   FunctionDefinition._get_type_weight
   FunctionDefinition._get_sum
   FunctionDefinition._get_total
   FunctionDefinition._get_weight
   FunctionDefinition.add_gauge
   FunctionDefinition.remove_gauge
   FunctionDefinition.checkpoint
   FunctionDefinition.checkpoint_gauge
   FunctionDefinition._gauge_relative_weight
   FunctionDefinition.gauge_relative_weight
   FunctionDefinition.gauge_relative_weight_write
   FunctionDefinition._change_type_weight
   FunctionDefinition.add_type
   FunctionDefinition.change_type_weight
   FunctionDefinition._change_gauge_weight
   FunctionDefinition.change_gauge_weight
   FunctionDefinition._remove_gauge_weight
   FunctionDefinition.remove_gauge_weight
   FunctionDefinition.vote_for_gauge_weights
   FunctionDefinition.get_gauge_weight
   FunctionDefinition.get_type_weight
   FunctionDefinition.get_total_weight
   FunctionDefinition.get_weights_sum_per_type
   
   Suggested order:
   VariableDeclaration.WEEK
   VariableDeclaration.MULTIPLIER
   VariableDeclaration.votingEscrow
   VariableDeclaration.governance
   VariableDeclaration.n_gauge_types
   VariableDeclaration.gauge_type_names
   VariableDeclaration.gauge_types_
   VariableDeclaration.vote_user_slopes
   VariableDeclaration.vote_user_power
   VariableDeclaration.last_user_vote
   VariableDeclaration.points_weight
   VariableDeclaration.changes_weight
   VariableDeclaration.time_weight
   VariableDeclaration.points_sum
   VariableDeclaration.changes_sum
   VariableDeclaration.time_sum
   VariableDeclaration.points_total
   VariableDeclaration.time_total
   VariableDeclaration.points_type_weight
   VariableDeclaration.time_type_weight
   StructDefinition.Point
   StructDefinition.VotedSlope
   EventDefinition.NewType
   EventDefinition.NewGauge
   EventDefinition.GaugeRemoved
   ModifierDefinition.onlyGovernance
   FunctionDefinition.constructor
   FunctionDefinition.setGovernance
   FunctionDefinition.gauge_types
   FunctionDefinition._get_type_weight
   FunctionDefinition._get_sum
   FunctionDefinition._get_total
   FunctionDefinition._get_weight
   FunctionDefinition.add_gauge
   FunctionDefinition.remove_gauge
   FunctionDefinition.checkpoint
   FunctionDefinition.checkpoint_gauge
   FunctionDefinition._gauge_relative_weight
   FunctionDefinition.gauge_relative_weight
   FunctionDefinition.gauge_relative_weight_write
   FunctionDefinition._change_type_weight
   FunctionDefinition.add_type
   FunctionDefinition.change_type_weight
   FunctionDefinition._change_gauge_weight
   FunctionDefinition.change_gauge_weight
   FunctionDefinition._remove_gauge_weight
   FunctionDefinition.remove_gauge_weight
   FunctionDefinition.vote_for_gauge_weights
   FunctionDefinition.get_gauge_weight
   FunctionDefinition.get_type_weight
   FunctionDefinition.get_total_weight
   FunctionDefinition.get_weights_sum_per_type

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

1: 
   Current order:
   VariableDeclaration.BLOCK_EPOCH
   VariableDeclaration.averageBlockTime
   VariableDeclaration.referenceBlockNumber
   VariableDeclaration.referenceBlockTime
   VariableDeclaration.governance
   VariableDeclaration.gaugeController
   VariableDeclaration.lendingMarketWhitelist
   StructDefinition.UserInfo
   StructDefinition.MarketInfo
   VariableDeclaration.userInfo
   VariableDeclaration.marketInfo
   VariableDeclaration.cantoPerBlock
   VariableDeclaration.lendingMarketTotalBalance
   VariableDeclaration.liquidityGauges
   ModifierDefinition.onlyGovernance
   FunctionDefinition.constructor
   FunctionDefinition.setGovernance
   FunctionDefinition.update_market
   FunctionDefinition.sync_ledger
   FunctionDefinition.claim
   FunctionDefinition.setRewards
   FunctionDefinition.whiteListLendingMarket
   FunctionDefinition.setBlockTimeParameters
   FunctionDefinition.receive
   
   Suggested order:
   VariableDeclaration.BLOCK_EPOCH
   VariableDeclaration.averageBlockTime
   VariableDeclaration.referenceBlockNumber
   VariableDeclaration.referenceBlockTime
   VariableDeclaration.governance
   VariableDeclaration.gaugeController
   VariableDeclaration.lendingMarketWhitelist
   VariableDeclaration.userInfo
   VariableDeclaration.marketInfo
   VariableDeclaration.cantoPerBlock
   VariableDeclaration.lendingMarketTotalBalance
   VariableDeclaration.liquidityGauges
   StructDefinition.UserInfo
   StructDefinition.MarketInfo
   ModifierDefinition.onlyGovernance
   FunctionDefinition.constructor
   FunctionDefinition.setGovernance
   FunctionDefinition.update_market
   FunctionDefinition.sync_ledger
   FunctionDefinition.claim
   FunctionDefinition.setRewards
   FunctionDefinition.whiteListLendingMarket
   FunctionDefinition.setBlockTimeParameters
   FunctionDefinition.receive

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

1: 
   Current order:
   FunctionDefinition.sync_ledger
   UsingForDirective.IERC20
   VariableDeclaration.lendingLedger
   VariableDeclaration.underlyingToken
   FunctionDefinition.constructor
   FunctionDefinition.depositUnderlying
   FunctionDefinition.withdrawUnderlying
   FunctionDefinition._afterTokenTransfer
   
   Suggested order:
   UsingForDirective.IERC20
   VariableDeclaration.lendingLedger
   VariableDeclaration.underlyingToken
   FunctionDefinition.sync_ledger
   FunctionDefinition.constructor
   FunctionDefinition.depositUnderlying
   FunctionDefinition.withdrawUnderlying
   FunctionDefinition._afterTokenTransfer

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

1: 
   Current order:
   EventDefinition.Deposit
   EventDefinition.Withdraw
   EventDefinition.Unlock
   VariableDeclaration.name
   VariableDeclaration.symbol
   VariableDeclaration.decimals
   VariableDeclaration.governance
   VariableDeclaration.WEEK
   VariableDeclaration.LOCKTIME
   VariableDeclaration.MULTIPLIER
   VariableDeclaration.globalEpoch
   VariableDeclaration.pointHistory
   VariableDeclaration.userPointHistory
   VariableDeclaration.userPointEpoch
   VariableDeclaration.slopeChanges
   VariableDeclaration.locked
   VariableDeclaration.unlockOverride
   StructDefinition.Point
   StructDefinition.LockedBalance
   EnumDefinition.LockAction
   ModifierDefinition.onlyGovernance
   FunctionDefinition.constructor
   FunctionDefinition.setGovernance
   FunctionDefinition.toggleUnlockOverride
   FunctionDefinition.lockEnd
   FunctionDefinition.getLastUserPoint
   FunctionDefinition._checkpoint
   FunctionDefinition.checkpoint
   FunctionDefinition.createLock
   FunctionDefinition.increaseAmount
   FunctionDefinition.withdraw
   FunctionDefinition._copyLock
   FunctionDefinition._floorToWeek
   FunctionDefinition._findBlockEpoch
   FunctionDefinition._findUserBlockEpoch
   FunctionDefinition.balanceOf
   FunctionDefinition.balanceOfAt
   FunctionDefinition.totalSupply
   FunctionDefinition.totalSupplyAt
   FunctionDefinition._supplyAt
   
   Suggested order:
   VariableDeclaration.name
   VariableDeclaration.symbol
   VariableDeclaration.decimals
   VariableDeclaration.governance
   VariableDeclaration.WEEK
   VariableDeclaration.LOCKTIME
   VariableDeclaration.MULTIPLIER
   VariableDeclaration.globalEpoch
   VariableDeclaration.pointHistory
   VariableDeclaration.userPointHistory
   VariableDeclaration.userPointEpoch
   VariableDeclaration.slopeChanges
   VariableDeclaration.locked
   VariableDeclaration.unlockOverride
   EnumDefinition.LockAction
   StructDefinition.Point
   StructDefinition.LockedBalance
   EventDefinition.Deposit
   EventDefinition.Withdraw
   EventDefinition.Unlock
   ModifierDefinition.onlyGovernance
   FunctionDefinition.constructor
   FunctionDefinition.setGovernance
   FunctionDefinition.toggleUnlockOverride
   FunctionDefinition.lockEnd
   FunctionDefinition.getLastUserPoint
   FunctionDefinition._checkpoint
   FunctionDefinition.checkpoint
   FunctionDefinition.createLock
   FunctionDefinition.increaseAmount
   FunctionDefinition.withdraw
   FunctionDefinition._copyLock
   FunctionDefinition._floorToWeek
   FunctionDefinition._findBlockEpoch
   FunctionDefinition._findUserBlockEpoch
   FunctionDefinition.balanceOf
   FunctionDefinition.balanceOfAt
   FunctionDefinition.totalSupply
   FunctionDefinition.totalSupplyAt
   FunctionDefinition._supplyAt

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-27"></a>[NC-27] Use Underscores for Number Literals (add an underscore every 3 digits)

*Instances (4)*:

```solidity
File: src/LendingLedger.sol

12:     uint256 public constant BLOCK_EPOCH = 100_000; // 100000 blocks, roughly 1 week

13:     uint256 public averageBlockTime = 5700; // Average block time in milliseconds

79:                         1000;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

32:     uint256 public constant LOCKTIME = 1825 days;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-28"></a>[NC-28] Internal and private variables and functions names should begin with an underscore

According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (7)*:

```solidity
File: src/GaugeController.sol

39:     mapping(address => uint256) time_weight;

41:     mapping(int128 => mapping(uint256 => Point)) points_sum;

42:     mapping(int128 => mapping(uint256 => uint256)) changes_sum;

45:     mapping(uint256 => uint256) points_total;

46:     uint256 time_total;

48:     mapping(int128 => mapping(uint256 => uint256)) points_type_weight;

49:     mapping(int128 => uint256) time_type_weight;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

### <a name="NC-29"></a>[NC-29] Event is missing `indexed` fields

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (4)*:

```solidity
File: src/GaugeController.sol

19:     event NewType(string mame, int128 type_id);

20:     event NewGauge(address indexed gauge_address, int128 gauge_type);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

20:     event Deposit(address indexed provider, uint256 value, uint256 locktime, LockAction indexed action, uint256 ts);

21:     event Withdraw(address indexed provider, uint256 value, LockAction indexed action, uint256 ts);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-30"></a>[NC-30] `public` functions not called by the contract should be declared `external` instead

*Instances (5)*:

```solidity
File: src/GaugeController.sol

378:     function remove_gauge_weight(address _gauge) public onlyGovernance {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

440:     function balanceOf(address _owner) public view returns (uint256) {

454:     function balanceOfAt(address _owner, uint256 _blockNumber) public view returns (uint256) {

497:     function totalSupply() public view returns (uint256) {

504:     function totalSupplyAt(uint256 _blockNumber) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="NC-31"></a>[NC-31] Variables need not be initialized to zero

The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (11)*:

```solidity
File: src/GaugeController.sol

405:         uint256 old_dt = 0;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

203:         uint256 blockSlope = 0; // dblock/dt

212:         for (uint256 i = 0; i < 255; i++) {

400:         uint256 min = 0;

403:         for (uint256 i = 0; i < 128; i++) {

419:         uint256 min = 0;

421:         for (uint256 i = 0; i < 128; i++) {

472:         uint256 dBlock = 0;

473:         uint256 dTime = 0;

517:         uint256 dTime = 0;

539:         for (uint256 i = 0; i < 255; i++) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

## Low Issues

| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Some tokens may revert when zero value transfers are made | 2 |
| [L-2](#L-2) | Missing checks for `address(0)` when assigning values to address state variables | 8 |
| [L-3](#L-3) | Division by zero not prevented | 8 |
| [L-4](#L-4) | Empty `receive()/payable fallback()` function does not authenticate requests | 1 |
| [L-5](#L-5) | External call recipient may consume all transaction gas | 2 |
| [L-6](#L-6) | Signature use at deadlines should be allowed | 18 |
| [L-7](#L-7) | Prevent accidentally burning tokens | 2 |
| [L-8](#L-8) | Possible rounding issue | 3 |
| [L-9](#L-9) | Loss of precision | 15 |
| [L-10](#L-10) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 3 |
| [L-11](#L-11) | `symbol()` is not a part of the ERC-20 standard | 2 |

### <a name="L-1"></a>[L-1] Some tokens may revert when zero value transfers are made

Example: <https://github.com/d-xo/weird-erc20#revert-on-zero-value-transfers>.

In spite of the fact that EIP-20 [states](https://github.com/ethereum/EIPs/blob/46b9b698815abbfa628cd1097311deee77dd45c5/EIPS/eip-20.md?plain=1#L116) that zero-valued transfers must be accepted, some tokens, such as LEND will revert if this is attempted, which may cause transactions that involve other tokens (such as batch operations) to fully revert. Consider skipping the transfer if the amount is zero, which will also save gas.

*Instances (2)*:

```solidity
File: src/LiquidityGauge.sol

33:         IERC20(underlyingToken).safeTransferFrom(_user, address(this), _amount);

43:         IERC20(underlyingToken).safeTransfer(_user, _amount);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

### <a name="L-2"></a>[L-2] Missing checks for `address(0)` when assigning values to address state variables

*Instances (8)*:

```solidity
File: src/GaugeController.sol

71:         governance = _governance;

79:         governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

53:         governance = _governance;

61:         governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/LiquidityGauge.sol

24:         underlyingToken = _underlyingToken;

25:         lendingLedger = _lendingLedger;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

```solidity
File: src/VotingEscrow.sol

87:         governance = _governance;

97:         governance = _governance;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="L-3"></a>[L-3] Division by zero not prevented

The divisions below take an input parameter which does not have any zero-value checks, which may lead to the functions reverting when zero is passed.

*Instances (8)*:

```solidity
File: src/GaugeController.sol

256:             return (MULTIPLIER * _type_weight * gauge_weight) / total_weight;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

83:                             gaugeController.gauge_relative_weight_write(_market, epochTime)) / marketSupply

85:                     market.secRewardsPerShare += uint128((blockDelta * 1e36) / marketSupply); // Scale by 1e18, consumers need to divide by it

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

157:                 userOldPoint.slope = _oldLocked.delegated / int128(int256(LOCKTIME));

161:                 userNewPoint.slope = _newLocked.delegated / int128(int256(LOCKTIME));

205:             blockSlope = (MULTIPLIER * (block.number - lastPoint.blk)) / (block.timestamp - lastPoint.ts);

485:             blockTime = blockTime + ((dTime * (_blockNumber - point0.blk)) / dBlock);

521:                 dTime = ((_blockNumber - point.blk) * (pointNext.ts - point.ts)) / (pointNext.blk - point.blk);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="L-4"></a>[L-4] Empty `receive()/payable fallback()` function does not authenticate requests

If the intention is for the Ether to be used, the function should call another function, otherwise it should revert (e.g. require(msg.sender == address(weth))). Having no access control on the function means that someone may send Ether to the contract, and have no way to get anything back out, which is a loss of funds. If the concern is having to spend a small amount of gas to check the sender against an immutable address, the code should at least have a function to rescue unused Ether.

*Instances (1)*:

```solidity
File: src/LendingLedger.sol

187:     receive() external payable {}

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

### <a name="L-5"></a>[L-5] External call recipient may consume all transaction gas

There is no limit specified on the amount of gas used, so the recipient can use up all of the transaction's gas, causing it to revert. Use `addr.call{gas: <amount>}("")` or [this](https://github.com/nomad-xyz/ExcessivelySafeCall) library instead.

*Instances (2)*:

```solidity
File: src/LendingLedger.sol

131:             (bool success, ) = msg.sender.call{value: uint256(cantoToSend)}("");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

373:         (bool success, ) = msg.sender.call{value: amountToSend}("");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="L-6"></a>[L-6] Signature use at deadlines should be allowed

According to [EIP-2612](https://github.com/ethereum/EIPs/blob/71dc97318013bf2ac572ab63fab530ac9ef419ca/EIPS/eip-2612.md?plain=1#L58), signatures used on exactly the deadline timestamp are supposed to be allowed. While the signature may or may not be used for the exact EIP-2612 use case (transfer approvals), for consistency's sake, all deadlines should follow this semantic. If the timestamp is an expiration rather than a deadline, consider whether it makes more sense to include the expiration timestamp as a valid timestamp, as is done for deadlines.

*Instances (18)*:

```solidity
File: src/GaugeController.sol

101:                 if (t > block.timestamp) break;

104:                 if (t > block.timestamp) time_type_weight[gauge_type] = t;

119:                 if (t > block.timestamp) break;

131:                 if (t > block.timestamp) time_sum[gauge_type] = t;

145:         if (t > block.timestamp) {

157:             if (t > block.timestamp) break;

167:             if (t > block.timestamp) {

183:                 if (t > block.timestamp) break;

195:                 if (t > block.timestamp) time_weight[_gauge_addr] = t;

443:         if (old_slope.end > block.timestamp) {

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/VotingEscrow.sol

156:             if (_oldLocked.end > block.timestamp && _oldLocked.delegated > 0) {

160:             if (_newLocked.end > block.timestamp && _newLocked.delegated > 0) {

217:             if (iterativeTime > block.timestamp) {

270:             if (_oldLocked.end > block.timestamp) {

278:             if (_newLocked.end > block.timestamp) {

321:         require(locked_.end > block.timestamp, "Lock expired");

342:             require(locked_.end > block.timestamp, "Delegatee lock expired");

357:         require(locked_.end <= block.timestamp || unlockOverride, "Lock not expired");

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="L-7"></a>[L-7] Prevent accidentally burning tokens

Minting and burning tokens to address(0) prevention

*Instances (2)*:

```solidity
File: src/LiquidityGauge.sol

34:         _mint(_user, _amount);

42:         _burn(_user, _amount);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

### <a name="L-8"></a>[L-8] Possible rounding issue

Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator. Also, there is indication of multiplication and division without the use of parenthesis which could result in issues.

*Instances (3)*:

```solidity
File: src/GaugeController.sol

256:             return (MULTIPLIER * _type_weight * gauge_weight) / total_weight;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

83:                             gaugeController.gauge_relative_weight_write(_market, epochTime)) / marketSupply

85:                     market.secRewardsPerShare += uint128((blockDelta * 1e36) / marketSupply); // Scale by 1e18, consumers need to divide by it

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

### <a name="L-9"></a>[L-9] Loss of precision

Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator

*Instances (15)*:

```solidity
File: src/GaugeController.sol

72:         uint256 last_epoch = (block.timestamp / WEEK) * WEEK;

211:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

250:         uint256 t = (_time / WEEK) * WEEK;

256:             return (MULTIPLIER * _type_weight * gauge_weight) / total_weight;

291:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

329:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

352:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

398:         uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

72:                     uint256 epoch = (i / BLOCK_EPOCH) * BLOCK_EPOCH; // Rewards and voting weights are aligned on a weekly basis

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

157:                 userOldPoint.slope = _oldLocked.delegated / int128(int256(LOCKTIME));

161:                 userNewPoint.slope = _newLocked.delegated / int128(int256(LOCKTIME));

205:             blockSlope = (MULTIPLIER * (block.number - lastPoint.blk)) / (block.timestamp - lastPoint.ts);

235:             lastPoint.blk = initialLastPoint.blk + (blockSlope * (iterativeTime - initialLastPoint.ts)) / MULTIPLIER;

392:         return (_t / WEEK) * WEEK;

524:             dTime = ((_blockNumber - point.blk) * (block.timestamp - point.ts)) / (block.number - point.blk);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="L-10"></a>[L-10] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`

The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (3)*:

```solidity
File: src/GaugeController.sol

2: pragma solidity ^0.8.16;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/GaugeController.sol)

```solidity
File: src/LendingLedger.sol

2: pragma solidity ^0.8.16;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

2: pragma solidity ^0.8.16;

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)

### <a name="L-11"></a>[L-11] `symbol()` is not a part of the ERC-20 standard

The `symbol()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (2)*:

```solidity
File: src/LiquidityGauge.sol

20:             string.concat(ERC20(_underlyingToken).symbol(), " NeoFinance Gauge"),

21:             string.concat(ERC20(_underlyingToken).symbol(), "-gauge")

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

## Medium Issues

| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Contracts are vulnerable to fee-on-transfer accounting-related issues | 1 |
| [M-2](#M-2) | `block.number` means different things on different L2s | 17 |

### <a name="M-1"></a>[M-1] Contracts are vulnerable to fee-on-transfer accounting-related issues

Consistently check account balance before and after transfers for Fee-On-Transfer discrepancies. As arbitrary ERC20 tokens can be used, the amount here should be calculated every time to take into consideration a possible fee-on-transfer or deflation.
Also, it's a good practice for the future of the solution.

Use the balance before and after the transfer to calculate the received amount instead of assuming that it would be equal to the amount passed as a parameter. Or explicitly document that such tokens shouldn't be used and won't be supported

*Instances (1)*:

```solidity
File: src/LiquidityGauge.sol

33:         IERC20(underlyingToken).safeTransferFrom(_user, address(this), _amount);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LiquidityGauge.sol)

### <a name="M-2"></a>[M-2] `block.number` means different things on different L2s

On Optimism, `block.number` is the L2 block number, but on Arbitrum, it's the L1 block number, and `ArbSys(address(100)).arbBlockNumber()` must be used. Furthermore, L2 block numbers often occur much more frequently than L1 block numbers (any may even occur on a per-transaction basis), so using block numbers for timing results in inconsistencies, especially when voting is involved across multiple chains. As of version 4.9, OpenZeppelin has [modified](https://blog.openzeppelin.com/introducing-openzeppelin-contracts-v4.9#governor) their governor code to use a clock rather than block numbers, to avoid these sorts of issues, but this still requires that the project [implement](https://docs.openzeppelin.com/contracts/4.x/governance#token_2) a [clock](https://eips.ethereum.org/EIPS/eip-6372) for each L2.

*Instances (17)*:

```solidity
File: src/LendingLedger.sol

54:         referenceBlockNumber = block.number;

67:         if (block.number > market.lastRewardBlock) {

71:                 while (i < block.number) {

74:                     uint256 blockDelta = Math.min(nextEpoch, block.number) - i;

78:                         ((block.number - referenceBlockNumber) * averageBlockTime) /

89:             market.lastRewardBlock = uint64(block.number);

169:             marketInfo[_market].lastRewardBlock = uint64(block.number);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/LendingLedger.sol)

```solidity
File: src/VotingEscrow.sol

84:         pointHistory[0] = Point({bias: int128(0), slope: int128(0), ts: block.timestamp, blk: block.number});

175:             userNewPoint.blk = block.number;

193:         Point memory lastPoint = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number});

205:             blockSlope = (MULTIPLIER * (block.number - lastPoint.blk)) / (block.timestamp - lastPoint.ts);

240:                 lastPoint.blk = block.number;

455:         require(_blockNumber <= block.number, "Only past block number");

479:             dBlock = block.number - point0.blk;

505:         require(_blockNumber <= block.number, "Only past block number");

523:         } else if (point.blk != block.number) {

524:             dTime = ((_blockNumber - point.blk) * (block.timestamp - point.ts)) / (block.number - point.blk);

```

[Link to code](https://github.com/code-423n4/2024-03-neobase/blob/main/src/VotingEscrow.sol)
