pragma solidity ^0.4.22;

import "./titanmaker.sol";

contract EvolveTitan is TitanMaker {
    
    event TitanEvolved(uint currentTitanID, uint newFeatureDNA);
    
    modifier onlyOwnerOf(uint _titanID) {
        require(msg.sender == titanToPlayer[_titanID]);
        _;
    }
    
    function _startWaitPeriod(Titan storage _titan) internal {
        _titan.timeToBattle = uint32(now + waitPeriod);
    }
    
    function _readyToFight(Titan storage _titan) internal view returns (bool) {
        return (_titan.timeToBattle <= now);
    }
    
    function fightAndEvolve(uint _titanID, uint _targetTitanDNA) internal onlyOwnerOf(_titanID) {
        Titan storage myTitan = titans[_titanID];
        require(_readyToFight(myTitan));
        _targetTitanDNA = _targetTitanDNA % featuresMod;
        uint evolvedTitanDNA = (myTitan.featureDNA + _targetTitanDNA) / 2;
    
        myTitan.featureDNA = evolvedTitanDNA;
        emit TitanEvolved(_titanID, evolvedTitanDNA);
        _startWaitPeriod(myTitan);
    }
}