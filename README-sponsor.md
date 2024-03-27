# NeoFinance Coordinator

The contracts implement a voting-escrow incentivization model for Canto RWA (Real World Assets) similar to [veCRV](https://curve.readthedocs.io/dao-vecrv.html) with its [liquidity gauge](https://curve.readthedocs.io/dao-gauges.html). Users can lock up CANTO (for five years) in the `VotingEscrow` contract to get veCANTO. They can then vote within `GaugeController` for different lending markets that are white-listed by governance. Users that provide liquidity within these lending markets can claim CANTO (that is provided by CANTO governance) from `LendingLedger` according to their share.

For instance, there might be lending markets X, Y, and Z where Alice, Bob, and Charlie provide liquidity. In lending market X, Alice provides 60% of the liquidity, Bob 30%, and Charlie 10% at a particular epoch (point in time). At this epoch, lending market X receives 40% of all votes. Therefore, the allocations are:
- Alice: 40% * 60% = 24% of all CANTO that is allocated for this epoch.
- Bob: 40% * 30% = 12% of all CANTO that is allocated for this epoch.
- Charlie: 40% * 10% = 4% of all CANTO that is allocated for this epoch.


## `VotingEscrow`
The used `VotingEscrow` implementation is a fork of the FIAT DAO implementation, which is itself a fork / solidity port of Curve's original implementation. A few modifications were made to the FIAT DAO implementation, for instance support for underlying native tokens instead of ERC20 and a fixed lock time (of 5 years) that is reset with every action.

## `GaugeController`
The `GaugeController` contract is a Solidity port of Curve's [`GaugeController.vy`](https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/GaugeController.vy). Gauge types were removed (there is only one type for Neofinance Coordinator), resulting in a few other code changes. Moreover, the whitelisting of gauges (lending markets) is performed differently than in the original gauge implementation.

The controller allows users to vote for gauge weights, i.e. how much of one epoch's CANTO is allocated to one gauge. The controller then enables to query the relative weights for all the gauges at any time in the past.

## `LendingLedger`
The lending ledger keeps track of how much liquidity a user has provided in a market at any time in the past. To do so, the (white-listed) markets need to call `sync_ledger` on every deposit / withdrawal by a user. Canto governance calls `setRewards` and sends CANTO to the contract to control how much CANTO is allocated for one epoch.

Users can then claim the CANTO according to their balance in the market and the weight of this market in the `GaugeController`.

### Epochs
We discretize time into one-week epochs and perform all calculations per epoch (week). Claiming is only possible after an epoch has ended.