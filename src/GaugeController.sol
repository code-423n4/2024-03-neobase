// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.16;

import {VotingEscrow} from "./VotingEscrow.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

/// @title  GaugeController
/// @author Curve Finance (MIT) - original concept and implementation in Vyper
///         mkt.market - Porting to Solidity with some modifications (this version)
/// @notice Allows users to vote on distribution of CANTO that the contract receives from governance. Modifications from Curve:
///         - Different whitelisting of gauge addresses
///         - Removal of gauges
contract GaugeController {
    // Constants
    uint256 public constant WEEK = 7 days;
    uint256 public constant MULTIPLIER = 10**18;

    // Events
    event NewType(string mame, int128 type_id);
    event NewGauge(address indexed gauge_address, int128 gauge_type);
    event GaugeRemoved(address indexed gauge_address);

    // State
    VotingEscrow public votingEscrow;
    address public governance;

    int128 public n_gauge_types;
    mapping(int128 => string) public gauge_type_names;
    // we increment values by 1 prior to storing them here so we can rely on a value
    // of zero as meaning the gauge has not been set
    mapping(address => int128) public gauge_types_;

    mapping(address => mapping(address => VotedSlope)) public vote_user_slopes;
    mapping(address => uint256) public vote_user_power;
    mapping(address => mapping(address => uint256)) public last_user_vote;

    mapping(address => mapping(uint256 => Point)) public points_weight;
    mapping(address => mapping(uint256 => uint256)) public changes_weight;
    mapping(address => uint256) time_weight;

    mapping(int128 => mapping(uint256 => Point)) points_sum;
    mapping(int128 => mapping(uint256 => uint256)) changes_sum;
    mapping(int128 => uint256) public time_sum;

    mapping(uint256 => uint256) points_total;
    uint256 time_total;

    mapping(int128 => mapping(uint256 => uint256)) points_type_weight;
    mapping(int128 => uint256) time_type_weight;

    struct Point {
        uint256 bias;
        uint256 slope;
    }

    struct VotedSlope {
        uint256 slope;
        uint256 power;
        uint256 end;
    }

    modifier onlyGovernance() {
        require(msg.sender == governance);
        _;
    }

    /// @notice Initializes state
    /// @param _votingEscrow The voting escrow address
    constructor(address _votingEscrow, address _governance) {
        votingEscrow = VotingEscrow(_votingEscrow);
        governance = _governance;
        uint256 last_epoch = (block.timestamp / WEEK) * WEEK;
        time_total = last_epoch;
    }

    /// @notice Set governance address
    /// @param _governance New governance address
    function setGovernance(address _governance) external onlyGovernance {
        governance = _governance;
    }

    // @notice Get gauge type for address
    // @param _addr Gauge address
    // @return Gauge type id
    function gauge_types(address _addr) external view returns (int128) {
        int128 gauge_type = gauge_types_[_addr];
        require(gauge_type != 0, "Invalid gauge address");

        return gauge_type - 1;
    }

    /// @notice Fill historic type weights week-over-week for missed checkins
    /// and return the type weight for the future week
    /// @param gauge_type Gauge type id
    /// @return Type weight
    function _get_type_weight(int128 gauge_type) internal returns (uint256) {
        uint256 t = time_type_weight[gauge_type];
        if (t > 0) {
            uint256 w = points_type_weight[gauge_type][t];
            for (uint256 i; i < 500; ++i) {
                if (t > block.timestamp) break;
                t += WEEK;
                points_type_weight[gauge_type][t] = w;
                if (t > block.timestamp) time_type_weight[gauge_type] = t;
            }
            return w;
        } else {
            return 0;
        }
    }

    /// @notice Fill historic gauge weights week-over-week for missed checkins and return the sum for the future week
    /// @return Sum of weights
    function _get_sum(int128 gauge_type) internal returns (uint256) {
        uint256 t = time_sum[gauge_type];
        if (t > 0) {
            Point memory pt = points_sum[gauge_type][t];
            for (uint256 i; i < 500; ++i) {
                if (t > block.timestamp) break;
                t += WEEK;
                uint256 d_bias = pt.slope * WEEK;
                if (pt.bias > d_bias) {
                    pt.bias -= d_bias;
                    uint256 d_slope = changes_sum[gauge_type][t];
                    pt.slope -= d_slope;
                } else {
                    pt.bias = 0;
                    pt.slope = 0;
                }
                points_sum[gauge_type][t] = pt;
                if (t > block.timestamp) time_sum[gauge_type] = t;
            }
            return pt.bias;
        } else {
            return 0;
        }
    }

    // @notice Fill historic total weights week-over-week for missed checkins
    // and return the total for the future week
    // @return Total weight
    function _get_total() internal returns (uint256) {
        uint256 t = time_total;
        int128 _n_gauge_types = n_gauge_types;
        if (t > block.timestamp) {
            // If we have already checkpointed - still need to change the value
            t -= WEEK;
        }
        uint256 pt = points_total[t];

        for (int128 gauge_type; gauge_type < _n_gauge_types; ++gauge_type) {
            _get_sum(gauge_type);
            _get_type_weight(gauge_type);
        }

        for (uint256 i; i < 500; ++i) {
            if (t > block.timestamp) break;
            t += WEEK;
            pt = 0;
            for (int128 gauge_type; gauge_type < _n_gauge_types; ++gauge_type) {
                uint256 type_sum = points_sum[gauge_type][t].bias;
                uint256 type_weight = points_type_weight[gauge_type][t];
                pt += type_sum * type_weight;
            }
            points_total[t] = pt;

            if (t > block.timestamp) {
                time_total = t;
            }
        }
        return pt;
    }

    /// @notice Fill historic gauge weights week-over-week for missed checkins
    /// and return the total for the future week
    /// @param _gauge_addr Address of the gauge
    /// @return Gauge weight
    function _get_weight(address _gauge_addr) private returns (uint256) {
        uint256 t = time_weight[_gauge_addr];
        if (t > 0) {
            Point memory pt = points_weight[_gauge_addr][t];
            for (uint256 i; i < 500; ++i) {
                if (t > block.timestamp) break;
                t += WEEK;
                uint256 d_bias = pt.slope * WEEK;
                if (pt.bias > d_bias) {
                    pt.bias -= d_bias;
                    uint256 d_slope = changes_weight[_gauge_addr][t];
                    pt.slope -= d_slope;
                } else {
                    pt.bias = 0;
                    pt.slope = 0;
                }
                points_weight[_gauge_addr][t] = pt;
                if (t > block.timestamp) time_weight[_gauge_addr] = t;
            }
            return pt.bias;
        } else {
            return 0;
        }
    }

    /// @notice Add a new gauge, only callable by governance
    /// @param addr The gauge address
    /// @param gauge_type The gauge type
    function add_gauge(address addr, int128 gauge_type) external onlyGovernance {
        require(gauge_type >= 0 && gauge_type < n_gauge_types, "Invalid gauge type");
        require(gauge_types_[addr] == 0, "Gauge already exists");

        gauge_types_[addr] = gauge_type + 1;
        uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

        _change_gauge_weight(addr, 0);

        if (time_sum[gauge_type] == 0) time_sum[gauge_type] = next_time;
        time_weight[addr] = next_time;

        emit NewGauge(addr, gauge_type);
    }

    /// @notice Remove a gauge, only callable by governance
    /// @dev Sets the gauge weight to 0
    /// @param _gauge The gauge address
    function remove_gauge(address _gauge) external onlyGovernance {
        require(gauge_types_[_gauge] != 0, "Invalid gauge address");
        gauge_types_[_gauge] = 0;
        _remove_gauge_weight(_gauge);
        emit GaugeRemoved(_gauge);
    }

    /// @notice Checkpoint to fill data common for all gauges
    function checkpoint() external {
        _get_total();
    }

    /// @notice Checkpoint to fill data for both a specific gauge and common for all gauges
    /// @param _gauge The gauge address
    function checkpoint_gauge(address _gauge) external {
        _get_weight(_gauge);
        _get_total();
    }

    /// @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
    ///     (e.g. 1.0 == 1e18). Inflation which will be received by it is
    ///     inflation_rate * relative_weight / 1e18
    /// @param _gauge Gauge address
    /// @param _time Relative weight at the specified timestamp in the past or present
    /// @return Value of relative weight normalized to 1e18
    function _gauge_relative_weight(address _gauge, uint256 _time) private view returns (uint256) {
        uint256 t = (_time / WEEK) * WEEK;
        uint256 total_weight = points_total[t];
        if (total_weight > 0) {
            int128 gauge_type = gauge_types_[_gauge] - 1;
            uint256 _type_weight = points_type_weight[gauge_type][t];
            uint256 gauge_weight = points_weight[_gauge][t].bias;
            return (MULTIPLIER * _type_weight * gauge_weight) / total_weight;
        } else {
            return 0;
        }
    }

    /// @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
    ///     (e.g. 1.0 == 1e18). Inflation which will be received by it is
    ///     inflation_rate * relative_weight / 1e18
    /// @param _gauge Gauge address
    /// @param _time Relative weight at the specified timestamp in the past or present
    /// @return Value of relative weight normalized to 1e18
    function gauge_relative_weight(address _gauge, uint256 _time) external view returns (uint256) {
        return _gauge_relative_weight(_gauge, _time);
    }

    /// @notice Get gauge weight normalized to 1e18 and also fill all the unfilled
    ///     values for type and gauge records
    /// @dev Any address can call, however nothing is recorded if the values are filled already
    /// @param _gauge Gauge address
    /// @param _time Relative weight at the specified timestamp in the past or present
    /// @return Value of relative weight normalized to 1e18
    function gauge_relative_weight_write(address _gauge, uint256 _time) external returns (uint256) {
        _get_weight(_gauge);
        _get_total();
        return _gauge_relative_weight(_gauge, _time);
    }

    // @notice Change type weight
    // @param type_id Type id
    // @param weight New type weight
    function _change_type_weight(int128 type_id, uint256 weight) internal {
        uint256 old_weight = _get_type_weight(type_id);
        uint256 old_sum = _get_sum(type_id);
        uint256 _total_weight = _get_total();
        uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

        _total_weight = _total_weight + old_sum * weight - old_sum * old_weight;
        points_total[next_time] = _total_weight;
        points_type_weight[type_id][next_time] = weight;
        time_total = next_time;
        time_type_weight[type_id] = next_time;
    }

    // @notice Add gauge type with name `_name` and weight `weight`
    // @param _name Name of gauge type
    // @param weight Weight of gauge type
    function add_type(string memory _name, uint256 _weight) external onlyGovernance {
        int128 type_id = n_gauge_types;
        gauge_type_names[type_id] = _name;
        n_gauge_types = type_id + 1;
        if (_weight != 0) {
            _change_type_weight(type_id, _weight);
        }
        emit NewType(_name, type_id);
    }

    // @notice Change gauge type `type_id` weight to `weight`
    // @param type_id Gauge type id
    // @param weight New Gauge weight
    function change_type_weight(int128 type_id, uint256 weight) external onlyGovernance {
        _change_type_weight(type_id, weight);
    }

    /// @notice Overwrite gauge weight
    /// @param addr Gauge address
    /// @param weight New weight
    function _change_gauge_weight(address addr, uint256 weight) internal {
        int128 gauge_type = gauge_types_[addr] - 1;
        uint256 old_gauge_weight = _get_weight(addr);
        uint256 type_weight = _get_type_weight(gauge_type);
        uint256 old_sum = _get_sum(gauge_type);
        uint256 _total_weight = _get_total();
        uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

        points_weight[addr][next_time].bias = weight;
        time_weight[addr] = next_time;

        uint256 new_sum = old_sum + weight - old_gauge_weight;
        points_sum[gauge_type][next_time].bias = new_sum;
        time_sum[gauge_type] = next_time;

        _total_weight = _total_weight + new_sum * type_weight - old_sum * type_weight;
        points_total[next_time] = _total_weight;
        time_total = next_time;
    }

    // @notice Change weight of gauge `addr` to `weight`
    // @param addr `GaugeController` contract address
    // @param weight New Gauge weight
    function change_gauge_weight(address addr, uint256 weight) external onlyGovernance {
        _change_gauge_weight(addr, weight);
    }

    function _remove_gauge_weight(address _gauge) internal {
        int128 gauge_type = gauge_types_[_gauge] - 1;
        uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;

        uint256 old_weight_bias = _get_weight(_gauge);
        uint256 old_weight_slope = points_weight[_gauge][next_time].slope;
        uint256 old_sum_bias = _get_sum(gauge_type);

        points_weight[_gauge][next_time].bias = 0;
        points_weight[_gauge][next_time].slope = 0;

        uint256 new_sum = old_sum_bias - old_weight_bias;
        points_sum[gauge_type][next_time].bias = new_sum;
        points_sum[gauge_type][next_time].slope -= old_weight_slope;
        // We have to cancel all slope changes (gauge specific and global) that were caused by this gauge
        // This is not very efficient, but does the job for a governance function that is called very rarely
        for (uint256 i; i < 263; ++i) {
            uint256 time_to_check = next_time + i * WEEK;
            uint256 gauge_weight_change = changes_weight[_gauge][time_to_check];
            if (gauge_weight_change > 0) {
                changes_weight[_gauge][time_to_check] = 0;
                changes_sum[gauge_type][time_to_check] -= gauge_weight_change;
            }
        }
    }

    /// @notice Allows governance to remove gauge weights
    /// @param _gauge Gauge address
    function remove_gauge_weight(address _gauge) public onlyGovernance {
        _remove_gauge_weight(_gauge);
    }

    /// @notice Allocate voting power for changing pool weights
    /// @param _gauge_addr Gauge which `msg.sender` votes for
    /// @param _user_weight Weight for a gauge in bps (units of 0.01%). Minimal is 0.01%. Ignored if 0
    function vote_for_gauge_weights(address _gauge_addr, uint256 _user_weight) external {
        require(_user_weight >= 0 && _user_weight <= 10_000, "Invalid user weight");
        require(_user_weight == 0 || gauge_types_[_gauge_addr] != 0, "Can only vote 0 on non-gauges"); // We allow withdrawing voting power from invalid (removed) gauges
        VotingEscrow ve = votingEscrow;
        (
            ,
            /*int128 bias*/
            int128 slope_, /*uint256 ts*/

        ) = ve.getLastUserPoint(msg.sender);
        require(slope_ >= 0, "Invalid slope");
        uint256 slope = uint256(uint128(slope_));
        uint256 lock_end = ve.lockEnd(msg.sender);
        uint256 next_time = ((block.timestamp + WEEK) / WEEK) * WEEK;
        require(lock_end > next_time, "Lock expires too soon");

        int128 gauge_type = gauge_types_[_gauge_addr] - 1;
        require(gauge_type >= 0, "Gauge not added");

        VotedSlope memory old_slope = vote_user_slopes[msg.sender][_gauge_addr];
        uint256 old_dt = 0;
        if (old_slope.end > next_time) old_dt = old_slope.end - next_time;
        uint256 old_bias = old_slope.slope * old_dt;
        VotedSlope memory new_slope = VotedSlope({
            slope: (slope * _user_weight) / 10_000,
            end: lock_end,
            power: _user_weight
        });
        uint256 new_dt = lock_end - next_time;
        uint256 new_bias = new_slope.slope * new_dt;

        // Check and update powers (weights) used
        uint256 power_used = vote_user_power[msg.sender];
        power_used = power_used + new_slope.power - old_slope.power;
        require(power_used >= 0 && power_used <= 10_000, "Used too much power");
        vote_user_power[msg.sender] = power_used;

        // Remove old and schedule new slope changes
        // Remove slope changes for old slopes
        // Schedule recording of initial slope for next_time
        uint256 old_weight_bias = _get_weight(_gauge_addr);
        uint256 old_weight_slope = points_weight[_gauge_addr][next_time].slope;
        uint256 old_sum_bias = _get_sum(gauge_type);
        uint256 old_sum_slope = points_sum[gauge_type][next_time].slope;

        points_weight[_gauge_addr][next_time].bias = Math.max(old_weight_bias + new_bias, old_bias) - old_bias;
        points_sum[gauge_type][next_time].bias = Math.max(old_sum_bias + new_bias, old_bias) - old_bias;
        if (old_slope.end > next_time) {
            points_weight[_gauge_addr][next_time].slope =
                Math.max(old_weight_slope + new_slope.slope, old_slope.slope) -
                old_slope.slope;
            points_sum[gauge_type][next_time].slope =
                Math.max(old_sum_slope + new_slope.slope, old_slope.slope) -
                old_slope.slope;
        } else {
            points_weight[_gauge_addr][next_time].slope += new_slope.slope;
            points_sum[gauge_type][next_time].slope += new_slope.slope;
        }
        if (old_slope.end > block.timestamp) {
            // Cancel old slope changes if they still didn't happen
            // Because of manual slope changes when gauge is removed, an underflow is possible here and we have to check for that.
            if (changes_weight[_gauge_addr][old_slope.end] >= old_slope.slope) {
                changes_weight[_gauge_addr][old_slope.end] -= old_slope.slope;
            } else {
                changes_weight[_gauge_addr][old_slope.end] = 0;
            }
            if (changes_sum[gauge_type][old_slope.end] >= old_slope.slope) {
                changes_sum[gauge_type][old_slope.end] -= old_slope.slope;
            } else {
                changes_sum[gauge_type][old_slope.end] = 0;
            }
        }
        // Add slope changes for new slopes
        changes_weight[_gauge_addr][new_slope.end] += new_slope.slope;
        changes_sum[gauge_type][new_slope.end] += new_slope.slope;

        _get_total();

        vote_user_slopes[msg.sender][_gauge_addr] = new_slope;

        // Record last action time
        last_user_vote[msg.sender][_gauge_addr] = block.timestamp;
    }

    /// @notice Get current gauge weight
    /// @param _gauge Gauge address
    /// @return Gauge weight
    function get_gauge_weight(address _gauge) external view returns (uint256) {
        return points_weight[_gauge][time_weight[_gauge]].bias;
    }

    // @notice Get current type weight
    // @param type_id Type id
    // @return Type weight
    function get_type_weight(int128 type_id) external view returns (uint256) {
        return points_type_weight[type_id][time_type_weight[type_id]];
    }

    /// @notice Get total weight
    /// @return Total weight
    function get_total_weight() external view returns (uint256) {
        return points_total[time_total];
    }

    // @notice Get sum of gauge weights per type
    // @param type_id Type id
    // @return Sum of gauge weights
    function get_weights_sum_per_type(int128 type_id) external view returns (uint256) {
        return points_sum[type_id][time_sum[type_id]].bias;
    }
}
