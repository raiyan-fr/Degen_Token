// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
// Transferring tokens: Players should be able to transfer their tokens to others.
// Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// Checking token balance: Players should be able to check their token balance at any time.
// Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        //give msg.sender an initial supply of 10
        _mint(msg.sender,10);
        // Initialize the store with 20 Gem Stones.
        initializeStore();
    }

     function MintTokens(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    } 

    function decimals() override public pure returns (uint8) {
        return 0;
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
        _burn(msg.sender, _value);
    }

    // define a struct to hold GemStone info
    struct GemStones {
        string name;
        uint256 price;
        bool available;
    }

    mapping(uint256 => GemStones) public PriceAndAvailability;

    function initializeStore() private {
        string[20] memory StoneNames = [
            "Ruby", "Diamond", "Emerald", "Sapphire", "Pearl", "Lapis Lazuli", "Jade", "Spinel", "Topaz", "Aquamarine", 
            "Coral", "Amber", "Jasper", "Sunstone", "Moonstone", "Amethyst", "Garnet", "Alexandrite", "Opal", "Rhodolite"
        ];

        for (uint256 i = 1; i <= 20; i++) {
            uint256 price = uint256(keccak256(abi.encodePacked(block.timestamp, i))) % 21 + 10;
            PriceAndAvailability[i] = GemStones(StoneNames[i - 1], price, true);
        }
    }
    // Define a struct to hold item information
    struct ItemInfo {
        uint256 itemNumber;
        string itemName;
    }

    function getItemList() public view returns (ItemInfo[] memory) {
        ItemInfo[] memory availableItems = new ItemInfo[](20);

        for (uint256 i = 1; i <= 20; i++) {
            if (PriceAndAvailability[i].available) {
                availableItems[i - 1] = ItemInfo(i, PriceAndAvailability[i].name);
            }
        }
        return availableItems;
    }

    mapping(address => uint256[]) private ownedItems;

    function getOwnedItems() external view returns (ItemInfo[] memory) {
        uint256[] storage userOwnedItems = ownedItems[msg.sender];
        ItemInfo[] memory items = new ItemInfo[](userOwnedItems.length);

        for (uint256 i = 0; i < userOwnedItems.length; i++) {
            uint256 itemNumber = userOwnedItems[i];
            items[i] = ItemInfo(itemNumber, PriceAndAvailability[itemNumber].name);
        }

        return items;
    }

    function redeemTokens(uint256 itemNumber) external payable returns (bool) {
        require(balanceOf(msg.sender) >= PriceAndAvailability[itemNumber].price, "Insufficient balance");
        require(itemNumber >= 1 && itemNumber <= 20, "Invalid item number");
        require(PriceAndAvailability[itemNumber].available, "Item not available");

        // Implement your logic to transfer the item to the user here.
        // Ensure that you transfer the item to msg.sender.

        // Mark the item as unavailable
        PriceAndAvailability[itemNumber].available = false;

        // Add the item to the user's owned items
        ownedItems[msg.sender].push(itemNumber);

        // Burn the tokens used for the purchase.
        _burn(msg.sender, PriceAndAvailability[itemNumber].price);

        return true;
    }
}