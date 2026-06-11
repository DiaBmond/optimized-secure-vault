# Optimized Secure Vault

Optimized Secure Vault is a production-grade, high-performance, and ultra-secure Ethereum asset management protocol. It enables users to securely deposit native Ether or custom ERC-20 tokens, lock assets under time-bound constraints, and execute highly efficient batch operations.

The principal objective of this repository is to demonstrate an absolute mastery of the Ethereum Virtual Machine (EVM) architecture. Built utilizing Foundry, this project showcases:

* **Deep EVM Knowledge:** Precise handling and applied learning of EVM opcodes, stack variables, memory, storage, and calldata.
* **Advanced Gas Optimization:** Highly optimized smart contract logic designed to minimize transaction costs while maintaining strict structural integrity and code readability.
* **Rigorous Security:** Multi-layered security patterns, featuring robust reentrancy guards and safe asset management handling.
* **Custom Token Standard:** Creation and integration of a high-performance, foundational ERC-20 token standard.

This repository stands as a comprehensive showcase of advanced EVM mechanics, secure smart contract architecture, and production-ready Web3 engineering.

---

## Architecture: AssetToken (AST)

To rigorously test the vault's multi-asset custody capabilities, this repository includes `AssetToken`, a fully featured, standard-compliant ERC-20 mock contract. 

Rather than a basic implementation, `AssetToken` inherits from OpenZeppelin's upgradeable and standard suites to provide a production-like environment, including EIP-2612 permit capabilities for gasless approvals.

### Core Extensions
* `ERC20Burnable`: Allows token destruction for deflationary testing.
* `ERC20Pausable`: Enables emergency halting of token transfers by the owner.
* `ERC20Permit`: Supports offline off-chain signature approvals (EIP-2612).
* `Ownable`: Restricts critical administrative functions (minting, pausing).

### Installation & Setup
The project relies on standard Foundry submodules for dependencies.

```bash
# Install required OpenZeppelin libraries
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-foundry-upgrades --no-commit
forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit

# Generate standard remappings
forge remappings > remappings.txt