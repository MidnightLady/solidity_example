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
    mapping(address => Transaction[]) public Fund;
    mapping(address => Wallet) public Fund;

    constructor() payable{
        owner = msg.sender;
    }

    function addFund() public payable {
        Fund[msg.sender].total += msg.value;
        Fund[msg.sender].number += 1;
        Transaction memory trans = Transaction(msg.value, block.timestamp);
        tx2[msg.sender].push(trans);
        Fund[msg.sender].tx1.push(trans);
    }


    function getBalance() public view returns (uint){
        return address(this).balance;

    }

    function getTransaction1() public view returns (Transaction[] memory){
        Transaction[] memory t = Fund[msg.sender].tx1;
        return t;
    }
    function deleteTrans(uint _index) public {
        Transaction[] storage tran = Fund[msg.sender].tx1;
        tran[_index] = tran[tran.length - 1];
        tran.pop();
    }

    function withdrawFund() public {
        address payable to = payable(msg.sender);
        to.transfer(getBalance());

    }

    fallback() external payable {
        addFund();
    }


}