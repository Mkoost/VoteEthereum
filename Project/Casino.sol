// SPDX-License-Identifier: GPL-3.0
 
import "./Token.sol" as token;
 
pragma solidity >=0.8.7;
 
interface _Token{ // интерфейс токена 
    function transfer_from(address _from, address _to, uint number_of_tokens) external;
    function balance_of_others(address adr_from, address adr) external view returns(uint);
    function balance_of(address adr) external view returns(uint);
 
}
 
contract Bank{ // контракт родитель, в котором назодятся функции свзанные с балансом
    _Token tok;
    address token_owner_address;
    address casino_owner;
 
    constructor(address _owner){
        require(_owner == msg.sender);
        casino_owner = msg.sender;
        token_owner_address = _owner;
        tok = _Token(token_owner_address);
        tok.transfer_from(token_owner_address, address(this), 10000000000000000);
    }
 
    modifier onlyOwner(){
        require(msg.sender == casino_owner, "Sorry, only owner of the casino can access this function");
        _;
    }
 
    function yop_up_balance() public payable { // ф-ия пополнения баланса
        tok.transfer_from(address(this), msg.sender, msg.value);
    }
 
    function request(uint needed_balance) public onlyOwner{ // ф-ия запроса дополнительных токенов для баланса казино
        tok.transfer_from(token_owner_address, address(this), needed_balance);
    }

    function casino_balance() public view onlyOwner returns(uint256){ // ф-ия проверки баланса казино
        return(tok.balance_of_others(msg.sender, address(this)));
    }

    function my_balance() public view returns(uint256){ // ф-ия проверки баланса пользователя
        return(tok.balance_of(msg.sender));
    }
}
 
 
contract Roulette is Bank{ // контракт-наследник от Bank. тут находятся функции игр и вся их логика
    constructor(address _owner) Bank(_owner){}
 
    modifier Pay (uint bet){
        require(bet >= 1, "Bet must bet at least 1 token");
        _;
    } 
 
    function rnd_for_roulette(address adr, uint8 number, string memory color, uint bet) view internal returns(uint8){ // ф-ия генерации случайного числа для 
 
        uint hashBlock = uint(blockhash(block.number));
        uint hashAdr = uint(keccak256(abi.encode(adr)));
        uint hashNum = uint(keccak256(abi.encode(number)));
        uint hashCol = uint(keccak256(abi.encode(color)));
        uint hashBet = uint(keccak256(abi.encode(bet)));
 
        return(uint8(uint(keccak256(abi.encode(hashBlock % 1000 + hashAdr % 1000 + hashNum % 1000 + hashCol % 1000 + hashBet % 1000))) % 100));
 
    }
 
    function Roulette_bet_on_number(uint bet, uint8 number) public  Pay(bet) returns(string memory, uint8){ // ф-ия, в которой реализована логика работы игры 'Ставка на чилсо'
        require(number >= 0 && number <= 99, "You must pick a number from 0 to 99");
        tok.transfer_from( msg.sender, address(this), bet);
 
        uint8 res = rnd_for_roulette(msg.sender, number, "TEMP", bet);
 
        if (res == number){
            tok.transfer_from(address(this), msg.sender, bet * 1000);
            return("CONGRATS! YOU HAVE JUST WON A SUPER PRIZE! x1000! YOU HAVE GUESSED THE NUMBER:", res);
        }
        else{
            return("You have lost. Unfortunate. Try again! The number was:", res);
        }
    }
 
    function Roulette_bet_on_color(uint bet, string memory color) public  Pay(bet) returns(string memory){ // ф-ия, в которой реализована логика работы игры 'Рулетка'
        require((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("red"))) || (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("black"))) || (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green"))), "Colors are 'black', 'red' and 'green'");
        
        tok.transfer_from( msg.sender, address(this), bet);
        uint16 res = rnd_for_roulette(msg.sender, 1, color, bet);
 
        if (((res == 0) || (res == 99)) && (keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("green")))){
            tok.transfer_from(address(this), msg.sender, bet * 15);
            return("CONGRATS! 15x WIN!");
        }
        else if ((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("black"))) && (res >= 1) && (res <= 49)){
            tok.transfer_from(address(this), msg.sender, bet * 2);
            return("Congrats! 2x win!");
        }
        else if ((keccak256(abi.encodePacked(color)) == keccak256(abi.encodePacked("red"))) && (res >= 50) && (res <= 98)){
            tok.transfer_from(address(this), msg.sender, bet * 2);
            return("Congrats! 2x win!");
        }
        else{
            return("You have lost. Unfortunate. Try again!");
        }
 
    }

    function rnd_for_slot_machine(address adr, uint bet) view internal returns(uint8){ // ф-ия генерации случайного числа для работы слот-машины
 
        uint hashBlock = uint(blockhash(block.number));
        uint hashAdr = uint(keccak256(abi.encode(adr)));
        uint hashBet = uint(keccak256(abi.encode(bet)));
 
        return(uint8(uint(keccak256(abi.encode(hashBlock % 1000 + hashAdr % 1000 + hashBet % 1000))) % 16));
 
    }
 
    function Slot_Machine_bet_and_try_your_luck(uint bet) public Pay(bet) returns(string memory, uint8, uint8, uint8){ // ф-ия, в которой реализована логика работы игры 'Слот-машина'
        tok.transfer_from( msg.sender, address(this), bet);
        uint8 res1 = rnd_for_slot_machine(msg.sender, bet + 1) + 1;
        uint8 res2 = rnd_for_slot_machine(msg.sender, bet + 2) + 1;
        uint8 res3 = rnd_for_slot_machine(msg.sender, bet + 3) + 1;
        if (res1 == res2 && res2 == res3 && res1 == res3){
            tok.transfer_from(address(this), msg.sender, bet * 4);
            return("CONGRATS! YOU HAVE JUST WON A SUPER PRIZE! X4!", res1, res2, res3);
        }
 
        else{
            return("You have lost. Unfortunate. Try again!", res1, res2, res3);
        }
    }
}
