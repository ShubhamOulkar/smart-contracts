// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    // ****************** Data ***********************
    address public  owner;
    address[] private voted_addresses; 
    uint256 private counter;

    struct Proposal {
        string title; 
        string description; // Description of the proposal
        uint256 approve; // Number of approve votes
        uint256 reject; // Number of reject votes
        uint256 pass; // Number of pass votes
        uint256 total_vote_to_end; // When the total votes in the proposal reaches this limit, proposal ends
        bool current_state; // This shows the current state of the proposal, meaning whether if passes of fails
        bool is_active; // This shows if others can vote to our contract
    }

    mapping(uint256 => Proposal) proposal_history; // Recordings of previous proposals

    //constructor
    constructor() {
        owner = msg.sender;
        voted_addresses.push(msg.sender);
    }
    //change 0 :-  improved modifiers for developers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier active() {
        require(proposal_history[counter].is_active == true, "Proposal is not active");
        _;
    }

    modifier newVoter(address _address) {
        require(!isVoted(_address), "Address has not voted yet");
        _;
    }

    // ****************** Execute Functions ***********************


    function setOwner(address new_owner) external onlyOwner {
        owner = new_owner;
    }

    function create(string calldata _title, string calldata _description, uint256 _total_vote_to_end) external onlyOwner {
        counter += 1;
        proposal_history[counter] = Proposal(_title, _description, 0, 0, 0, _total_vote_to_end, false, true);
    }
    

    function vote(uint8 choice) external active newVoter(msg.sender){
        Proposal storage proposal = proposal_history[counter];
        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        uint256 pass = proposal.pass;

        voted_addresses.push(msg.sender);

        if (choice == 1) proposal.approve += 1;
        if (choice == 2) proposal.reject += 1;
        if (choice == 0) proposal.pass += 1;
        
        //change 1 - check current state once after increment
        proposal.current_state = calculateCurrentState();

        // change 2 - if total vote reach threshold make proposal inactive
        if ((proposal.total_vote_to_end == (approve + reject + pass) ) ) {
            proposal.is_active = false;
            voted_addresses = [owner];
        }
    }

    function terminateProposal() external onlyOwner active {
        proposal_history[counter].is_active = false;
    }


    function calculateCurrentState() private view returns(bool) {
        Proposal storage proposal = proposal_history[counter];

        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        uint256 pass = proposal.pass;
        //change 3 :- rewriting code for calculate current state
        pass = pass % 2 == 1 ? (pass+1)/2 : pass/2;
        
       return approve > (reject + pass) ? true : false;
    }


    // ****************** Query Functions ***********************

    // change 4 - making this function private
    function isVoted(address _address) private view returns (bool) {
        for (uint i = 0; i < voted_addresses.length; i++) {
            if (voted_addresses[i] == _address) {
                return true;
            }
        }
        return false;
    }


    function getCurrentProposal() external view returns(Proposal memory) {
        return proposal_history[counter];
    }

    function getProposal(uint256 number) external view returns(Proposal memory) {
        return proposal_history[number];
    }
}
