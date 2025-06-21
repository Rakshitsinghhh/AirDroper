
// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/staker.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TestContract is Test {
    Contract c;
    receive() external payable {}

    function setUp() public {
        c = new Contract();
    }

    function testStake() public{
        uint before = c.totalSupply();
        c.stake{value: 5}(5);
        uint afterr = c.totalSupply();
        require(afterr == before + 5);

    }

    function testUnStake() public {
        c.stake{value: 5}(5);

        uint beforeSupply = c.totalSupply();
        uint beforeBalance = address(this).balance;

        c.unstake(5); 

        uint afterSupply = c.totalSupply();
        uint afterBalance = address(this).balance;

        require(afterSupply + 5 == beforeSupply, "Unstake: total supply mismatch");
        require(afterBalance == beforeBalance + 5, "Unstake: ETH not received");
    }




}
