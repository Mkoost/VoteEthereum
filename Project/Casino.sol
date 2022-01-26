// SPDX-License-Identifier: GPL-3.0

import "./Token.sol";

pragma solidity >=0.8.7;

contract Casino{
    Token tok;

    constructor(address owner_address){
        tok = Token(owner_address);
    }

    function Top_up_balance() public payable {
        tok.mint(msg.sender, msg.value * 5);
    }
}