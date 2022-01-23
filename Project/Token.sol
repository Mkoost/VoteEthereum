// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

contract Token{
    string constant name = "Token777";
    string constant symbol = "777";
    uint8 constant decimals = 20;
    uint totalSupply = 0;
    mapping(address => uint) balances;

    address owner;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function mint(address adr_to_trans, uint k) public onlyOwner{
            totalSupply += k;
            balances[adr_to_trans] += k;
    }

    function transfer(address adr_to_send, uint k) public{
        require(balances[msg.sender] >= k);
        balances[msg.sender] -= k;
        balances[adr_to_send] += k;
    }

    function transferFrom(address _from, address _to, uint k) public{
        require(balances[_from] >= k);
        balances[_from] -= k;
        balances[_to] += k;
    }

    function balanceOf(address adr) public view returns(uint){
        return(balances[adr]);
    }

    function balanceOf() public view returns(uint){
        return(balances[msg.sender]);
    }

}
