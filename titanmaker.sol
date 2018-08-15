pragma solidity ^0.4.22;

import "./ownable.sol";
import "./safemath.sol";

contract TitanMaker is Ownable {
    
    using SafeMath for uint256;
    
    event NewTitan(uint titanID, string name, uint featureDNA);
    
    uint featureDigits = 16;
    uint featuresMod = 10 ** featureDigits;
    uint waitPeriod = 30 minutes;
    
    struct Titan {
        string name;
        uint featureDNA;
        uint32 level;
        uint32 timeToBattle;
        uint8 numWins;
        uint8 numLosses;
    }
    
    Titan[] public titans;
    
    mapping (uint => address) public titanToPlayer;
    mapping (address => uint) playerToTitans;
    
    function _createTitan(string _name, uint _featureDNA) internal {
        uint id = titans.push(Titan(_name, _featureDNA, 1, uint32(now + waitPeriod), 0, 0)) - 1;
        titanToPlayer[id] = msg.sender;
        playerToTitans[msg.sender]++;
        emit NewTitan(id, _name, _featureDNA);
    }
    
    function _generateTitanFeatures(string _str) private view returns (uint) {
        uint randomFeatures = uint(keccak256(abi.encodePacked(_str)));
        return randomFeatures % featuresMod;
    }
    
    function createFirstRandomTitan(string _name) public {
        require(playerToTitans[msg.sender] == 0);
        uint featuresHash = _generateTitanFeatures(_name);
        featuresHash = featuresHash - featuresHash % 100;
        _createTitan(_name, featuresHash);
    }
    
}
