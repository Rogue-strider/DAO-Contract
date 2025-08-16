# Decentralized Autonomous Organization (DAO) Smart Contract

## Overview
This Solidity smart contract implements a Decentralized Autonomous Organization (DAO) on the Ethereum blockchain. The DAO allows investors to contribute funds, vote on proposals, and manage shared resources collectively. The contract includes features for share management, proposal creation, voting, and fund transfers, ensuring secure and transparent governance.

## Features
- **Investor Contributions**: Users can contribute Ether to become investors, receiving shares proportional to their contribution.
- **Share Management**: Investors can redeem or transfer shares, with checks to ensure sufficient funds and investor status.
- **Proposal System**: The manager can create proposals for fund allocation, specifying a description, amount, and recipient.
- **Voting Mechanism**: Investors can vote on proposals based on their share count, with a quorum requirement for approval.
- **Proposal Execution**: Approved proposals can be executed by the manager, transferring funds to the specified recipient.
- **Transparency**: A function to view all proposals ensures transparency in the DAO's operations.

## Contract Details
- **Solidity Version**: `>=0.7.0 <0.9.0`
- **License**: MIT
- **Key Components**:
  - **Structs**:
    - `Proposal`: Stores proposal details (ID, description, amount, recipient, votes, end time, execution status).
  - **Mappings**:
    - `isInvestor`: Tracks investor status.
    - `numOfshares`: Tracks shares per investor.
    - `isVoted`: Records voting status per investor per proposal.
    - `withdrawlStatus`: Tracks withdrawal status (not currently used).
    - `proposals`: Maps proposal IDs to `Proposal` structs.
  - **State Variables**:
    - `totalShares`: Total shares issued.
    - `avaiableFund`: Available funds in the DAO.
    - `contributionTimeEnd`: Deadline for contributions.
    - `nextProposalId`: Tracks the next proposal ID.
    - `voteTime`: Duration for voting on proposals.
    - `quorum`: Minimum percentage of votes required for proposal approval.
    - `manager`: Address of the DAO manager.
  - **Modifiers**:
    - `onlyInvestor`: Restricts functions to investors.
    - `onlyManager`: Restricts functions to the manager.

## Functions
- **Constructor**: Initializes the DAO with contribution time, voting time, and quorum.
- `contribution()`: Allows users to contribute Ether and become investors.
- `redeemShare(uint amount)`: Enables investors to redeem shares for Ether.
- `transferShare(uint amount, address to)`: Allows investors to transfer shares to other investors.
- `createProposal(string description, uint amount, address payable receipient)`: Manager creates a proposal.
- `voteProposal(uint proposalId)`: Investors vote on proposals using their shares.
- `executeProposal(uint proposalId)`: Manager executes approved proposals, transferring funds.
- `_transfer(uint amount, address payable receipient)`: Internal function to transfer Ether.
- `ProposalList()`: Returns an array of all proposals for transparency.

## Usage
1. **Deploy the Contract**:
   - Set `_contributionTimeEnd` (in seconds), `_voteTime` (in seconds), and `_quorum` (percentage, 1-99).
   - Deploy using a tool like Remix or Hardhat.
2. **Contribute Funds**:
   - Call `contribution()` with Ether to become an investor.
3. **Manage Proposals**:
   - Manager creates proposals using `createProposal()`.
   - Investors vote using `voteProposal(proposalId)`.
   - Manager executes approved proposals with `executeProposal(proposalId)`.
4. **Share Management**:
   - Redeem shares with `redeemShare(amount)`.
   - Transfer shares with `transferShare(amount, to)`.

## Security Considerations
- **Access Control**: Uses `onlyInvestor` and `onlyManager` modifiers to restrict sensitive functions.
- **Time Constraints**: Enforces contribution and voting deadlines.
- **Fund Safety**: Checks available funds before transfers or redemptions.
- **Reentrancy Protection**: Implicitly mitigated by using `transfer()` for Ether transfers, which has a gas limit.
- **Recommendations**:
  - Audit the contract before deployment.
  - Test extensively on a testnet (e.g., Sepolia).
  - Consider adding events for better tracking of contributions, votes, and executions.

## Installation and Testing
1. **Prerequisites**:
   - Solidity compiler (`>=0.7.0 <0.9.0`).
   - Ethereum development environment (e.g., Remix, Hardhat, or Truffle).
2. **Steps**:
   - Clone this repository: `git clone <repository-url>`
   - Compile the contract using a Solidity compiler.
   - Deploy to a testnet or local blockchain (e.g., Ganache).
   - Interact with the contract using a frontend or scripts.
3. **Testing**:
   - Test contribution, voting, and execution flows.
   - Verify edge cases (e.g., insufficient funds, voting after deadline).

## Example Workflow
1. Deploy the contract with `contributionTimeEnd = 604800` (1 week), `voteTime = 86400` (1 day), and `quorum = 51`.
2. Investor A sends 10 ETH via `contribution()`, receiving 10 shares.
3. Manager creates a proposal to send 5 ETH to a recipient.
4. Investors vote on the proposal within 1 day.
5. If >51% of shares approve, the manager executes the proposal, transferring 5 ETH.

## License
This project is licensed under the MIT License. See the `SPDX-License-Identifier` in the contract for details.

## Contributing
Contributions are welcome! Please:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-branch`).
3. Commit changes (`git commit -m "Add feature"`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

## Contact
For questions or issues, please open an issue on GitHub or contact the repository maintainer.