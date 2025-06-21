// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Contract is ERC20{

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor() ERC20("orca","orc"){}

    function mint(address account,uint256 amount) public{
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public{
        _burn(account,amount);
    }
    
}
