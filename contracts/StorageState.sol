// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorageState {
    uint128 public u = 123; // slot 0
    bool public uu = true; // slot 0
    uint64 public uuu = 10; // slot 0
    uint256[19] public a;   // 19 slot: 1-19
    uint256[] public b; // slot 20
    uint24[] public c; // slot 21
    mapping(string => uint256) public m1; // slot 22
    string public str1; // slot 23
    bytes public b1; // slot 25
    bytes[] public asd;
    string[] public arr_m1;
    mapping(address => mapping(address => uint256)) public ee; // slot 23



    constructor() {
        a[0] = 10;
        a[1] = 11;
        b.push(111);
        b.push(222);
        b.push(333);
        b.push(444);

        c.push(1);
        c.push(2);
        c.push(3);
        c.push(4);
        c.push(5);
        c.push(6);
        c.push(7);
        c.push(8);
        c.push(9);
        c.push(10);
        c.push(11);
        c.push(12);
        b1 = "asdasdasdasdasd";
    }

    function add_mapping(string memory key, uint256 value) public {
        m1[key] = value;
        arr_m1.push(key);
    }
    function set_string(string memory str) public {
        str1 = str;
    }

}

contract StorageSlotFetch
{
    struct ThreeSlots
    {
        uint256 a;
        uint256 b;
        uint256 c;
    }

    address var0;
    uint256 var1;
    bytes32 var2;
    ThreeSlots var3;
    uint256 var4;

    function getStorageSlots() external pure returns (uint256[5] memory ret)
    {
        assembly {
            mstore(add(ret, 0), var0.slot)
            mstore(add(ret, 32), var1.slot)
            mstore(add(ret, 64), var2.slot)
            mstore(add(ret, 96), var3.slot)
            mstore(add(ret, 128), var4.slot)
        }
        return ret;
    }
}
