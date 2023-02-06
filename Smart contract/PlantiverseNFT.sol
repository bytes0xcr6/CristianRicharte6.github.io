// SPDX-License-Identifier: Unlicense

pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract PlantiverseNFT is ERC721URIStorage{

    // ERC721URIStorage tracks token URI.
    address private owner;
    string private baseURI; // Plantiverse.github.io/metadata/
    uint private nFTcounter; // First NFT minted will be 0.
    bool public mintingStatus;
    uint public mintingFee;

    event NFTMinted(address minter, uint nftId, uint mintingTime);
    event mintingFeeUpdated(uint newMintingFee, uint updateTime);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event BaseURIUpdated(string newBaseURI, uint updateTime);
    event PausedContract(bool contractStatus, uint updateTime);
    event UnpauseContract(bool contractStatus, uint updateTime);




    modifier onlyOwner{
        require(msg.sender == owner, "You are not the Owner");
        _;
    }

    constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_){
        owner = msg.sender;
        baseURI = baseURI_;
    }
    
    // 72.721 gas
    // Minting function
    function mint() external payable returns(bool){
        require(!mintingStatus, "Minting is paused");
        require(msg.value == mintingFee, "Pay minting Fee");
        _mint(msg.sender, nFTcounter);
        emit NFTMinted(msg.sender, nFTcounter, block.timestamp);
        nFTcounter++;
        return true;
    }

    // 1-      73.663 gas (Not it is not allowed)
    // 2-     105.899 gas
    // 3-     138.136 gas
    // 5-     202.610 gas
    // 10-    363.794 gas
    // 100- 3.265.106 gas // Each NFT minted costs 32.651
    // Batch Minting function
    function batchMinting(uint amount) external payable returns(bool) {
        require(amount > 1, "Mint more than 1 NFT");
        require(!mintingStatus, "Minting is paused");
        require(msg.value == amount * mintingFee, "Pay mintingFee");
        for(uint i; i < amount; i++) {
            _mint(msg.sender, nFTcounter);
            emit NFTMinted(msg.sender, nFTcounter, block.timestamp);
            nFTcounter++;
        }
        return true;
    }

    /** 
     * @dev This function will stop or reanude the minting function
     * @param status: Pause or Unpause minting new NFTs.
     *
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

    function setMintingFee(uint _mintingFee) external onlyOwner returns(bool) {
        mintingFee == _mintingFee;
        emit mintingFeeUpdated(_mintingFee, block.timestamp);
        return true;
    }

    // Function to update baseURI
    function updateBaseURI(string memory _newBaseURI) external onlyOwner returns(bool) {
        baseURI = _newBaseURI;

        emit BaseURIUpdated(_newBaseURI, block.timestamp);
        return true;
    }

    // // Burning function
    // function burn() external onlyOwner returns(bool){
    //     return true;
    // }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     * @param newOwner: New contract Owner to set.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view override(ERC721URIStorage) returns (string memory) {
        return string(abi.encodePacked(ERC721URIStorage.tokenURI(tokenId),".json"));
    }

    /**
     * @dev Returns the total amount of tokens minted in the contract.
     */
    function totalNFTsMinted() external view returns(uint) {
        return nFTcounter;
    }


    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}

    /** 
     * 
     *
     *
     */