
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GoblinGold is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * (10 ** 18); // 1 Billion GOB
    uint256 public taxRate = 5; // 5% transaction fee for each transfer
    address public treasury; // Treasury address to receive the tax

    event TaxRateUpdated(uint256 oldRate, uint256 newRate);
    event TreasuryUpdated(address oldTreasury, address newTreasury);

    constructor(address _treasury) ERC20("GoblinGold", "GOB") {
        require(_treasury != address(0), "Invalid treasury address");
        treasury = _treasury;
        _mint(msg.sender, INITIAL_SUPPLY); // Mint all tokens to the deployer's address
    }

    function setTaxRate(uint256 _taxRate) external onlyOwner {
        require(_taxRate <= 10, "Max tax rate is 10%");
        emit TaxRateUpdated(taxRate, _taxRate);
        taxRate = _taxRate;
    }

    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "Invalid treasury address");
        emit TreasuryUpdated(treasury, _treasury);
        treasury = _treasury;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        uint256 taxAmount = (amount * taxRate) / 100;
        uint256 netAmount = amount - taxAmount;

        super._transfer(sender, treasury, taxAmount);
        super._transfer(sender, recipient, netAmount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
