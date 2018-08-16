pragma solidity ^0.4.22;

import "./evolvetitan.sol";

contract TitanHelper is EvolveTitan {
    
    uint levelUpFee = 0.3 ether;
    
    modifier aboveLevel(uint8 _level, uint _titanID) {
        require(titans[_titanID].level >= _level);
        _;
    }
    
    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }
    
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }
    
    function levelUp(uint _titanID) external payable {
        require(msg.value >= levelUpFee);
        if(msg.value > levelUpFee) {
        // refund any additional funds sent to the game
        msg.sender.transfer(msg.value - levelUpFee);
        titans[_titanID].level++;
        }
    }
    
    function changeName(uint _titanID, string _newName) external aboveLevel(10, _titanID) onlyOwnerOf(_titanID) {
        titans[_titanID].name = _newName;
    }
    
    function changeFeatureDNA(uint _titanID, uint _newDNA) external aboveLevel(25, _titanID) onlyOwnerOf(_titanID) {
        titans[_titanID].featureDNA = _newDNA;
    }
    
    function getTitansByPlayer(address _player) external view returns(uint[]) {
        uint[] memory titanList = new uint[](playerToTitans[_player]);
        uint count = 0;
        for (uint i = 0; i < titans.length; i++) {
            if (titanToPlayer[i] == _player) {
                titanList[count] = i;
                count++;
            }
        }
        return titanList;
    }
    
}