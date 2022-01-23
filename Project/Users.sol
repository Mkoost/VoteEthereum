// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;


contract User {
    address owner;
    string nickname;
    string email;
    uint8 number_of_votes = 10;
    uint8 number_of_surveys = 2;
    uint8[] stats = [0,0,0,0,0,0];
    string[] stats_list = ["surveys created", "surveys ended", "votes given", "votes given", "victorious votes", "lost votes"];

    modifier Only_Owner{
        require(msg.sender == owner);
        _;
    }


    constructor(string memory _nickname, string memory _email){
        nickname = _nickname;
        email = _email;
        owner = msg.sender;

    }

    function My_Stats() view public returns(){
    }
}

contract SuperUser is User{

    constructor(string memory _nickname, string memory _email) User(_nickname, _email) {
        number_of_votes = 50;
        number_of_surveys = 10;
    }

    function retur() public view returns(uint8, uint8){
        return (number_of_votes, number_of_surveys);
    }
}

