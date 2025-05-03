//pragma solidity >=0.8.2 <0.9.0;
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SMA {
    struct Art {
        uint256 id;
        string title;
        string nomArtist;
        bytes32 hashImage;
        address currantOwner;
    }
   
    mapping(uint256 => Art) public Arts;
    mapping(uint256 => address[]) public ownershipHistory;
    mapping(bytes32 => bool) private imageUsed;

    uint256[] public allArtworks;
    uint256 public  count;


    event ArtworkRegistered(uint256 id, string title, string artist, address owner);
    event OwnershipTransferred(uint256 id, address from, address to);
   
    //Register an art.
     function registerArt(string memory _title, string memory _nomArtist, bytes32  _hashImage) public {
        require(!imageUsed[_hashImage], "This image already exists");

        count++;
        Arts[count] = Art(count, _title, _nomArtist, _hashImage, msg.sender);
        ownershipHistory[count].push(msg.sender);
        imageUsed[_hashImage] = true;
        allArtworks.push(count); 
        emit ArtworkRegistered(count, _title, _nomArtist, msg.sender);
}


    function imageExiste(bytes32 _hashImage) public view returns (bool) {
        return imageUsed[_hashImage];
    }

    //Check if the sender is the currantOwner.
    function isOwner(uint256 _id) public view returns (bool){
        return Arts[_id].currantOwner == msg.sender;
    }

    
    //Return art by id .
   function getArt(uint256 _id) public view returns
        (string memory, string memory, bytes32, address){  
    if (_id == 0 || _id > count){
        return ("No art found", "0", '0x' , address(0));
       // throw Error("No art found");
        
    }      
    Art memory arr = Arts[_id];
    return (arr.title, arr.nomArtist, arr.hashImage, arr.currantOwner);
    }
    function checkArtsExiste() public view returns (string memory){
        if (count == 0){
            return ("No artworks available");
        }
        getAllArts();
        return ("Artworks found");
    }
    //Return all artworks if they exists else return an empty array.
    function getAllArts() public view returns (string memory, Art[] memory) {
        if (count == 0) {
            return ("No artworks available", new Art[](0) ); 
        }

        Art[] memory allArts = new Art[](allArtworks.length);
        for (uint256 i = 0; i < allArtworks.length; i++) {
            allArts[i] = Arts[allArtworks[i]];
         }
        return ("Artworks found", allArts);
    }

    //the owner can tranfer his ownership to another user.
    function transferOwnership(uint256 _id, address _newOwner) public {
        require(isOwner(_id), "Only the owner can transfer ownership");
        require(_newOwner != address(0), "Invalid new owner");
        address oldOwner = Arts[_id].currantOwner;
        Arts[_id].currantOwner = _newOwner;
        ownershipHistory[_id].push(_newOwner);
        emit OwnershipTransferred(_id, oldOwner, _newOwner);
    }
     function getOwnershipHistory(uint256 _id) public view returns (address[] memory) {
        return ownershipHistory[_id];
    }

    //Return an array contain all artist.
    function getAllArtist() public view returns (string[] memory){
        string[] memory allArts = new string[](allArtworks.length);
        for (uint256 i = 0; i < allArtworks.length; i++) {
            allArts[i] = Arts[i].nomArtist;
         }
        return  allArts;
    }

    

}