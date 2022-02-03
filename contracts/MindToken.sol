// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MindToken is ERC20 {
    uint256 constant decimal = 10**18;
    uint256 createTime;
    address owner;

    event Mint(address indexed _to, uint256 _value);
    event Burn(address indexed _to, uint256 _value);

    /**
     * @notice The constructor for the MindToken contract.
     */
    constructor() ERC20("MINDPAY", "MTK") {
        _mint(msg.sender, 1000 * decimal);
        createTime = block.timestamp;
        owner = msg.sender;
    }
    function mint(address _to, uint256 _value) public {
        _mint(_to, _value);
        emit Mint(_to, _value);
    }

    function burn(address _from, uint256 _value) public {
        _burn(_from, _value);
        emit Burn(_from, _value);
}

}