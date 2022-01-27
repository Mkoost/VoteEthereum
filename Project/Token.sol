// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

contract Token{
    string constant name = "Token777";
    string constant symbol = "777";
    uint8 constant decimals = 3;
    uint totalSupply = 0;
    mapping(address => uint256) public balances;

    address owner;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    constructor(){
        owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        balances[owner] = 10;
    }

    function mint(address adr, uint k) public {
        totalSupply += k;
        balances[adr] += k;
    }

    function transfer(address adr_to_send, uint k) external {
        require((balances[msg.sender] >= k) && (adr_to_send == owner));
        balances[msg.sender] -= k;
        balances[adr_to_send] += k;
    }

    function transferFrom(address _from, address _to, uint k) private onlyOwner{
        require(balances[_from] >= k);
        balances[_from] -= k;
        balances[_to] += k;
    }

    function balanceOf(address adr) private onlyOwner view returns(uint){
        return(balances[adr]);
    }

    function balanceOf() public view returns(uint){
        return(balances[msg.sender]);
    }



}
