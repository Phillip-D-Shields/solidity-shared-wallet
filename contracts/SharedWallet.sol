//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

// import the allowance contract from root directory
import "./Allowance.sol";

// SharedWallet contract inherits the imported Allowance contract
contract SharedWallet is Allowance {
    // create events that will emit infor when money is sent to or received from the wallet
    // indexed keyword makes the element searchable
    event MoneySent(address indexed _beneficiary, uint256 _amount);
    event MoneyReceived(address indexed _from, uint256 _amount);

    // function that allows a user to withdraw
    function withdrawMoney(address payable _to, uint256 _amount)
        public
        ownerOrAllowed(_amount)
    {
        require(
            // verifies that the amount to be withdrawn is not greater than the contracts current balance
            // address(this).balance returns the smart contracts current balance
            _amount <= address(this).balance,
            // error message if requirements are not met
            "Contract doesn't own enough money"
        );
        // if the sender is not the contract owner then reduce their allowance amount before the transfer, so the allowance hashtable holds updated allowance info for the user
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        // emit a log of info about the transfer
        emit MoneySent(_to, _amount);
        // transfer the amount
        _to.transfer(_amount);
    }

    //fallback function to receive money sent to the contract
    receive() external payable {
        // emit a log of who sent money and how much they sent
        emit MoneyReceived(msg.sender, msg.value);
    }

    // i dont get this function ... research
    function renounceOwnership() public override onlyOwner {
        revert("can't renounceOwnership here");
    }
}
