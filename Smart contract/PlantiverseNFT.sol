// SPDX-License-Identifier: Unlicense

pragma solidity 0.8.18;
// @author Plantiverse (Cristian Richarte Gil)
// @title Plantiverse NFT collection


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

interface IPlantiverseNFT {
    function mint() external payable returns(bool);
    function batchMinting(uint amount) external payable returns(bool);
}

contract PlantiverseNFT is IPlantiverseNFT, ERC721URIStorage{

    address private owner;
    string private baseURI; // Example: cristianricharte6.github.io/metadata/
    uint public nFTsMinted; // First NFT minted will be 0.
    uint public mintingFee;
    bool public mintingStatus;
    bool public locked; // Reentracy guard

    event NFTMinted(address indexed minter, uint nftId, uint mintingTime);
    event FundsWithdrawn(address indexed caller, address indexed to, uint amount, uint updateTime);
    event MintingFeeUpdated(uint newMintingFee, uint updateTime);
    event PausedContract(bool contractStatus, uint updateTime);
    event UnpauseContract(bool contractStatus, uint updateTime);
    event BaseURIUpdated(string newBaseURI, uint updateTime);
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
     * 1 - 72.721 gas 
     */
    function mint() external payable returns(bool){
        require(!mintingStatus, "Minting is paused");
        require(msg.value == mintingFee, "Pay minting Fee");
        _mint(msg.sender, nFTsMinted);
        emit NFTMinted(msg.sender, nFTsMinted, block.timestamp);
        nFTsMinted++;
        return true;
    }


    /** 
     * @dev Batch minting function. It will mint any amount of NFTs higher than 1.
     * @param amount: Number of NFTs we want to mint.
     * @notice NFTs minted / gas used
     * 1 -      73.663 gas (Not it is not allowed)
     * 2 -     105.899 gas
     * 3 -     138.136 gas
     * 5 -     202.610 gas
     * 10 -    363.794 gas
     * 100 - 3.265.106 gas // Each NFT minted costs 32.651
     */
    function batchMinting(uint amount) external payable returns(bool) {
        require(amount > 1, "Mint more than 1 NFT");
        require(!mintingStatus, "Minting is paused");
        require(msg.value == amount * mintingFee, "Pay mintingFee");
        for(uint i; i < amount; i++) {
            _mint(msg.sender, nFTsMinted);
            emit NFTMinted(msg.sender, nFTsMinted, block.timestamp);
            nFTsMinted++; // set memory and once finished set storage.
        }
        return true;
    }

    /** 
     * @dev Withdraw function
     * @param to: Address to send the value from the Smart contract.
     * @param amount: Total amount to transfer.
     */
    function withdraw(address payable to, uint amount) external payable onlyOwner reentrancyGuard returns(bool) {
        require(to != address(0), "Not a valid address");
        (to).transfer(amount);
        emit FundsWithdrawn(msg.sender, to, amount, block.timestamp);
        return true;
    }

    /** 
     * @dev Setter function to stop or reanude the minting function
     * @param status: Pause or Unpause minting new NFTs.
     */
    function setPauseContract(bool status) external onlyOwner returns(bool) {
        mintingStatus = status;

        if(status == true) {
            emit PausedContract(status, block.timestamp);
        }else {
            emit UnpauseContract(status, block.timestamp);
        }

        return true;
    } 

    /** 
     * @dev Setter for Minting Fee.
     * @param newMintingFee: New Minting Fee to set.
     */
    function setMintingFee(uint newMintingFee) external onlyOwner returns(bool) {
        mintingFee = newMintingFee;
        emit MintingFeeUpdated(newMintingFee, block.timestamp);
        return true;
    }

    /**
     * @dev Setter for Base URI.
     * @param newBaseURI: New Base URI to set.
     */
    function updateBaseURI(string memory newBaseURI) external onlyOwner returns(bool) {
        baseURI = newBaseURI;

        emit BaseURIUpdated(newBaseURI, block.timestamp);
        return true;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     * @param newOwner: New contract Owner to set.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Not a valid address");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev Getter for a concatenated string of base URI + Token URI + file extension.
     * @param tokenId: NFT Id.
     */
    function tokenURI(uint256 tokenId) public view override(ERC721URIStorage) returns (string memory) {
        return string(abi.encodePacked(ERC721URIStorage.tokenURI(tokenId),".json"));
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