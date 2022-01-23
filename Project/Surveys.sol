// SPDX-License-Identifier: GPL-3.0
import "Project/Users.sol" as Users;
pragma solidity >=0.8.7;

contract Surveys{
    mapping(address => bool) voters;
    mapping(uint8 => uint) votes_count;
    string text_of_question;
    Users.User owner;
    uint8 count_of_questions;


    constructor(string memory _text_of_question, uint8 _count_of_questions) public{
        text_of_question = _text_of_question;
        count_of_questions = _count_of_questions;
    }
    
    function give_a_vote(address voter, uint8 number) public returns(string memory){
        if(1 < number || number > count_of_questions) return "You can only choose from the list.";
        if(voters[voter]) return "You cannot vote twice.";
        votes_count[number]++;
        voters[voter] = true;
        return "Congratulation! Your vote was accepted.";
    }

    function statistics(uint8 number) public view returns(uint){
        if(1 < number || number > count_of_questions) return 0;
        return votes_count[number];
    }
    
    function look_a_text() public view returns(string memory){ return text_of_question; }

}