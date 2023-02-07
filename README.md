# 🌱 Soft Smart Contract (Plantiverse)

- Contract address (Mumbai Testnet): 0x15009f785A681899D40cda06b321De9F800d5de7
- <a href="https://testnets.opensea.io/es/collection/plantiverse">OpenSea TestNet collection</a>

### Metadata endpoint

NFTs are pointing to a BASE URL -> cristianRicharte6.github.io/

Then we need to add the Token path -> metadata/<TOKEN ID>.json

**Example of BASE URL & Token Path concatenated:** <a href="cristianricharte6.github.io/metadata/0.json">cristianricharte6.github.io/metadata/0.json</a>

## More links:

- <a href="https://www.plantiver.se/">Plantiverse.se</a>

- <a href="https://docs.google.com/document/d/1d18uPIR33CRtEjJilKW2X8munxFJzUSGNtq1g_zMs38/edit">MWC Plantiverse Informe</a>

## Contract tested through:

- Remix. ✅
- Slither (Static Analyzer). ✅
- Solhint (Advance Linter). ✅
- Compatibility with Marketplaces. ✅

## Missing tests:

- Unit tests.
- Solidity coverage.

## Functions / Operations
**Getters and Read-only operations** 📖

- balanceOf: Getter for the entire number of NFTs assigned to a given address.
- getApproved: Verifies which Address, other than the owner, is permitted to administer the NFT.
- isApprovedForAll: Determines whether the Address X may control the NFT of the Address Y.
- mintingFee: Getter for the per-NFT minting fee.
- mintingStatus: Verifies whether the minting operations have been halted.
- Getter for the total number of NFTs minted, nFTsMinted.
- name: A project name getter.
- symbol: The project's symbol's getter.
- tokenURI: Gives the endpoint and token id concatenated back. Obtaining metadata
- ownerOf: Gives the address that owns the token Id X.
- supportsInterface: Internal call to see if an interface is supported. (Not helpful, but necessary)

**Setters and writing operations** ✍

- approve: Gives Address X permission to manage Token ID Y - mint - Use the minting function to create a single NFT.
- batchMinting: Minting function for several NFTs. (More Gas efficient)
- TransferFrom: Send NFT X from Address Y to Address Z using the transfer function.
- safeTransferFrom: Send NFT X from Address Y to Address Z using this transfer function. (Identical to the prior item, but required by standard)
- setApprovalForAll: Permit different addresses to control all NFTs.
- setMintingFee: Setter for the minting Fee to pay per NFT minted.
- setPauseContract: Setter to stop the minting functions.
- tranferOwnership: Setter for the Smart contract Owner.
- updateBaseURI: Setter to update the Base URI.
- withdraw: Withdraw function to withdraw X ETH (or native cryptocurrency) from the contract to Address X.
