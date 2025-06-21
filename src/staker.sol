// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Contract{

    uint256 private _totalSupply;
    mapping(address=>uint256) public stakedbalance;
    mapping(address=>uint256) public unclaimedReward;
    mapping(address=>uint256) public lastUpdated;




    function stake(uint256 val) public payable{
        require(val > 0 , "amount must be greather then 0");
        require(msg.value == val, "Amount must be equal to msg.value");
        if(!lastUpdated[msg.sender])
        {
            lastUpdated[msg.sender]=block.timestamp;
        }
        else{

            uint currentReward = unclaimedReward[msg.sender];
            uint updateTime = lastUpdated[msg.sender];
            uint newReward = (block.timestamp - updateTime ) * stakedbalance[msg.sender]; 
            unclaimedReward[msg.sender] += newReward;
            lastUpdated[msg.sender]=block.timestamp; 

        }
        _totalSupply+=val;
        stakedbalance[msg.sender]+=val;
    }

    function unstake(uint val) public {
        require(val <= stakedbalance[msg.sender], "Insufficient staked balance");

        uint currentReward = unclaimedReward[msg.sender];
        uint updateTime = lastUpdated[msg.sender];
        uint newReward = (block.timestamp - updateTime ) * stakedbalance[msg.sender]; 
        unclaimedReward[msg.sender] += newReward;
        lastUpdated[msg.sender]=block.timestamp;
        
        
        _totalSupply -= val;
        stakedbalance[msg.sender] -= val;
        payable(msg.sender).transfer(val);
    }

    function getreward(address _address) public view returns (uint256){
        uint currentReward = unclaimedReward[_address];
        uint updateTime = lastUpdated[_address];
        uint newReward = (block.timestamp - updateTime ) * stakedbalance[_address];
        return currentReward + newReward;

    }

    function claimReward() public{
        uint currentReward = unclaimedReward[msg.sender];
        uint updateTime = lastUpdated[msg.sender];
        uint newReward = (block.timestamp - updateTime ) * stakedbalance[msg.sender];

        //transfer
        payable(msg.sender).transfer(currentReward+newReward);

        unclaimedReward[msg.sender]=0;
        lastUpdated[msg.sender]=block.timestamp;
    }

    function totalSupply() public view returns(uint){
        return _totalSupply;
    }
}
