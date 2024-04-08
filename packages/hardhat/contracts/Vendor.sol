pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
	uint256 public constant tokensPerEth = 100;
	YourToken public yourToken;

	// event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

	event SellTokens(
		address seller,
		uint256 amountOfTokens,
		uint256 amountOfETH
	);

	constructor(address tokenAddress) {
		yourToken = YourToken(tokenAddress);
	}

	// ToDo: create a payable buyTokens() function:
	function buyTokens() public payable {
		require(msg.value > 0, "Value needs to be greater than 0");
		uint256 tokenAmount = msg.value * tokensPerEth;
		yourToken.transfer(msg.sender, tokenAmount);
		emit BuyTokens(msg.sender, msg.value, tokenAmount);
	}

	// ToDo: create a withdraw() function that lets the owner withdraw ETH
	function withdraw() public onlyOwner {
		payable(owner()).transfer(address(this).balance);
	}

	// ToDo: create a sellTokens(uint256 _amount) function:
	function sellTokens(uint256 _amount) public {
		require(_amount > 0, "Cannot sell 0 token");
		require(
			_amount <= yourToken.balanceOf(msg.sender),
			"Insufficient amount to sell"
		);
		yourToken.transferFrom(msg.sender, address(this), _amount);
		payable(msg.sender).transfer(_amount / 100);

		emit SellTokens(msg.sender, _amount, _amount / 100);
	}
}