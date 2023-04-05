// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DummyToken is ERC20 {
    uint _tokenValue;

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint tokenValue
    ) ERC20(tokenName, tokenSymbol) {
        _tokenValue = tokenValue;
    }

    function mint(address to) public payable {
        _mint(to, msg.value * _tokenValue);
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
		(bool sent, bytes memory data) = _msgSender().call{value: amount / _tokenValue}("");
		require(sent, "Failed to send Ether");
    }
}
