// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract crust is ERC20 {
    constructor() ERC20("crust", "@CR") {
        _mint(msg.sender, 100000000000000000000);
    }
}
