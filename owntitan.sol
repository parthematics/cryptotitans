pragma solidity ^0.4.22;

import "./titanbattle.sol";
import "./erc721.sol";
import "./safemath.sol";

contract OwnTitan is TitanBattle, ERC721 {
    
    using SafeMath for uint256;
    
    mapping (uint => address) approvedTitans;
    
    function balanceOf(address _owner) public view returns (uint _balance) {
        return playerToTitans[_owner];
    }
    
    function ownerOf(uint _titanID) public view returns (address _owner) {
        return titanToPlayer[_titanID];
    }
    
    function _transfer(address _from, address _to, uint _titanID) private {
        playerToTitans[_to] = playerToTitans[_to].add(1);
        playerToTitans[msg.sender] = owner[msg.sender].sub(1);
        titanToPlayer[_titanID] = _to;
        Transfer(_from, _to, _titanID);
    }
    
    function transfer(address _to, uint _titanID) public onlyOwnerOf(_titanID) {
        _transfer(msg.sender, _to, _titanID);
    }
    
    function approve(address _to, uint _titanID) public onlyOwnerOf(_titanID) {
        approvedTitans[_titanID] = _to;
        Approval(msg.sender, _to, _titanID);
    }
    
    function takeOwnershipOfTitan(uint _titanID) public {
        require(approvedTitans[_titanID] == msg.sender);
        address owner = ownerOf(_titanID);
        _transfer(owner, msg.sender, _titanID);
    }
}