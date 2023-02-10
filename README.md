# Unic NFT Collection with Upgradable metadata, having the Metadata End point in a local host.

- Contract address (Mumbai Testnet): 0x15009f785A681899D40cda06b321De9F800d5de7
- <a href="https://testnets.opensea.io/es/collection/plantiverse">OpenSea TestNet collection</a>

### Metadata endpoint

NFTs are pointing to a BASE URL -> cristianRicharte6.github.io/

Then we need to add the Token path -> metadata/<TOKEN ID>.json

**Example of BASE URL & Token Path concatenated:** <a href="cristianricharte6.github.io/metadata/0.json">cristianricharte6.github.io/metadata/0.json</a>

## Contract tested through:

- Remix. ✅
- Slither (Static Analyzer). ✅
- Solhint (Advance Linter). ✅
- Compatibility with Marketplaces. ✅

## Missing tests:

- Unit tests.
- Solidity coverage.
