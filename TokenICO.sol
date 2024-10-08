// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function name() external view returns (string memory);
}

contract TokenICO {
    address public owner;
    address public tokenAddress;
    uint256 public tokenSalePrice;
    uint256 public soldTokens;

    modifier onlyOwner() {
        require(msg.sender == owner, "not allowed to call");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function updateToken(address _tokenAddress) public onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function updateTokenSalePrice(uint256 _tokenSalePrice) public onlyOwner {
        tokenSalePrice = _tokenSalePrice;
    }

    function multiply(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function buyToken(uint256 token_amount) public payable {
        require(
            msg.value == multiply(tokenSalePrice, token_amount),
            "not enough amount"
        );
        ERC20 token = ERC20(tokenAddress);

        require(
            token_amount <= token.balanceOf(address(this)),
            "not enough token"
        );
        require(token.transfer(msg.sender, token_amount * 1e18));
        payable(owner).transfer(msg.value);
        soldTokens += token_amount;
    }

    function getTokenDetails()
        public
        view
        returns (
            string memory name,
            string memory symbol,
            uint256 balance,
            uint256 supply,
            uint256 tokenPrice,
            address tokenAddr
        )
    {
        ERC20 token = ERC20(tokenAddress);
        return (
            token.name(),
            token.symbol(),
            token.balanceOf(address(this)),
            token.totalSupply(),
            tokenSalePrice,
            tokenAddress
        );
    }

    function transferToOwner(uint256 _amount) external payable {
        require(msg.value >= _amount, "not enough amount sent");
        (bool s, ) = owner.call{value: _amount}("");
        require(s, "transfer failed");
    }

    function transferEther(
        address payable _reciever,
        uint256 _amount
    ) external payable {
        require(msg.value >= _amount, "not enough amount sent");
        (bool s, ) = _reciever.call{value: _amount}("");
        require(s, "transfer failed");
    }

    function withdrawAllTokens() public {
        ERC20 token = ERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "no tokens to withdraw");
        require(token.transfer(owner, balance), "failed to withdraw");
    }
}
