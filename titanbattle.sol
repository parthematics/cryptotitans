pragma solidity ^0.4.22;

import "./titanhelper.sol";

contract TitanBattle is TitanHelper {
    uint randomNonce = 0;
    uint victoryProbability = 67;
    
    function bytesToUint(bytes b) public pure returns (uint256){
        uint256 number;
        for (uint i = 0; i < b.length; i++){
            number = number + uint(b[i]) * (2 ** (8 * (b.length - (i + 1))));
        }
        return number;
    }
    
    function randomNumGenerator(uint _modulus) internal returns(uint) {
        randomNonce++;
        return bytesToUint(abi.encodePacked(now, msg.sender, randomNonce)) % _modulus;
    }
    
    function fight(uint _titanID, uint _targetTitanID) external onlyOwnerOf(_titanID) {
        Titan storage myTitan = titans[_titanID];
        Titan storage enemy = titans[_targetTitanID];
        uint randProbability = randomNumGenerator(100);
        
        if (randProbability <= victoryProbability) {
            myTitan.numWins++;
            myTitan.level++;
            enemy.numLosses++;
            
            fightAndEvolve(_titanID, enemy.featureDNA);
        } else {
            myTitan.numLosses++;
            enemy.numWins++;
            _startWaitPeriod(myTitan);
        }
    }
}