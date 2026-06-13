// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Test } from "forge-std/Test.sol";
import { AssetToken } from "../src/AssetToken.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Pausable } from "@openzeppelin/contracts/utils/Pausable.sol";

//OpenZeppelin v5 Custom Errors
// error OwnableUnauthorizedAccount(address account);
// error EnforcedPause();

contract AssetTokenTest is Test {
    AssetToken public token;

    address public owner;
    address public user = makeAddr("user");

    uint256 public ownerPrivateKey;

    function setUp() public {
        (owner, ownerPrivateKey) = makeAddrAndKey("owner");
        token = new AssetToken(owner);
    }

    function test_InitialState() public view {
        assertEq(token.name(), "AssetToken");
        assertEq(token.symbol(), "AST");
        assertEq(token.decimals(), 18);
        assertEq(token.owner(), owner);
        // Check initial supply minted to owner (10,000,000 * 10^18)
        uint256 expectedSupply = 10_000_000 * 10 ** 18;
        assertEq(token.totalSupply(), expectedSupply);
        assertEq(token.balanceOf(owner), expectedSupply);
    }

    //mint
    function testFuzz_MintAsOwner(address to, uint256 amount) public {
        vm.assume(to != address(0)); //standard ERC20 should't mint to zero address

        uint256 initialSupply = token.totalSupply();
        uint256 initialBalance = token.balanceOf(to);

        amount = bound(amount, 0, type(uint256).max - initialSupply); // scop value fuzz

        vm.prank(owner);
        token.mint(to, amount);

        assertEq(token.totalSupply(), initialSupply + amount);
        assertEq(token.balanceOf(to), initialBalance + amount);
    }

    function testRevert_MintNotOwner() public {
        // OpenZeppelin custom error
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, user)
            //OpenZeppelin v5 Custom Errors
            // abi.encodeWithSelector(
            //     OwnableUnauthorizedAccount.selector,
            //     hacker
            // )
        );

        vm.prank(user);
        token.mint(user, 1000);
    }

    //pausble
    function test_PauseAndUnpause() public {
        assertFalse(token.paused());

        vm.prank(owner);
        token.pause();
        assertTrue(token.paused());

        vm.prank(owner);
        token.unpause();
        assertFalse(token.paused());
    }

    function testRevert_PauseNotOwner() public {
        assertFalse(token.paused());
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, user));
        vm.prank(user);
        token.pause();
    }

    function testRevert_TransfersBlockedWhenPaused() public {
        vm.prank(owner);
        token.pause();
        vm.expectRevert(abi.encodeWithSelector(Pausable.EnforcedPause.selector));
        //OpenZeppelin v5 Custom Errors
        // vm.expectRevert(EnforcedPause.selector);
        vm.prank(owner);
        token.transfer(user, 1000);
    }

    function testRevert_MintBlockedWhenPaused() public {
        vm.prank(owner);
        token.pause();
        vm.expectRevert(abi.encodeWithSelector(Pausable.EnforcedPause.selector));
        vm.prank(owner);
        token.mint(user, 1000);
    }

    //burning
    function testFuzz_Burn(uint256 amount) public {
        amount = bound(amount, 0, token.balanceOf(owner));
        uint256 initialSupply = token.totalSupply();
        uint256 initialBalance = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(amount);

        assertEq(token.totalSupply(), initialSupply - amount);
        assertEq(token.balanceOf(owner), initialBalance - amount);
    }

    //permit (EIP-2612)
    function test_Permit() public {
        uint256 amount = 1000 * 10 ** 18;
        uint256 deadline = block.timestamp + 1 hours;

        // 1. Get the domain separator and construct the EIP-712 struct hash
        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                owner,
                user,
                amount,
                token.nonces(owner),
                deadline
            )
        );

        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", token.DOMAIN_SEPARATOR(), structHash));

        // 2. Sign the digest using the owner's private key
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        // 3. Execute the permit (Anyone can call this, usually a relayer or the spender)
        token.permit(owner, user, amount, deadline, v, r, s);

        assertEq(token.allowance(owner, user), amount);
    }
}
