//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

// import Ownable from openzeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// contract allowance inherits from imported Ownable contract
contract Allowance is Ownable {
    // create an event that emits import info regarded allowance changes
    // indexed keyword allows element to be searched later
    event AllowanceChanged(
        address indexed _forWho,
        address indexed _byWhom,
        uint256 _oldAmount,
        uint256 _newAmount
    );
    // create a hash table for users and their allowance
    mapping(address => uint256) public allowance;

    // function to return true or false if the tsx sender is the contract owner
    function isOwner() internal view returns (bool) {
        // owner() is an inherited function from Ownable contract
        return owner() == msg.sender;
    }

    // function to set the allowance for different users
    function setAllowance(address _who, uint256 _amount) public onlyOwner {
        // emit a log that stores the info related to the allowance being modified
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        // set the new allowance for the designated user in the allowance hashtable
        allowance[_who] = _amount;
    }

    // create a modifier that verifies the tsx sender is either the owner or the amount requested is within a users allowed amount
    modifier ownerOrAllowed(uint256 _amount) {
        require(
            // isOwner() == true || the allowance amount for the user is greater or equal to the amount being requested
            isOwner() || allowance[msg.sender] >= _amount,
            // followed by the error string message if the requirements are not met
            "You are not allowed!"
        );
        _;
    }

    // function to reduce the allowance of a specific user
    function reduceAllowance(address _who, uint256 _amount)
        internal
        ownerOrAllowed(_amount)
    {
        // emit a log that stores the info related to the allowance being reduced
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        // reduce the allowance of a user in the allowance hashtable
        allowance[_who] -= _amount;
    }
}
