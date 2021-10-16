pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    //Event declaration for communcation to app frontend
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    //dynamic array declaratiom
    Zombie[] public zombies;
    
    //Creates a mapping or dictionary
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;
    
    //internal keyword makes it possible to call functions from inhertited contracts
    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender; //updating the mapping variable
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0); //to make sure only one Zombie per owner is created
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
