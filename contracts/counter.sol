// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract ProposalContract {

    address owner;

    struct Proposal {
        string title; // title 
        string description; // Description of the proposal
        uint256 approve; // Number of approve votes
        uint256 reject; // Number of reject votes
        uint256 pass; // Number of pass votes
        uint256 total_vote_to_end; // When the total votes in the proposal reaches this limit, proposal ends
        bool current_state; // This shows the current state of the proposal, meaning whether if passes of fails
        bool is_active; // This shows if others can vote to our contract
    }

    mapping(uint256 => Proposal) proposal_history; // Recordings of previous proposals


    // Here we create an instance of our Counter.
    // It is empty for now, but we will initialize it in the constructor.
    Proposal counter;


    // We will use this modidifer with our execute functions.
    // This modifiers make sure that the caller of the function is the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can increment or decrement the counter");
        _;
    }


    // This is our constructor function. It only runs once when we deploy the contract.
    // Since it takes two parameters, initial_value and description, they should be provided
    // when we deploy our contract.
    constructor(string memory title, string memory description, uint256 approve, uint256 reject, uint256 pass, uint256 total_vote_to_end, bool current_state, bool is_active) {
        owner = msg.sender;
        counter = Proposal(title, description, approve, reject, pass, total_vote_to_end, current_state, is_active);
    }


    // Below, we have two execute functions, increment_counter and decrement_counter
    // Since they modify data on chain, they require gas fee.
    // They are external functions, meaning they can only be called outside of the contract.
    // They also have the onlyOwner modifier which we created above. This make sure that
    // only the owner of this contract can call these functions.


    // This function gets the number field from the counter struct and increases it by one.
    function increment_counter() external onlyOwner {
        counter.approve += 1;
    }


    // This function is similar the one above, but instead of increasing we deacrease the number by one.
    function decrement_counter() external onlyOwner {
        counter.reject -= 1;
    }


    // The function below is a query function.
    // It does not change any data on the chain. It just rerieves data.
    // We use the keyword view to indicate it retrieves data but does not change any.
    // Since we are not modifying any data, we do not pay any gas fee.


    // This function returns the number field of our counter struct.
    // Returning the current state of our counter.
    function get_counter_value() external view returns(string memory) {
        return counter.title;
    }


    function get_description_str() external view returns(string memory) {
        return counter.description;
    }
}