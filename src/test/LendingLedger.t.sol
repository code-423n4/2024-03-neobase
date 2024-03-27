// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

import {Test} from "forge-std/Test.sol";
import {Utilities} from "./utils/Utilities.sol";
// import {console} from "./utils/Console.sol";

import "../LendingLedger.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DummyGaugeController {
    function gauge_relative_weight_write(address _gauge, uint256 _time) external returns (uint256) {
        return 1 ether;
    }
}

contract LendingLedgerTest is Test {
    Utilities internal utils;
    address payable[] internal users;

    LendingLedger ledger;
    DummyGaugeController controller;
    address goverance;

    uint256 public constant WEEK = 7 days;

    uint256 public constant BLOCK_EPOCH = 100_000;

    address lendingMarket;

    address lender;

    uint248 amountPerEpoch = 1 ether;

    uint256 amountPerBlock = amountPerEpoch / BLOCK_EPOCH;

    uint256 fromEpoch = BLOCK_EPOCH * 5;

    uint256 toEpoch = BLOCK_EPOCH * 10;

    function setUp() public {
        utils = new Utilities();

        users = utils.createUsers(5);

        goverance = users[0];

        controller = new DummyGaugeController();

        ledger = new LendingLedger(address(controller), goverance);

        lendingMarket = vm.addr(5201314);

        lender = users[1];
    }

    function testAddWhitelistLendingMarket() public {
        address lendingMarket = vm.addr(5201314);

        vm.prank(goverance);
        ledger.whiteListLendingMarket(lendingMarket, true, false);

        bool isWhitelisted = ledger.lendingMarketWhitelist(lendingMarket);
        assertTrue(isWhitelisted);
    }

    function testAddWhitelistLendingMarketAgain() public {
        address lendingMarket = vm.addr(5201314);

        vm.startPrank(goverance);
        ledger.whiteListLendingMarket(lendingMarket, true, false);

        bool isWhitelisted = ledger.lendingMarketWhitelist(lendingMarket);
        assertTrue(isWhitelisted);

        vm.expectRevert("No change");
        ledger.whiteListLendingMarket(lendingMarket, true, false);

        assertTrue(isWhitelisted);
    }

    function testAddWhitelistWithGauge() public {
        address lendingMarket = vm.addr(5201314);

        vm.mockCall(lendingMarket, abi.encodeWithSelector(ERC20.symbol.selector), abi.encode("LM"));

        vm.startPrank(goverance);
        ledger.whiteListLendingMarket(lendingMarket, true, true);

        assertNotEq(lendingMarket, address(0));

        bool isWhitelisted = ledger.lendingMarketWhitelist(lendingMarket);
        assertTrue(isWhitelisted);
    }

    function testRemoveWhitelistEntry() public {
        address lendingMarket = vm.addr(5201314);

        vm.startPrank(goverance);
        ledger.whiteListLendingMarket(lendingMarket, true, false);

        bool isWhitelisted = ledger.lendingMarketWhitelist(lendingMarket);
        assertTrue(isWhitelisted);

        ledger.whiteListLendingMarket(lendingMarket, false, false);

        isWhitelisted = ledger.lendingMarketWhitelist(lendingMarket);
        assertTrue(!isWhitelisted);
    }

    function testSetRewardWithInvalidEpoch() public {
        uint256 fromEpoch = BLOCK_EPOCH * 5 + 30;
        uint256 toEpoch = BLOCK_EPOCH * 10 - 26;

        vm.prank(goverance);
        vm.expectRevert("Invalid block number");
        ledger.setRewards(fromEpoch, toEpoch, amountPerBlock);
    }

    function testSetValidRewardDistribution() public {
        uint256 fromEpoch = BLOCK_EPOCH * 5;
        uint256 toEpoch = BLOCK_EPOCH * 10;

        vm.startPrank(goverance);
        ledger.setRewards(fromEpoch, toEpoch, amountPerBlock);

        for (uint256 i = fromEpoch; i <= toEpoch; i += BLOCK_EPOCH) {
            uint256 perBlock = ledger.cantoPerBlock(i);
            assertEq(amountPerBlock, perBlock);
        }
    }

    function testSyncLedgerMarketNotWhitelisted() public {
        int256 delta = 0.5 ether;

        vm.startPrank(lendingMarket);
        vm.expectRevert("Market not whitelisted");
        ledger.sync_ledger(lender, delta);
    }

    function whiteListMarket() internal {
        vm.prank(goverance);
        ledger.whiteListLendingMarket(lendingMarket, true, false);
    }

    function testSyncLedgerUnderflow() public {
        whiteListMarket();

        int256 delta = -100;
        vm.startPrank(lendingMarket);

        vm.expectRevert();
        ledger.sync_ledger(lender, delta);
    }

    function testSyncLedgerWithoutGap() public {
        whiteListMarket();

        int256 delta = 1.1 ether;
        vm.startPrank(lendingMarket);
        ledger.sync_ledger(lender, delta);

        uint256 epoch = 0;

        uint256 lendingMarketTotal = ledger.lendingMarketTotalBalance(lendingMarket);

        assertTrue(lendingMarketTotal == uint256(delta));
    }

    function testSyncLedgerWithGaps() public {
        // prepare
        whiteListMarket();
        vm.warp(block.timestamp + WEEK);

        vm.startPrank(lendingMarket);

        int256 deltaStart = 1 ether;
        uint256 epochStart = (block.timestamp / WEEK) * WEEK;
        ledger.sync_ledger(lender, deltaStart);

        // gaps of 3 week
        uint256 newTime = block.timestamp + 3 * WEEK;
        vm.warp(newTime);
        int256 deltaEnd = 1 ether;
        uint256 epochEnd = (newTime / WEEK) * WEEK;
        ledger.sync_ledger(lender, deltaEnd);

        // total balance is forwarded and set
        uint256 totalBalance = ledger.lendingMarketTotalBalance(lendingMarket);
        assertEq(totalBalance, uint256(deltaStart) + uint256(deltaEnd));
    }

    function setupStateBeforeClaim() internal {
        whiteListMarket();

        vm.prank(goverance);
        ledger.setRewards(fromEpoch, toEpoch, amountPerBlock);

        vm.roll(BLOCK_EPOCH * 5);

        int256 delta = 1.1 ether;
        vm.prank(lendingMarket);
        ledger.sync_ledger(lender, delta);

        // airdrop ledger enough token balance for user to claim
        payable(ledger).transfer(1000 ether);
    }

    function testClaimValidLenderOneBlock() public {
        setupStateBeforeClaim();

        uint256 balanceBefore = address(lender).balance;
        vm.prank(lender);
        vm.roll(BLOCK_EPOCH * 5 + 1);
        ledger.claim(lendingMarket);
        uint256 balanceAfter = address(lender).balance;
        assertEq(balanceAfter - balanceBefore, amountPerBlock - 1); // We round down...

        // Second claim should not increase
        ledger.claim(lendingMarket);
        uint256 balanceAfter2 = address(lender).balance;
        assertEq(balanceAfter, balanceAfter2);
    }

    function testClaimValidLenderOneEpoch() public {
        setupStateBeforeClaim();

        uint256 balanceBefore = address(lender).balance;
        vm.prank(lender);
        vm.roll(BLOCK_EPOCH * 6);
        ledger.claim(lendingMarket);
        uint256 balanceAfter = address(lender).balance;
        assertEq(balanceAfter - balanceBefore, 1 ether - 1); // We round down...

        // Second claim should not increase
        ledger.claim(lendingMarket);
        uint256 balanceAfter2 = address(lender).balance;
        assertEq(balanceAfter, balanceAfter2);
    }

    function testClaimValidLenderTwoEpochs() public {
        setupStateBeforeClaim();

        uint256 balanceBefore = address(lender).balance;
        vm.prank(lender);
        vm.roll(BLOCK_EPOCH * 7);
        ledger.claim(lendingMarket);
        uint256 balanceAfter = address(lender).balance;
        assertEq(balanceAfter - balanceBefore, 2 ether - 2); // We round down...

        // Second claim should not increase
        ledger.claim(lendingMarket);
        uint256 balanceAfter2 = address(lender).balance;
        assertEq(balanceAfter, balanceAfter2);
    }

    function testClaimMultipleLenders() public {
        setupStateBeforeClaim();
        vm.startPrank(lendingMarket);
        vm.roll(BLOCK_EPOCH * 5 + BLOCK_EPOCH / 2);
        // In middle of first epoch, second depositor deposits
        ledger.sync_ledger(users[2], 2.2 ether);
        // At beginning of second epoch, third depositor deposits
        vm.roll(BLOCK_EPOCH * 6);
        ledger.sync_ledger(users[3], 1.1 ether / 2);
        vm.stopPrank();
        vm.roll(BLOCK_EPOCH * 7);
        uint256 balanceBefore1 = address(lender).balance;
        vm.prank(lender);
        ledger.claim(lendingMarket);
        uint256 balanceAfter1 = address(lender).balance;
        // lender should receive: 0.5 ETH for first epoch half, 0.5 / 3 ETH for first epoch second half, 1.1 / 3.85 ETH for second epoch
        uint256 expected1 = 0.5 ether + 0.5 ether / uint256(3) + (1 ether * uint256(110)) / uint256(385);
        assertEq(balanceAfter1 - balanceBefore1, expected1);

        uint256 balanceBefore2 = address(users[2]).balance;
        vm.prank(users[2]);
        ledger.claim(lendingMarket);
        uint256 balanceAfter2 = address(users[2]).balance;
        // second user should receive: 2 / 3 * 0.5 ETH for first epoch second half, 2.2 / 3.85 ETH for second epoch
        uint256 expected2 = (0.5 ether * 2) / uint256(3) + (1 ether * uint256(220)) / uint256(385);
        assertEq(balanceAfter2 - balanceBefore2, expected2);

        uint256 balanceBefore3 = address(users[3]).balance;
        vm.prank(users[3]);
        ledger.claim(lendingMarket);
        uint256 balanceAfter3 = address(users[3]).balance;
        // third user should receive: 0.55 / 3.85 ETH for second epoch
        uint256 expected3 = (1 ether * uint256(55)) / uint256(385);
        assertEq(balanceAfter3 - balanceBefore3, expected3);
    }

    // function testTimeWeightedClaiming() public {
    //     whiteListMarket();
    //     int256 delta = 1.1 ether;

    //     vm.prank(goverance);
    //     ledger.setRewards(0, WEEK * 10, amountPerEpoch);
    //     vm.startPrank(lendingMarket);
    //     // users[2] deposits at beginning of epoch
    //     vm.warp(WEEK * 4);
    //     ledger.sync_ledger(users[2], delta);
    //     // lender deposits at 23:59 (week 4)
    //     vm.warp((WEEK * 5) - 1);

    //     ledger.sync_ledger(lender, delta);
    //     vm.stopPrank();

    //     // airdrop ledger enough token balance for user to claim
    //     payable(ledger).transfer(1000 ether);
    //     // withdraw at 00:00 (week 5)
    //     vm.warp(WEEK * 5);
    //     vm.prank(lendingMarket);
    //     ledger.sync_ledger(lender, delta * (-1));

    //     uint256 balanceBefore = address(lender).balance;
    //     vm.prank(lender);
    //     ledger.claim(lendingMarket, 0, type(uint256).max);
    //     uint256 balanceAfter = address(lender).balance;
    //     // Lender should receive rewards for 1 second
    //     assertEq(balanceAfter - balanceBefore, (1 * 1 ether * 1.1 ether) / (1.1 ether * WEEK + 1.1 ether));
    //     uint256 balanceBefore2 = address(users[2]).balance;
    //     vm.prank(users[2]);
    //     ledger.claim(lendingMarket, 0, type(uint256).max);
    //     uint256 balanceAfter2 = address(users[2]).balance;
    //     // User2 should receive rewards for 1 week
    //     assertEq(balanceAfter2 - balanceBefore2, (WEEK * 1 ether * 1.1 ether) / (1.1 ether * WEEK + 1.1 ether));
    // }
}
