# PDash Contracts

![Test Coverage Badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/zgljl2012/676521a4ad619576708a8aad39a1eaaa/raw/pdash_contracts__heads_main.json)

PDash is a blockchain-based data sharing platform.

## Introduction

PDash(Parallel Distributed Architecture for Data Storage and Sharing) is a new architecture for blockchain systems, which aims to solve the scalability bottleneck at the data level, and makes it possible for user to keep ownership of their own data as well as share data securely with economic feedback. PDash integrates decentralized blockchain network and distributed storage network to achieve secure data storage, validation and sharing, and utilizes multiple encryption technologies to enable efficient interaction between two parallel distributed networks.

## Smart Contracts

+ Products: Publish or remove your products to all market
+ Trade: Buy or sell product
+ Evaluate: Evaluate a product
+ Reward: The liquidity incentive tokens for the PDash community

## PDash Token: The liquidity incentive tokens for the PDash community

PDT(PDash Token) is the liquidity incentive tokens for the PDash community.

## Extend Information

When creating a product, you should specify the name of the product, and you can specify the extended information. The extended information marshal to a JSON. The key field as below:

```json

{
    "description": "...",
    "download_uri": "uri://..."
}

```

The download-URI is very important. If your extended information does not include this field, the PDash-Server won't make it visible in the market.

When someone buys your product, you should send the decrypt information to him by encrypted chat.

The decrypt information marshals to a JSON too:

```json

{
    "algorithm": "AES",
    "pass": "..."
}

```

Now, we only support AES.
