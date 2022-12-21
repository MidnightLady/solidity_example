// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin4.8.0/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin4.8.0/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin4.8.0/contracts/utils/Context.sol";


contract AirdropToken is IERC20, IERC20Metadata {
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;


    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
        _mint(msg.sender, 1000000000000000000);
    }
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    modifier validAddress(address addr) {
        require(addr != address(0), "ERC20: Not valid address");
        _;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
    unchecked {_approve(owner, spender, currentAllowance - subtractedValue);}

        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal validAddress(from) validAddress(to) {

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
    unchecked {
        // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
        // decrementing then incrementing.
        _balances[from] = fromBalance - amount;
        _balances[to] += amount;
    }
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
    unchecked {
        // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
        _balances[account] += amount;
    }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
        _balances[account] = accountBalance - amount;
        // Overflow not possible: amount <= accountBalance <= totalSupply.
        _totalSupply -= amount;
    }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
        unchecked {
            _approve(owner, spender, currentAllowance - amount);
        }
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {}

    function _afterTokenTransfer(address from, address to, uint256 amount) internal {}
}


contract TokenVault {
    // sender : token: amount
    mapping(address => mapping(address => uint256)) public vault;
    mapping(address => bool) valid_token;

    constructor(address token) {
        valid_token[token] = true;
    }
    event Received(address from, address token, uint amount, uint total);

    function receiveToken(address token_addr, uint amount) public {
        emit Received(msg.sender, token_addr, amount, vault[msg.sender][token_addr]);

        require(valid_token[token_addr] == true, 'token is not allow');
        require(amount > 0, 'amount is not valid');

        bool result = IERC20(token_addr).transferFrom(msg.sender, address(this), amount);

        //        (bool success, bytes memory data) = token_addr.call(
        //            abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), amount));

        if (result) {
            vault[msg.sender][token_addr] += amount;
        }
    }
}

//t.approve(v.address,1000000,{'from':a0})
