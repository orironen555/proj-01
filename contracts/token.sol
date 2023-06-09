// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract SafeMath { 
function sub(uint256 a, uint256 b) internal pure returns (uint256) {
  assert(b <= a);
  return a - b;
}
function add(uint256 a, uint256 b) internal pure returns (uint256)   {
  uint256 c = a + b;
  assert(c >= a);
  return c;
 }
}

//import "./IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Interface {

function totalSupply() public view returns (uint256);
function balanceOf(address tokenOwner) public view returns (uint);
function allowance(address tokenOwner, address spender) public view returns (uint);
function transfer(address to, uint tokens) public returns (bool);
function approve(address spender, uint tokens)  public returns (bool);
function transferFrom(address from, address to, uint tokens) public returns (bool);

event Approval(address indexed tokenOwner, address indexed spender,uint tokens);
event Transfer(address indexed from, address indexed to,uint tokens);

}

contract ElectionToken is  ERC20Interface, SafeMath {

    string public name = "ELECTION";
    string public symbol = "FINAL PROJECT";
    uint8 public decimals = 18;
    uint256 public _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    constructor() {
        _totalSupply = 100000;
        balances[msg.sender]=_totalSupply;
        emit transfer(address(0),msg.sender,_totalSupply);
    }

    function totalSupply() public view returns (uint256) {
    return totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
    return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
    require(numTokens <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(numTokens);
    balances[receiver] = balances[receiver].add(numTokens);
    emit Transfer(msg.sender, receiver, numTokens);
    return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
    allowed[msg.sender][delegate] = numTokens;
    emit Approval(msg.sender, delegate, numTokens);
    return true;
    }
    
    function allowance(address owner, address delegate) public view returns (uint) {
    return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer,uint numTokens) public returns (bool) {
    require(numTokens <= balances[owner]);
    require(numTokens <= allowed[owner][msg.sender]);
    balances[owner] = balances[owner] - numTokens;
    allowed[owner][msg.sender] = balances[owner] = balances[owner].sub(numTokens);
    balances[buyer] = balances[buyer].add(numTokens);
    Transfer(owner, buyer, numTokens);
    return true;
    }
}