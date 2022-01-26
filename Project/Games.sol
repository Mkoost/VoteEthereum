// SPDX-License-Identifier: GPL-3.0

import "./Token.sol";

pragma solidity >=0.8.7;

contract Roulette{
    Token tok;
    address owner_address;

    constructor(address Token_owner){
        owner_address = Token_owner;
        tok = Token(owner_address);
    }

    modifier Pay (uint bet, address adr){
        bet >= 15;
        tok.transfer(owner_address, bet);
        _;
    }

    function rnd(address adr, uint16 number, string memory col, uint bet) view internal returns(uint16){

        uint hashBlock = uint(blockhash(block.number));
        uint hashAdr = uint(keccak256(abi.encode(adr)));
        uint hashNum = uint(keccak256(abi.encode(number)));
        uint hashCol = uint(keccak256(abi.encode(col)));
        uint hashBet = uint(keccak256(abi.encode(bet)));

        return(uint16(uint(keccak256(abi.encode(hashBlock % 1000 + hashAdr % 1000 + hashNum % 1000 + hashCol % 1000 + hashBet % 1000))) % 100));

    }

    function Bet_and_play_on_number(uint bet, uint16 number) public  Pay(bet, msg.sender) returns(string memory){
        require(number >= 0 && number <= 99);

        uint16 res = rnd(msg.sender, number, "TEMP", bet);

        if (res == number){
            tok.mint(msg.sender, (bet * 100));
            return("CONGRATS! YOU HAVE JUST WON A SUPER PRIZE! x100!");
        }
        else{
            return("You have lost. Unfortunate. Try again!");
        }
    }

    function Bet_and_play_on_color(uint bet, string calldata color) public  Pay(bet, msg.sender) returns(string memory){
        require((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("red"))) || (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("blue"))) || (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green"))));

        uint16 res = rnd(msg.sender, 1, color, bet);

        if ((res == 0 && (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green")))) || (res == 99 && (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green"))))){
            tok.mint(msg.sender, (bet * 15));
            return("CONGRATS! 15x WIN!");
        }
        else if ((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("black"))) && (res >= 1) && (res <= 49)){
            tok.mint(msg.sender, (bet * 2));
            return("Congrats! 2x win!");
        }
        else if ((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("red"))) && (res >= 50) && (res <= 98)){
            tok.mint(msg.sender, (bet * 2));
            return("Congrats! 2x win!");
        }
        else{
            return("You have lost. Unfortunate. Try again!");
        }



    }
}
