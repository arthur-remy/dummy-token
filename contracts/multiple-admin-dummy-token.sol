// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DummyToken is ERC20, AccessControl {
    uint _tokenValue;
    bytes32 public constant ADMINS = keccak256("ADMINS");

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint tokenValue
    ) ERC20(tokenName, tokenSymbol) {
        _tokenValue = tokenValue;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(ADMINS, _msgSender());
    }

    function mint(address to) external payable {
        _mint(to, msg.value * _tokenValue);
    }
    
    function burn(uint256 amount) external {
        require(amount >= _tokenValue);
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
