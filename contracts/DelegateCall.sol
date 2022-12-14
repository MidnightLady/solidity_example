// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract_addr, uint _num) public payable  {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract_addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

    }
}

contract C {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract_addr, uint _num) public payable returns (bytes memory){
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract_addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        return data;
    }
}