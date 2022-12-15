//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 favoriteNumber;
    bool favoriteBool;
    string public a = unicode"Hello 😃";
    enum gender {male, female, other}

    struct People {
        uint256 favoriteNumber;
        string name;
        gender gender;
    }


    mapping(string => People) public vault;

    function store(uint256 _favoriteNumber) external {
        favoriteNumber = _favoriteNumber;
    }


    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(string calldata _name, uint _number, uint _gen) public  {
        require(bytes(vault[_name].name).length == 0, 'Person is exist!');
        People memory person = People(_number, _name, gender(_gen));
        vault[_name] = person;
    }

    function editPerson2(string calldata _name, uint _number, uint _gen) public {
        require(bytes(vault[_name].name).length != 0, 'Person is not exist!');
        People memory person = People(_number, _name, gender(_gen));
        vault[_name] = person;
    }

}
