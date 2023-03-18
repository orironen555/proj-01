// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


contract Election {
    // Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;

    }

    // Model a voter
    struct voter {
        uint256 voterId;
        string voterName;
    }

    constructor ()  {
        owner=msg.sender;
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }

    //modifier - time 
    uint256 public openTime = 1710656286;
    uint256 public closeTime = 1810656286;
    modifier onlyOpen ()  {
        require(block.timestamp > openTime && block.timestamp < closeTime);
        _;
    }

    //modifier - meneger
    address owner;
    modifier onlyOwner (){
        require(msg.sender == owner);
        _;
    }

    // Store accounts Candidates and voters
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    mapping(uint => bytes32) public VoterList;
    mapping(uint => voter) public VoterPublicList;


    uint256 numOfVoters = 0;
    uint256 public candidatesCount;
    uint256 public votarCount;


    // voted event
    event votedEvent (
    uint256 indexed _candidateId
    );


    //voter book 
    function addVoter (uint256 _voterId, string memory _voterName) public {
        votarCount ++;
        VoterList[votarCount]= ( keccak256(abi.encodePacked(_voterId,_voterName)));
        VoterPublicList[votarCount]=voter(_voterId, _voterName);
    }
   
    function addCandidate (string memory _name) public onlyOwner {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint _candidateId) public onlyOpen{
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
     
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        //grant token
       //transfer(msg.sender, uint tokens) public returns (bool);
        event transferFrom( owner, msg.sender,1)
        // trigger voted event
        emit votedEvent(_candidateId);
    }

}
