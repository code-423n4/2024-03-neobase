// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "../VotingEscrow.sol";

contract VotingEscrowTest is Test {
    VotingEscrow public ve;

    address public constant governance = address(10000);
    address public constant user1 = address(10001);
    address public constant user2 = address(10002);
    address public constant user3 = address(10003);

    uint256 public constant LOCK_AMT = 1 ether;

    function setUp() public {
        ve = new VotingEscrow("Voting Escrow", "VE", governance);
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(user3, 100 ether);
    }

    uint256 public constant WEEK = 7 days;

    function _floorToWeek(uint256 _t) internal pure returns (uint256) {
        return (_t / WEEK) * WEEK;
    }

    function testTryCreateLockWithZeroValue() public {
        vm.expectRevert("Only non zero amount");
        ve.createLock(0);
    }

    function testSuccessCreateLock() public {
        // Lock with a duration 5 year should be created with delegated set to msg.sender
        vm.prank(user1);
        ve.createLock{value: LOCK_AMT}(LOCK_AMT);
        assertEq(ve.lockEnd(user1), _floorToWeek(block.timestamp + ve.LOCKTIME()));
        (, , , address delegatee) = ve.locked(user1);
        assertEq(delegatee, user1);
    }

    function testSuccessWithdraw() public {
        // withdraw for expired lock
        testSuccessCreateLock();
        (, uint256 end, , ) = ve.locked(user1);
        vm.warp(end + 1);
        uint256 startBalance = address(user1).balance;
        vm.prank(user1);
        ve.withdraw();
        assertEq(address(user1).balance - startBalance, LOCK_AMT);
    }

    function testUnlockOverride() public {
        testSuccessCreateLock();

        vm.prank(governance);
        ve.toggleUnlockOverride();

        uint256 startBalance = address(user1).balance;
        vm.prank(user1);
        ve.withdraw();
        assertEq(address(user1).balance - startBalance, LOCK_AMT);
    }

    function testTryCreateLockWithMsgValueNotEqual_value() public {
        vm.expectRevert("Invalid value");
        ve.createLock{value: 0}(1);

        vm.expectRevert("Invalid value");
        ve.createLock{value: 1}(2);
    }

    function testTryCreateLockWithExistingLock() public {
        ve.createLock{value: 1}(1);

        vm.expectRevert("Lock exists");
        ve.createLock{value: 1}(1);
    }

    function testTryCreateIncreaseAmountWithZeroValue() public {
        vm.expectRevert("Only non zero amount");
        ve.increaseAmount(0);
    }

    function testTryCreateIncreaseAmountWithMsgValueNotEqual_value() public {
        vm.expectRevert("Invalid value");
        ve.increaseAmount{value: 0}(1);

        vm.expectRevert("Invalid value");
        ve.increaseAmount{value: 1}(2);
    }

    function testTryCreateIncreaseAmountWithNonExistingLock() public {
        vm.expectRevert("No lock");
        ve.increaseAmount{value: 1}(1);
    }

    function testTryWithdrawNonExistingLock() public {
        vm.expectRevert("No lock");
        ve.withdraw();
    }

    function testTryWithdrawForNonExpiredLock() public {
        ve.createLock{value: 1}(1);
        vm.expectRevert("Lock not expired");
        ve.withdraw();
    }

    function testTotalSupplyAndTotalSupplyAt() public {
        uint256 week = ve.WEEK();
        uint256 locktime = ve.LOCKTIME();
        uint256 locktimeInWeeks = locktime / week;

        // Initial state
        assertEq(ve.totalSupply(), 0);
        assertEq(ve.totalSupplyAt(block.number), 0);

        vm.expectRevert("Only past block number");
        ve.totalSupplyAt(block.number + 1);

        // Create locks
        uint256 aliceAmount = 6e18;
        uint256 bobAmount = 3e18;
        uint256 charlieAmount = 1e18;

        vm.prank(user1);
        ve.createLock{value: aliceAmount}(aliceAmount);
        vm.prank(user2);
        ve.createLock{value: bobAmount}(bobAmount);
        vm.prank(user3);
        ve.createLock{value: charlieAmount}(charlieAmount);

        uint256 initialBalance = ve.totalSupply();
        uint256 decayWeekAprox = initialBalance / (5 * 52);

        // Until the last week
        for (uint256 _weeks; _weeks < locktimeInWeeks - 1; ++_weeks) {
            uint256 prevTot = ve.totalSupply();
            uint256 prevTotAt = ve.totalSupplyAt(block.number);

            vm.warp(block.timestamp + week);
            vm.roll(block.number + 1);
            ve.checkpoint();

            uint256 tot = ve.totalSupply();
            assertApproxEqRel(tot, prevTot - decayWeekAprox, 0.00000001e18); // 0,000001% Delta
            uint256 totAt = ve.totalSupplyAt(block.number);
            assertApproxEqRel(totAt, prevTotAt - decayWeekAprox, 0.00000001e18); // 0,000001% Delta
        }

        // Last week
        vm.warp(block.timestamp + week);
        vm.roll(block.number + 1);
        ve.checkpoint();
        assertEq(ve.totalSupply(), 0);
        assertEq(ve.totalSupplyAt(block.number), 0);
    }
}
