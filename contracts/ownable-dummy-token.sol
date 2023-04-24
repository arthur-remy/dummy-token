// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OwnableDummyToken is ERC20, Ownable {
    uint _tokenValue;

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint tokenValue
    ) ERC20(tokenName, tokenSymbol) {
        _tokenValue = tokenValue;
    }

    function mint(address to) external payable {
        _mint(to, msg.value * _tokenValue);
    }
    
    function adminMint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function adminBurn(uint256 amount) external onlyOwner {
        _burn(_msgSender(), amount);
    }

    function burn(uint256 amount) external {
        require(amount >= _tokenValue);
        _burn(_msgSender(), amount);
        (bool sent, bytes memory data) = _msgSender().call{value: amount / _tokenValue}("");
        require(sent, "Failed to send Ether");
    }
}
