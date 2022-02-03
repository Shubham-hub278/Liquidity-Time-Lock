// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./IToken.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MindApp {
    using SafeMath for uint256;
    using SafeERC20 for IToken; 
    address public owner;
    address payable public liquidityAddress;
    address payable public stakeAddress;  
    address public mindToken; 
    uint256 public tokenprice; 

    struct Investor{
        address depositedby;
        uint256 balances;
        uint256 deposited_at;
        uint256 releasetime;
    }

    mapping(address => uint256) public tokenbalances; 

    mapping(address => Investor) public investorinfo;

    // event LogDeposit(address sender, uint amount, uint releaseTime);   
    // event LogcancelInvest(address receiver, uint amount);

    constructor(address _mindToken) {        
        mindToken = _mindToken;
        owner = msg.sender;
    }

    function setstakeAddress(address payable _stakeAddress) public {
        require(msg.sender==owner);
        stakeAddress = _stakeAddress;
    }

    function setliquidity(address payable _liquidityAddress) public{
        require(msg.sender==owner);
        liquidityAddress= _liquidityAddress;
    }

    function settokencost(uint _tokenprice) public{
        require(msg.sender==owner);
        tokenprice = _tokenprice;
    }

    function deposit() external payable {
        uint256 amount = msg.value;
        address depositedby = msg.sender;

        require(amount>0,"Funds can not be less than zero");
        uint256 investingamount = amount.mul(90).div(100);

        _depositInternal(investingamount, depositedby);

         //10% amount to be sent to the liquiditycontract
        uint256 onetenth_amount = amount.sub(investingamount);
        liquidityAddress.transfer(onetenth_amount);
    }

    function _depositInternal(uint256 investingamount, address depositedby) internal {
        
        investorinfo[depositedby].balances = investorinfo[depositedby].balances.add(investingamount); 

        investorinfo[depositedby].depositedby = depositedby;  
        investorinfo[depositedby].deposited_at = block.timestamp;
        investorinfo[depositedby].releasetime = investorinfo[depositedby].deposited_at + 15 minutes;       

        uint256 numOfTokens = mintedtokens(investingamount);

        IToken(mindToken).mint(address(this), numOfTokens);

        tokenbalances[msg.sender]=tokenbalances[msg.sender].add(numOfTokens);
    }

    // Function for finding number of tokens that need to minted after depositing Ether

    function mintedtokens(uint256 amount) internal view returns(uint256){

        uint256 numberoftokens = amount.mul(tokenprice).div(1000000000000000000); 
        uint256 bonustokens;
        if(amount>1 ether && amount< 5 ether){
            bonustokens = numberoftokens.mul(10).div(100);
            numberoftokens+=bonustokens; 
        }
        else if(amount>5 ether){
            bonustokens = numberoftokens.mul(20).div(100);
            numberoftokens+=bonustokens; 
        }
        return numberoftokens;
    }

    //Function for cancelling investment

    function cancelInvestment() external {

        require(block.timestamp>=investorinfo[msg.sender].releasetime, "Funds can not be released before lock-in time");
        require(investorinfo[msg.sender].balances>0, "There is no ether to be withdrawn");
        require(tokenbalances[msg.sender]>0, "No investment has done earlier");

        address payable receiver = payable(msg.sender);
        receiver.transfer(investorinfo[msg.sender].balances);

        investorinfo[msg.sender].balances = 0; 
        investorinfo[msg.sender].releasetime = 0; 
        uint256 mtkBalance = tokenbalances[msg.sender];
        IToken(mindToken).burn(address(this), mtkBalance);
        tokenbalances[msg.sender]=tokenbalances[msg.sender].sub(mtkBalance);
    }

    function stakeInvestment() external{
        
        require(block.timestamp>=investorinfo[msg.sender].releasetime, "Lock-in period has not ended yet");
        require(investorinfo[msg.sender].balances>0, "There is no ether to be staked");
        require(tokenbalances[msg.sender]>0, "No investment has done earlier, Staking is not permitted");

        liquidityAddress.transfer(investorinfo[msg.sender].balances);

        IToken(mindToken).transfer(stakeAddress, tokenbalances[msg.sender]);

        investorinfo[msg.sender].balances = 0;
        tokenbalances[msg.sender] = 0; 
    }
}