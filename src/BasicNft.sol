// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;

    mapping(uint256 => string) private s_tokenIdToUri;
    mapping(uint256 => bool) private s_mintedTokens;

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return s_mintedTokens[tokenId];
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        s_mintedTokens[s_tokenCounter] = true;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721: invalid token ID");
        return "ipfs://QmbknbhvGbgysXszfnUKRATrjnipJeFboAzxmpcio2KoNi";
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
