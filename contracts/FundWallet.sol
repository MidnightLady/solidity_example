// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FundWallet {
    address public owner;

    struct Transaction {
        uint amount;
        uint time;
    }

    struct Payment {
        uint total;
        uint number;
        uint[] t_index;
    }

    struct Allowance {
        uint total;
        uint number;
        uint[] t_index;
    }

    struct Wallet {
        uint balance;
        Payment payment;
        Allowance allowance;
    }

    mapping(address => Transaction[]) public Transactions;
    mapping(address => Wallet) public Fund;

    constructor() payable{
        owner = msg.sender;
    }

    function addFund() public payable {
        Fund[msg.sender].balance += msg.value;
        Transaction memory tran = Transaction(msg.value, block.timestamp);
        Transactions[msg.sender].push(tran);
        Fund[msg.sender].payment.total += msg.value;
        Fund[msg.sender].payment.number += 1;
        Fund[msg.sender].payment.t_index.push(Transactions[msg.sender].length-1);
    }


    function getBalance() public view returns (uint){
        return address(this).balance;

    }

    function withdrawFund() public {
        address payable to = payable(msg.sender);
        to.transfer(getBalance());

    }

    receive() external payable {
        addFund();
    }


}