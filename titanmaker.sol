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
    
    
}
