// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 <0.8.8;
contract voting
{
    struct vote //details of vote
    {
        address voterID;
        bool choice;
    }

    struct voter //deatils of voter
    {
        string voterName;
        bool present;
    }
    uint private countpositivevote = 0;
    uint public result = 0;
    uint public votercount = 0;
    uint public votecount = 0;

    address public admin_address;
    string public admin_name;
    string public manifesto;

    mapping(uint => vote) private Mapp_voting;
    mapping(address => voter) public Mapp_votes;

    enum State{ Created, Voting, Ended}
    State public state;

    modifier condition(bool _condition) 
    {
        require(_condition);
        _;
    }

    modifier onlyAdmin()
    {
        require(msg.sender == admin_address);
        _;
    }

    modifier inState(State _state)
    {
        require(state == _state);
        _;
    }

    constructor(
        string memory _admin_name,
        string memory _manifesto
     ) {
        admin_address = msg.sender;
        admin_name = _admin_name;
        manifesto = _manifesto;
        state = State.Created;
    }

    function addVoter( address _voteraddress, string memory _votername)public 
    inState(State.Created)
    onlyAdmin
    {
        voter memory v;
        v.voterName = _votername;
        v.present = false;
        Mapp_votes[_voteraddress] = v;
        votercount++;
    }


    function startVote() public inState(State.Created)
    onlyAdmin 
    {
        state= State.Voting;
    }


    function doVote(bool _choice)
    public inState(State.Voting)
    returns (bool present)
    {
        bool VoterFound= false;
        if(bytes(Mapp_votes[msg.sender].voterName).length != 0 && Mapp_votes[msg.sender].present == false )
        {
            Mapp_votes[msg.sender].present = true;
            vote memory v;
            v.voterID = msg.sender;
            v.choice= _choice;
            if(_choice)
            {
               countpositivevote++; 
            }
            Mapp_voting[votecount]= v;
            votecount++;
            VoterFound = true;
        }
        return VoterFound;
    }

    function endvote()
        public
        inState(State.Voting)
        onlyAdmin
    {
        state = State.Ended;
        votecount = countpositivevote;
    }


}

