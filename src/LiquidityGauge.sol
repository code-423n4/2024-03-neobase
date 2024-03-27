// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.16;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

interface LendingLedger {
    function sync_ledger(address _lender, int256 _delta) external;
}

contract LiquidityGauge is ERC20, ERC20Burnable {
    using SafeERC20 for IERC20;

    address public lendingLedger;
    address public underlyingToken;

    constructor(address _underlyingToken, address _lendingLedger)
        ERC20(
            string.concat(ERC20(_underlyingToken).symbol(), " NeoFinance Gauge"),
            string.concat(ERC20(_underlyingToken).symbol(), "-gauge")
        )
    {
        underlyingToken = _underlyingToken;
        lendingLedger = _lendingLedger;
    }

    /// @notice Function called by user to deposit underlying tokens
    /// @param _amount The amount of token to be deposited
    function depositUnderlying(uint256 _amount) external {
        address _user = msg.sender;

        IERC20(underlyingToken).safeTransferFrom(_user, address(this), _amount);
        _mint(_user, _amount);
    }

    /// @notice Function called by the user to withdraw underlying tokens
    /// @param _amount The amount of token to be withdrawn
    function withdrawUnderlying(uint256 _amount) external {
        address _user = msg.sender;

        _burn(_user, _amount);
        IERC20(underlyingToken).safeTransfer(_user, _amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._afterTokenTransfer(from, to, amount);
        if (from != address(0)) {
            LendingLedger(lendingLedger).sync_ledger(from, -int256(amount));
        }
        if (to != address(0)) {
            LendingLedger(lendingLedger).sync_ledger(to, int256(amount));
        }
    }
}
