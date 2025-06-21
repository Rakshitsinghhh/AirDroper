// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;


interface IReward {
    function mint(address account, uint256 amount) external;
}

contract Contract {
    IReward public rewardToken;

    constructor(address _rewardToken) {
        rewardToken = IReward(_rewardToken);
    }

    uint256 private _totalSupply;

    mapping(address => uint256) public stakedbalance;
    mapping(address => uint256) public unclaimedReward;
    mapping(address => uint256) public lastUpdated;

    // Stake ETH and start earning rewards
    function stake(uint256 val) public payable {
        require(val > 0, "Amount must be greater than 0");
        require(msg.value == val, "Amount must equal msg.value");

        // If already staked, update rewards
        if (lastUpdated[msg.sender] != 0) {
            uint newReward = (block.timestamp - lastUpdated[msg.sender]) * stakedbalance[msg.sender];
            unclaimedReward[msg.sender] += newReward;
        }

        lastUpdated[msg.sender] = block.timestamp;

        stakedbalance[msg.sender] += val;
        _totalSupply += val;
    }

    // Unstake ETH and update rewards
    function unstake(uint256 val) public {
        require(val <= stakedbalance[msg.sender], "Insufficient staked balance");

        // Update reward before changing balances
        uint newReward = (block.timestamp - lastUpdated[msg.sender]) * stakedbalance[msg.sender];
        unclaimedReward[msg.sender] += newReward;
        lastUpdated[msg.sender] = block.timestamp;

        stakedbalance[msg.sender] -= val;
        _totalSupply -= val;

        payable(msg.sender).transfer(val);
    }

    // View the total pending reward for a user
    function getReward(address _user) public view returns (uint256) {
        uint currentReward = unclaimedReward[_user];
        uint newReward = (block.timestamp - lastUpdated[_user]) * stakedbalance[_user];
        return currentReward + newReward;
    }

    // Claim rewards via ERC20 mint
    function claimReward() public {
        uint currentReward = unclaimedReward[msg.sender];
        uint newReward = (block.timestamp - lastUpdated[msg.sender]) * stakedbalance[msg.sender];
        uint totalReward = currentReward + newReward;

        require(totalReward > 0, "No rewards to claim");

        rewardToken.mint(msg.sender, totalReward);

        unclaimedReward[msg.sender] = 0;
        lastUpdated[msg.sender] = block.timestamp;
    }

    // Get total staked supply
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // Accept ETH
    receive() external payable {}
}
