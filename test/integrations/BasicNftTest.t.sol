// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public user = makeAddr("user");
    string constant PUG = "ipfs://QmbknbhvGbgysXszfnUKRATrjnipJeFboAzxmpcio2KoNi";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(user);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(user) == 1);
        assert(keccak256(abi.encode(PUG)) == keccak256(abi.encode(basicNft.tokenURI(0))));
    }

    function testTokenCounterStartsAtZero() public view {
        assertEq(basicNft.getTokenCounter(), 0, "Token Counter should start at zero!");
    }

    function testMintIncrementsTokenCounter() public {
        uint256 initialTokenCounter = basicNft.getTokenCounter();
        vm.prank(user);
        basicNft.mintNft("ipfs://QmbknbhvGbgysXszfnUKRATrjnipJeFboAzxmpcio2KoNi");
        uint256 newTokenCounter = basicNft.getTokenCounter();
        assertEq(newTokenCounter, initialTokenCounter + 1, "Token Counter should increase after minting!");
    }

    function testTokenURIOverriddenFunction() public {
        vm.prank(user);
        string memory ipfsUri = "ipfs://QmbknbhvGbgysXszfnUKRATrjnipJeFboAzxmpcio2KoNi";
        basicNft.mintNft(ipfsUri);
        uint256 tokenId = basicNft.getTokenCounter() - 1;
        string memory uri = basicNft.tokenURI(tokenId);
        assertEq(uri, ipfsUri, "Token URI should become equal to IPFS URI");
    }

    function testRevertIfTokenIdDoesNotExist() public {
        vm.prank(user);
        // invalidTokenId is one greater than the last minted token ID, meaning it does not exist yet in the contract.
        uint256 invalidTokenId = basicNft.getTokenCounter() + 1; // this exists actually
        vm.expectRevert("ERC721: invalid token ID"); // Update the revert message to match the actual error
        basicNft.tokenURI(invalidTokenId);
    }
}
