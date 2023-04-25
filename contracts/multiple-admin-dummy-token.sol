// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DummyToken is ERC20, AccessControl {
    uint public tokenValue;
    uint8 public decimals;
    bytes32 public constant ADMINS = keccak256("ADMINS");

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint8 _decimals,
        uint _tokenValue
    ) ERC20(tokenName, tokenSymbol) {
        tokenValue = _tokenValue;
        decimals = _decimals;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(ADMINS, _msgSender());
    }
    
    function mint(address to) external payable {
        int decimalDiff = int8(decimals()) - 18;
        if (decimalDiff >= 0) {
            _mint(to, msg.value * tokenValue * 10 ** uint(decimalDiff));
        } else {
            require(msg.value >= 10 ** uint(decimalDiff), "DummyToken: Not enough funds");
            _mint(to, msg.value * tokenValue / 10 ** uint(-decimalDiff));
        }
    }
    
    function burn(uint256 amount) external {
        uint additionalDecimals = decimals() - 18;
        require(amount >= _tokenValue * 10 ** additionalDecimals);
        _burn(_msgSender(), amount);
        (bool sent, bytes memory data) = _msgSender().call{value: amount / _tokenValue}("");
        require(sent, "Failed to send Ether");
    }

    function adminMint(address to, uint256 amount) external onlyRole(ADMINS) {
        _mint(to, amount);
    }

    function adminBurn(uint256 amount) external onlyRole(ADMINS) {
        _burn(_msgSender(), amount);
    }
}
