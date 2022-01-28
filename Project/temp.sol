// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;
import "./Token.sol" as token;

contract Slot_Machine{
    token.Token tok;
    address token_owner_address = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    constructor(){
        tok = token.Token(token_owner_address);
    }

    modifier Pay (uint bet){
        require(bet >= 1);
        _;
    } 

    function Top_up_balance() public payable {
        tok.mint(msg.sender , msg.value * 5);
    }

    function rnd(address adr, uint bet) view internal returns(uint16){

        uint hashBlock = uint(blockhash(block.number));
        uint hashAdr = uint(keccak256(abi.encode(adr)));
        uint hashBet = uint(keccak256(abi.encode(bet)));

        return(uint16(uint(keccak256(abi.encode(hashBlock % 1000 + hashAdr % 1000 + hashBet % 1000))) % 16));

    }

    function Bet_and_play_on_number(uint bet) public  Pay(bet) returns(string memory, uint16, uint16, uint16){
        tok.transfer(msg.sender, bet);
        uint16 res1 = rnd(msg.sender, bet);
        uint16 res2 = rnd(msg.sender, bet);
        uint16 res3 = rnd(msg.sender, bet);
        if (res1 == res2 && res2 == res3 && res1 == res3){
            tok.mint(msg.sender, (bet * 25));
            return("CONGRATS! YOU HAVE JUST WON A SUPER PRIZE! X25!", res1, res2, res3);
        }

        else{
            return("You have lost. Unfortunate. Try again!", res1, res2, res3);
        }
    }
}