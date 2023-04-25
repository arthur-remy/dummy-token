// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TestnetToken is ERC20, AccessControl {
    uint public tokenValue;
    uint8 _decimals;
    bytes32 public constant ADMINS = keccak256("ADMINS");

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint8 _setDecimals,
        uint _tokenValue
    ) ERC20(tokenName, tokenSymbol) {
        tokenValue = _tokenValue;
        _decimals = _setDecimals;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(ADMINS, _msgSender());
    }
    
    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function mint(address to) external payable {
        int decimalDiff = int8(decimals()) - 18;
        uint amount;
        if (decimalDiff >= 0) {
            amount = msg.value * tokenValue * 10 ** uint(decimalDiff);
        } else {
            require(msg.value >= 10 ** uint(-decimalDiff), "TestnetToken: ETH amount too low");
            amount = msg.value * tokenValue / 10 ** uint(-decimalDiff);
        }
        _mint(to, amount);
    }
    
    function burn(uint256 amount) external {
        int decimalDiff = int8(decimals()) - 18;
        uint returnedAmount;
        if (decimalDiff >= 0) {
            require(amount >= tokenValue * 10 ** uint(decimalDiff), "TestnetToken: burn amount too low");
            returnedAmount = (amount / tokenValue) / 10 ** uint(decimalDiff);
        } else {
            returnedAmount = (amount / tokenValue) * 10 ** uint(-decimalDiff);
        }
        _burn(_msgSender(), amount);
        (bool sent, bytes memory data) = _msgSender().call{value: returnedAmount}("");
        require(sent, "TestnetToken: failed to send Ether");
    }

    function adminMint(address to, uint256 amount) external onlyRole(ADMINS) {
        _mint(to, amount);
    }

    function adminBurn(uint256 amount) external onlyRole(ADMINS) {
        _burn(_msgSender(), amount);
    }
}
