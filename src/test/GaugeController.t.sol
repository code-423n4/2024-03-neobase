// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {VotingEscrow} from "../VotingEscrow.sol";
import {GaugeController} from "../GaugeController.sol";
import {Test} from "forge-std/Test.sol";

contract GaugeControllerTest is Test {
    Utilities internal utils;
    address payable[] internal users;
    address internal gov;
    address internal user1;
    address internal user2;
    address internal gauge1;
    address internal gauge2;
    address internal gauge3;

    VotingEscrow internal ve;
    GaugeController internal gc;

    uint256 constant WEEK = 7 days;
    uint256 MONTH = 4 weeks;

    uint256[] TYPE_WEIGHTS = [1, 3];
    string[] TYPE_NAMES = ["type0", "type1"];

    function setUp() public {
        utils = new Utilities();
        users = utils.createUsers(6);
        (gov, user1, user2, gauge1, gauge2, gauge3) = (users[0], users[1], users[2], users[3], users[4], users[5]);

        ve = new VotingEscrow("VotingEscrow", "VE", address(gov));
        gc = new GaugeController(address(ve), address(gov));

        vm.prank(gov);
        gc.add_type(TYPE_NAMES[0], TYPE_WEIGHTS[0]);
    }

    function testAddType() public {
        vm.prank(gov);
        gc.add_type(TYPE_NAMES[1], TYPE_WEIGHTS[1]);

        assertEq(gc.get_type_weight(0), TYPE_WEIGHTS[0]);
        assertEq(gc.get_type_weight(1), TYPE_WEIGHTS[1]);
    }

    function testChangeTypeWeight() public {
        vm.prank(gov);
        gc.change_type_weight(0, TYPE_WEIGHTS[0] + 1);

        assertEq(gc.get_type_weight(0), TYPE_WEIGHTS[0] + 1);
    }

    function testAddGauge() public {
        vm.expectRevert("Invalid gauge address");
        gc.gauge_types(user1);

        vm.prank(gov);
        gc.add_gauge(user1, 0);

        assertTrue(gc.gauge_types(user1) == 0);
    }

    function testAddGaugeInvalidType() public {
        vm.prank(gov);

        vm.expectRevert("Invalid gauge type");
        gc.add_gauge(user1, 1);
    }

    function testAddGaugeExistingGauge() public {
        vm.startPrank(gov);
        gc.add_gauge(user1, 0);

        // Add gauge for existing gauge
        vm.expectRevert("Gauge already exists");
        gc.add_gauge(user1, 0);
        vm.stopPrank();
    }

    function testRemoveGauge() public {
        vm.startPrank(gov);

        gc.add_gauge(user1, 0);
        assertTrue(gc.gauge_types(user1) == 0);

        gc.remove_gauge(user1);
        vm.expectRevert("Invalid gauge address");
        gc.gauge_types(user1);
        assertTrue(gc.get_gauge_weight(user1) == 0);

        vm.stopPrank();
    }

    function testRemoveGaugeForNonExistingGauge() public {
        vm.expectRevert("Invalid gauge address");
        gc.gauge_types(user1);
        vm.prank(gov);
        vm.expectRevert("Invalid gauge address");
        gc.remove_gauge(user1);
    }

    function testRemoveGaugeWeight() public {
        vm.prank(gov);
        gc.add_gauge(user1, 0);
        assertTrue(gc.get_gauge_weight(user1) == 0);

        // Only callable by governance
        vm.prank(user1);
        vm.expectRevert();
        gc.remove_gauge_weight(user1);

        vm.prank(gov);
        gc.remove_gauge_weight(user1);
        // should overwrite the gauge weight
        assertEq(gc.get_gauge_weight(user1), 0);
    }

    function testVoteWithNonWhitelistedGauge() public {
        vm.prank(user2);
        vm.expectRevert("Can only vote 0 on non-gauges");
        gc.vote_for_gauge_weights(user2, 100);
    }

    function testVoteWithInvalidWeight() public {
        vm.prank(user2);
        // invalid weight of 999999
        vm.expectRevert("Invalid user weight");
        gc.vote_for_gauge_weights(user2, 999999);
    }

    function testMultiVoteWithInvalidWeight() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);

        ve.createLock{value: 1 ether}(1 ether);
        gc.vote_for_gauge_weights(gauge1, 5000);
        vm.expectRevert("Used too much power");
        gc.vote_for_gauge_weights(gauge2, 5001);
    }

    function testVoteLockExpiresTooSoon() public {
        vm.prank(gov);
        gc.add_gauge(user1, 0);

        vm.startPrank(user1);
        vm.expectRevert("Lock expires too soon");
        gc.vote_for_gauge_weights(user1, 100);
    }

    function testVoteSuccessfully() public {
        // prepare
        vm.deal(user1, 100 ether);
        vm.startPrank(gov);
        gc.add_gauge(user1, 0);
        vm.stopPrank();

        uint256 v = 10 ether;

        vm.startPrank(user1);
        ve.createLock{value: v}(v);
        gc.vote_for_gauge_weights(user1, 100);
        assertTrue(gc.get_gauge_weight(user1) > 100);
    }

    function testVote10Percent() public {
        // prepare
        uint256 v = 10 ether;
        vm.deal(gov, v);
        vm.startPrank(gov);
        ve.createLock{value: v}(v);
        gc.add_gauge(user1, 0);
        gc.add_gauge(user2, 0);
        // user1 vote 10%
        gc.vote_for_gauge_weights(user1, 100);
        gc.vote_for_gauge_weights(user2, 900);

        // check
        assertApproxEqRel(gc.get_gauge_weight(user1) * 10, gc.get_total_weight(), 0.00001e18);
        assertApproxEqRel(gc.get_gauge_weight(user1) * 10, gc.get_total_weight(), 0.00001e18);

        vm.stopPrank();
    }

    function testVoteGaugeWeight50Pcnt() public {
        // vote_for_gauge_weights valid vote 50%
        // Should vote for gauge and change weights accordingly
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);
        vm.stopPrank();

        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);
        gc.vote_for_gauge_weights(gauge1, 5000); // vote 50% for gauge1
        gc.vote_for_gauge_weights(gauge2, 5000); // vote 50% for gauge2

        assertEq((gc.get_total_weight() * 5000) / 10000, gc.get_gauge_weight(gauge1));
    }

    function testVoteGaugeWeightChangeVote() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);
        vm.stopPrank();

        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);
        uint256 nextEpoch = ((block.timestamp + WEEK) / WEEK) * WEEK;
        gc.vote_for_gauge_weights(gauge1, 10000); // vote 100% for gauge1
        vm.warp(nextEpoch - 1);
        gc.vote_for_gauge_weights(gauge1, 0); // remove vote for gauge1
        gc.vote_for_gauge_weights(gauge2, 10000); // vote 100% for gauge2
        console.logUint(gc.gauge_relative_weight_write(gauge1, nextEpoch));
        console.logUint(gc.gauge_relative_weight_write(gauge2, nextEpoch));
    }

    function testVoteDifferentTime() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);
        vm.stopPrank();

        vm.deal(user1, 1010 ether);
        vm.deal(user2, 1010 ether);

        uint256 lockStart = block.timestamp;
        vm.prank(user1);
        ve.createLock{value: 1000 ether}(1000 ether);
        vm.prank(user2);
        ve.createLock{value: 1000 ether}(1000 ether);

        // [(uint, uint), ...]
        uint256[4] memory weights = [uint256(8000), 2000, 9000, 1000]; // explicit casting

        vm.startPrank(user1);
        gc.vote_for_gauge_weights(gauge1, weights[0]);
        gc.vote_for_gauge_weights(gauge2, weights[1]);
        assertEq(gc.vote_user_power(user1), 10000);
        vm.stopPrank();

        for (uint256 i; i < 10; i++) {
            checkpoint();
            uint256 _rel_weigth_1 = gc.gauge_relative_weight(gauge1, block.timestamp);
            uint256 _rel_weigth_2 = gc.gauge_relative_weight(gauge2, block.timestamp);
            assertApproxEqRel(_rel_weigth_1, (weights[0] * 1e18) / 1e3, 1e18);
            assertApproxEqRel(_rel_weigth_2, (weights[1] * 1e18) / 1e3, 1e18);
        }

        vm.startPrank(user2);
        gc.vote_for_gauge_weights(gauge1, weights[2]);
        gc.vote_for_gauge_weights(gauge2, weights[3]);
        assertEq(gc.vote_user_power(user2), 10000);
        vm.stopPrank();

        for (uint256 i; i < 10; i++) {
            checkpoint();
            uint256 _rel_weigth_1 = gc.gauge_relative_weight(gauge1, block.timestamp);
            uint256 _rel_weigth_2 = gc.gauge_relative_weight(gauge2, block.timestamp);
            assertApproxEqRel(_rel_weigth_1, ((weights[0] + weights[2]) * 1e18) / 2e3, 1e18);
            assertApproxEqRel(_rel_weigth_2, ((weights[1] + weights[3]) * 1e18) / 2e3, 1e18);
        }

        skip((ve.LOCKTIME() - lockStart + ve.WEEK() - 1)); // warp to unlock
        uint256 rel_weigth_1 = gc.gauge_relative_weight(gauge1, block.timestamp);
        uint256 rel_weigth_2 = gc.gauge_relative_weight(gauge2, block.timestamp);
        assertEq(rel_weigth_1, 0);
        assertEq(rel_weigth_2, 0);
    }

    function testVoteExpiry() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        vm.stopPrank();

        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);

        skip(ve.LOCKTIME());

        vm.expectRevert("Lock expires too soon");
        gc.vote_for_gauge_weights(gauge1, 10000);
    }

    function checkpoint() public {
        skip(MONTH);
        utils.mineBlocks(1);

        gc.checkpoint_gauge(gauge1);
        gc.checkpoint_gauge(gauge2);
    }

    function testRelativeWeightWrite() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);
        uint256[2] memory weights = [uint256(80), 20];
        vm.stopPrank();
        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);
        gc.vote_for_gauge_weights(gauge1, weights[0]); // vote 80% for gauge1
        gc.vote_for_gauge_weights(gauge2, weights[1]); // vote 20% for gauge2

        skip(MONTH);

        uint256 base_rel_weight1 = gc.gauge_relative_weight(gauge1, block.timestamp);
        uint256 base_rel_weight2 = gc.gauge_relative_weight(gauge2, block.timestamp);

        assertEq(base_rel_weight1, 0);
        assertEq(base_rel_weight2, 0);

        gc.gauge_relative_weight_write(gauge1, block.timestamp);
        gc.gauge_relative_weight_write(gauge2, block.timestamp);

        uint256 rel_weight1 = gc.gauge_relative_weight(gauge1, block.timestamp);
        uint256 rel_weight2 = gc.gauge_relative_weight(gauge2, block.timestamp);

        assertApproxEqRel(rel_weight1, (weights[0] * 1e18) / 1e2, 0.01e18);
        assertApproxEqRel(rel_weight2, (weights[1] * 1e18) / 1e2, 0.01e18);
    }

    function testRelativeWeightWriteMultipleTypes() public {
        vm.startPrank(gov);
        gc.add_type(TYPE_NAMES[1], TYPE_WEIGHTS[1]); // 40% for type0, 60% for type1
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);
        gc.add_gauge(gauge3, 1);
        uint256[3] memory weights = [uint256(40), 40, 20];
        vm.stopPrank();
        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);
        gc.vote_for_gauge_weights(gauge1, weights[0]); // vote 40% for gauge1
        gc.vote_for_gauge_weights(gauge2, weights[1]); // vote 40% for gauge2
        gc.vote_for_gauge_weights(gauge3, weights[2]); // vote 20% for gauge2

        skip(MONTH);

        uint256 base_rel_weight1 = gc.gauge_relative_weight(gauge1, block.timestamp);
        uint256 base_rel_weight2 = gc.gauge_relative_weight(gauge2, block.timestamp);
        uint256 base_rel_weight3 = gc.gauge_relative_weight(gauge3, block.timestamp);

        assertEq(base_rel_weight1, 0);
        assertEq(base_rel_weight2, 0);
        assertEq(base_rel_weight3, 0);

        gc.gauge_relative_weight_write(gauge1, block.timestamp);
        gc.gauge_relative_weight_write(gauge2, block.timestamp);
        gc.gauge_relative_weight_write(gauge3, block.timestamp);

        uint256 rel_weight1 = gc.gauge_relative_weight(gauge1, block.timestamp);
        uint256 rel_weight2 = gc.gauge_relative_weight(gauge2, block.timestamp);
        uint256 rel_weight3 = gc.gauge_relative_weight(gauge3, block.timestamp);

        assertApproxEqRel(rel_weight1, ((weights[0] * 1e18) * 3) / (4 * 1e2), 0.1e18);
        assertApproxEqRel(rel_weight2, ((weights[1] * 1e18) * 3) / (4 * 1e2), 0.1e18);
        assertApproxEqRel(rel_weight3, ((weights[2] * 1e18) * 2) / (1 * 1e2), 0.1e18);
    }

    function testVoteOverPowerReverts() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);
        vm.stopPrank();

        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);
        gc.vote_for_gauge_weights(gauge1, 5000);
        vm.expectRevert("Used too much power");
        gc.vote_for_gauge_weights(gauge2, 5100);
    }

    function testVoteGaugeWeightChange() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        vm.stopPrank();

        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);
        gc.vote_for_gauge_weights(gauge1, 1000);

        gc.vote_for_gauge_weights(gauge1, 42);

        assertEq(gc.vote_user_power(user1), 42);
    }

    function testVotePowerIsSumVotes() public {
        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        gc.add_gauge(gauge2, 0);
        vm.stopPrank();

        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);
        gc.vote_for_gauge_weights(gauge1, 4000);
        gc.vote_for_gauge_weights(gauge2, 6000);

        assertEq(gc.vote_user_power(user1), 10000);
    }

    function testVoteCooldown() public {
        // vm.warp(((1690836281 + WEEK - 2 days) / WEEK) * WEEK);

        vm.startPrank(gov);
        gc.add_gauge(gauge1, 0);
        vm.stopPrank();

        vm.startPrank(user1);
        ve.createLock{value: 1 ether}(1 ether);

        gc.vote_for_gauge_weights(gauge1, 10000);
        assertEq(gc.gauge_relative_weight(gauge1, block.timestamp), 0);

        vm.warp(block.timestamp + 1 weeks);
        gc.checkpoint_gauge(gauge1);
        assertEq(gc.gauge_relative_weight(gauge1, block.timestamp), 1e18);

        gc.vote_for_gauge_weights(gauge1, 0);
        gc.checkpoint_gauge(gauge1);
        assertEq(gc.gauge_relative_weight(gauge1, block.timestamp), 1e18);

        vm.warp(block.timestamp + 2 weeks);
        gc.checkpoint_gauge(gauge1);
        assertEq(gc.gauge_relative_weight(gauge1, block.timestamp), 0);
    }
}
