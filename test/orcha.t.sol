// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/orcMint.sol";

contract TestContract is Test {
    Contract c;

    function setUp() public {
        c = new Contract();
    }

    function test() public view {
        assert(c.totalSupply()==0);
    }

    function testmint() public {
        uint before = c.totalSupply();
        c.mint(address(this),5);
        uint aftermint = c.totalSupply();
        require(aftermint == before + 5, "mint failed");
    }

    function testBurn() public{
        c.mint(address(this),5);

        uint before=c.totalSupply();
        c.burn(address(this),5);
        uint afterr = c.totalSupply();
        require(before == afterr + 5);
    }
}
