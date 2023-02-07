// SPDX-License-Identifier: Unlicense

pragma solidity 0.8.18;
// @author Plantiverse (Cristian Richarte Gil)
// @title Plantiverse NFT collection

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

interface IPlantiverseNFT {
    function mint() external payable;
    function batchMinting(uint256 amount) external payable;
}

contract PlantiverseNFT is IPlantiverseNFT, ERC721URIStorage{

    address private owner;
    string private baseURI; // Example: https://cristianricharte6.github.io/metadata/
    uint256 public nFTsMinted; // First NFT minted will be 0.
    uint256 public mintingFee;
    bool public mintingStatus; // True = Paused | False = Unpaused
    bool internal locked; // Reentracy guard

    event NFTMinted(address indexed minter, uint256 nftId, uint256 mintingTime);
    event FundsWithdrawn(address indexed caller, address indexed to, uint256 amount, uint256 updateTime);
    event MintingFeeUpdated(uint256 newMintingFee, uint256 updateTime);
    event PausedContract(bool contractStatus, uint256 updateTime);
    event UnpauseContract(bool contractStatus, uint256 updateTime);
    event BaseURIUpdated(string newBaseURI, uint256 updateTime);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner{
        require(msg.sender == owner, "You are not the Owner");
        _;
    }

    modifier reentrancyGuard {
        require(locked == true);
        locked = true;
        _;
        locked = false;
    }

    /** 
     * @param name_: NFT Collection Name. (Plantiverse)
     * @param symbol_: NFT Collection Symbol. (PLANT)
     * @param baseURI_: Base URI where the NFTs Metadata is Stored.
     */
    constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_){
        owner = msg.sender;
        baseURI = baseURI_;
    }
    
    /** 
     * @dev Individual minting function. It will mint only 1 NFT per call.
     * @notice NFTs minted / gas used
     * 1 - 72.362 gas 
     */
    function mint() external payable{
        require(!mintingStatus, "Minting is paused");
        require(msg.value == mintingFee, "Pay minting Fee");
        _mint(msg.sender, nFTsMinted);
        emit NFTMinted(msg.sender, nFTsMinted, block.timestamp);
        ++nFTsMinted;
    }


    /** 
     * @dev Batch minting function. It will mint any amount of NFTs higher than 1.
     * @param amount: Number of NFTs we want to mint.
     * @notice NFTs minted / gas used
     * 2 -     104.348 gas // Each NFT minted costs 52.174 gas
     * 3 -     135.792 gas // Each NFT minted costs 45.264 gas
     * 5 -     198.681 gas // Each NFT minted costs 39.736 gas
     * 10 -    355.904 gas // Each NFT minted costs 35.590 gas
     * 100 - 3.185.904 gas // Each NFT minted costs 31.859 gas
     */
    function batchMinting(uint256 amount) external payable{
        require(amount > 1, "Mint more than 1 NFT");
        require(!mintingStatus, "Minting is paused");
        require(msg.value == amount * mintingFee, "Pay mintingFee");
        uint256 memoryCount = nFTsMinted;
        for(uint256 i; i < amount;) {
            _mint(msg.sender, memoryCount);
            emit NFTMinted(msg.sender, memoryCount, block.timestamp);

            unchecked {
                ++i;
                ++memoryCount;
            } 
        }
        nFTsMinted = memoryCount;
    }

    /** 
     * @dev Withdraw function
     * @param to: Address to send the value from the Smart contract.
     * @param amount: Total amount to transfer.
     */
    function withdraw(address payable to, uint256 amount) external payable onlyOwner reentrancyGuard returns(bool) {
        require(to != address(0), "Not a valid address");
        (to).transfer(amount);
        emit FundsWithdrawn(msg.sender, to, amount, block.timestamp);
        return true;
    }

    /** 
     * @dev Setter function to stop or reanude the minting function
     * @param status: Pause or Unpause minting new NFTs.
     */
    function setPauseContract(bool status) external onlyOwner{
        mintingStatus = status;

        if(status == true) {
            emit PausedContract(status, block.timestamp);
        }else {
            emit UnpauseContract(status, block.timestamp);
        }
    } 

    /** 
     * @dev Setter for Minting Fee.
     * @param newMintingFee: New Minting Fee to set.
     */
    function setMintingFee(uint256 newMintingFee) external onlyOwner{
        mintingFee = newMintingFee;
        emit MintingFeeUpdated(newMintingFee, block.timestamp);
    }

    /**
     * @dev Setter for Base URI.
     * @param newBaseURI: New Base URI to set.
     */
    function updateBaseURI(string memory newBaseURI) external onlyOwner{
        baseURI = newBaseURI;

        emit BaseURIUpdated(newBaseURI, block.timestamp);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     * @param newOwner: New contract Owner to set.
     */
    function transferOwnership(address newOwner) external onlyOwner{
        require(newOwner != address(0), "Not a valid address");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev Getter for a concatenated string of base URI + Token URI + file extension.
     * @param _tokenId: NFT Id.
     */
    function tokenURI(uint256 _tokenId) public view override(ERC721URIStorage) returns (string memory) {
        return string(abi.encodePacked(ERC721URIStorage.tokenURI(_tokenId),".json"));
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * @dev Receive function to allow the contract receive ETH.
     */
    receive() external payable {}
}