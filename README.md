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
```

## Testing & Verification Suite

Security and reliability are enforced through a rigorous, multi-layered testing environment powered by Foundry. The testing suite goes beyond standard unit tests to include property-based fuzzing and advanced cryptographic validations.

### Verification Highlights
* **Comprehensive Unit Testing:** Absolute state validation for all ERC-20 mechanics, including minting, burning, and Pausable access controls.
* **Property-Based Fuzzing:** Bounded and unbounded fuzz testing against transactional functions to guarantee mathematical integrity without overflow reversions.
* **EIP-2612 Cryptographic Signatures:** Full local reconstruction of `DOMAIN_SEPARATOR` and `structHash` logic to validate off-chain `permit` signatures and state transitions.
* **Custom Error Handling:** Strict validation of OpenZeppelin v5 custom error selectors (e.g., `OwnableUnauthorizedAccount`) for maximum gas efficiency during reverts.

### Continuous Integration (CI)
The repository implements a strict GitHub Actions pipeline. Every push and pull request automatically triggers:
1. Code formatting and style enforcement (`forge fmt`).
2. Contract compilation and size limit verification (`forge build --sizes`).
3. Deep state fuzzing across 10,000 algorithmic runs (`FOUNDRY_PROFILE=ci forge test`).

### Running the Tests Locally
To execute the test suite and view detailed gas consumption reports:

```bash
# Run standard test suite with gas reporting
forge test

# Run test suite with maximum verbosity for debugging
forge test -vvvv
```