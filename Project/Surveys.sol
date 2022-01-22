// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

contract Surveys{
    address contrcat_owner;

    constructor(){
        contrcat_owner = msg.sender;

    }
                
    function Create_Survey() view public {
        address owner = msg.sender;

    }
}
