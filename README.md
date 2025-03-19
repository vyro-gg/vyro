| <img src="https://vyro-xyz.github.io/assets/vyro-small.png" alt="Vyro" width="60"> | VYRO |
|---|---|


**Vyro** is a decentralized engagement and advertising platform that enables brands, advertisers, and individuals to create incentivized engagement campaigns. Users earn rewards for completing verified tasks, such as social media interactions and content creation.

| [![Platform](https://img.shields.io/badge/Platform-EVM-blue?style=flat-square&logo=ethereum)]([https://](https://ethereum.org/en/developers/docs/evm/))  | [![License](https://img.shields.io/github/license/mtcxdev/AbstraNet?style=flat-square)](LICENSE)  | [![Contributors](https://img.shields.io/github/contributors/vyro-xyz/vyro?style=flat-square)](https://github.com/vyro-xyz/vyro/graphs/contributors) |
|---|---|---|

# Features
- **Vyro Engage** – Earn rewards for completing social media tasks.
- **Vyro Ads** – Transparent and efficient advertising for brands.
- **Non-Custodial Wallets** – Users retain full control over their funds.
- **Smart Contract-Based Rewards** – Automated and transparent payouts.
- **On-Chain Verification** – Ensures immutable task completion tracking.

# Roadmap
-  **->** MVP Development & Smart Contract Deployment
-  Frontend & User Dashboard
-  Testnet Launch & Security Audits
-  Mainnet Launch & Marketing Push
-  Ecosystem Expansion & Partnerships

# ⚡ Workflow
```mermaid
graph TD;
    subgraph Advertiser Flow
        A[Advertiser UI - Create Ad] --> B[Campaign Manager - Funds Contract]
        B --> C[Blockchain SC - Escrow & Funds]
        C --> D[$VIRAL Treasury - Holds Rewards]
    end

    subgraph User Engagement Flow
        E[User Engagement - Twitter, IG, YouTube, TikTok] --> F[Event Listener - Twitter, Reddit, Websites, APIs]
        F --> G[Oracle Service - Verifies Data & Sends TX]
        G --> H[Blockchain SC - Logs & Pays Users/Creators]
    end
    
    F -->|Data Feed| I[Data Processing & Fraud Check]
    I --> G
```
# Tokenomics
- **Total Supply:** 1B $VIRAL
- **Rewards Pool:** 40%
- **Marketing & Partnerships:** 20%
- **Development & Team:** 15%
- **Liquidity & Staking:** 15%
- **Reserve & Future Initiatives:** 10%

# Whitepaper
[**Read the Vyro Whitepaper**](https://vyro-xyz.github.io/assets/vyro-whitepaper-and-tokenomics.pdf)

# License
Vyro is licensed under the MIT License. See [LICENSE](LICENSE) for details.
