// SPDX-License-Identifier: GPL-3.0
 
import "./Token.sol" as token;
 
pragma solidity >=0.8.7;
 
interface _Token{
    function transferFrom(address, address, uint) external;
 
}
 
contract Bank{
    _Token tok;
    address token_owner_address;
    address casino_owner;
 
    constructor(address _owner){
        casino_owner = msg.sender;
        token_owner_address = _owner;
        tok = _Token(token_owner_address);
        tok.transferFrom(token_owner_address, address(this), 1000);
    }
 
    modifier onlyOwner(){
        require(msg.sender == casino_owner);
        _;
    }
 
    modifier Pay (uint bet){
        require(bet >= 1);
        _;
    } 
 
    function Top_up_balance() public payable {
        tok.transferFrom(address(this), msg.sender, msg.value);
    }
 
    function rnd(address adr, uint16 number, string memory col, uint bet) view internal returns(uint16){
 
        uint hashBlock = uint(blockhash(block.number));
        uint hashAdr = uint(keccak256(abi.encode(adr)));
        uint hashNum = uint(keccak256(abi.encode(number)));
        uint hashCol = uint(keccak256(abi.encode(col)));
        uint hashBet = uint(keccak256(abi.encode(bet)));
 
        return(uint16(uint(keccak256(abi.encode(hashBlock % 1000 + hashAdr % 1000 + hashNum % 1000 + hashCol % 1000 + hashBet % 1000))) % 100));
 
    }
 
 
    function request() public onlyOwner{
 
    }
}
 
 
contract Roulette is Bank{
 
    constructor(address _owner) Bank(_owner){}
 
    function Bet_and_play_on_number(uint bet, uint16 number) public  Pay(bet) returns(string memory){
        require(number >= 0 && number <= 99);
        tok.transferFrom( msg.sender, address(this), bet);
 
        uint16 res = rnd(msg.sender, number, "TEMP", bet);
 
        if (res == number){
            tok.transferFrom(address(this), msg.sender, bet * 100);
            return("CONGRATS! YOU HAVE JUST WON A SUPER PRIZE! x100!");
        }
        else{
            return("You have lost. Unfortunate. Try again!");
        }
    }
 
    function Bet_and_play_on_color(uint bet, string calldata color) public  Pay(bet) returns(string memory){
        require((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("red"))) || (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("blue"))) || (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green"))));
        tok.transferFrom( msg.sender, address(this), bet);
        uint16 res = rnd(msg.sender, 1, color, bet);
 
        if ((res == 0 && (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green")))) || (res == 99 && (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green"))))){
            tok.transferFrom(address(this), msg.sender, bet * 15);
            return("CONGRATS! 15x WIN!");
        }
        else if ((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("black"))) && (res >= 1) && (res <= 49)){
            tok.transferFrom(address(this), msg.sender, bet * 2);
            return("Congrats! 2x win!");
        }
        else if ((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("red"))) && (res >= 50) && (res <= 98)){
            tok.transferFrom(address(this), msg.sender, bet * 2);
            return("Congrats! 2x win!");
        }
        else{
            return("You have lost. Unfortunate. Try again!");
        }
 
    }
}
 
contract Slot_Machine is Bank{
 
    constructor(address _owner) Bank(_owner){}
 
    function rnd(address adr, uint bet) view internal returns(uint16){
 
        uint hashBlock = uint(blockhash(block.number));
        uint hashAdr = uint(keccak256(abi.encode(adr)));
        uint hashBet = uint(keccak256(abi.encode(bet)));
 
        return(uint16(uint(keccak256(abi.encode(hashBlock % 1000 + hashAdr % 1000 + hashBet % 1000))) % 16));
 
    }
 
    function Bet_and_play(uint bet) public Pay(bet) returns(string memory, uint16, uint16, uint16){
        tok.transferFrom( msg.sender, address(this), bet);
        uint16 res1 = rnd(msg.sender, bet) + 1;
        uint16 res2 = rnd(msg.sender, bet) + 1;
        uint16 res3 = rnd(msg.sender, bet) + 1;
        if (res1 == res2 && res2 == res3 && res1 == res3){
            tok.transferFrom(address(this), msg.sender, bet * 25);
            return("CONGRATS! YOU HAVE JUST WON A SUPER PRIZE! X25!", res1, res2, res3);
        }
 
        else{
            return("You have lost. Unfortunate. Try again!", res1, res2, res3);
        }
    }
}