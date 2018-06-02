pragma solidity ^0.4.23;

import "./MyFirstToken.sol";

contract Evoting {
      /**struct to store voter property like authorized and voted
      authorized make sure voter authorized;
      voted status of voters already vote or not yet;
      */
      struct Voter {
          bool authorized;
          bool voted;
      }

      //mapping array of voters based on voter address
      mapping(address => Voter) public voters;

      // This is a type of array storing names of candidate
      string[] names;
      // counting numbers voter which already voted
      uint8 voteCount;

      address public wallet;

      // overriding of contract MyFirstToken for to be used in this contract
      // stored in token
      MyFirstToken public token = new MyFirstToken();

      //mapping of vote which has been commited
      mapping(uint256 => bytes32) public voteCommits;

      //vote collected each of candidates
      mapping(uint => uint) voteCollected;

      /** Constructor
      * build Evoting
      */
      constructor(MyFirstToken _token) public {
        voteCount = 0;
        token = _token;
        wallet = msg.sender;
        //uint TokenSharedValue = totalSupply / banyak_pemilih;
      }

      /** add candidate
      * adding new candidate to contract
      * push it to array of names
      */
      function addCandidate(string _name) public{
        names.push(_name);
      }

      /** Authorized Voter
      * Before voter do voting at beginning should be authorized by contract owner
      * @param _participants contain address of voter
      */
      function authorizedVoter(address _participants) public returns(bool) {
        require(_participants != address(0));
        require(_participants != token.getOwner());
        voters[_participants].authorized = true;
        token.transfer(_participants, 1000000);
        return true;
      }

      /** Give Your Vote
      * input the vote of voters and send vote public password to owner of contract
      * and making voter pay for voting activities with Approve and TransferFrom methode
      * @param _vote stored format vote
      * @param _addr stored address voter which has been voted;
      */
      function commitVote(bytes32 _vote, address _addr) public {
        require(token.balanceOf(msg.sender) > 0);
        require(voters[_addr].voted==false);
        voteCount++;
        voteCommits[voteCount] = keccak256(abi.encodePacked(_vote));
        token.approve(wallet, 1000000);
        token.transferFrom(msg.sender, wallet, 1000000);
      }

      /** Reveal Vote
      * Send publicpass of vote being commited
      * Make comparasion between _vote and encryption of vote
      * @param  num candidate number which choosen by voter
      * @param  _vote format of public password
      * @param  commit is encryption of vote
      */
      function revealVote(uint num, string _vote, bytes32 commit) public returns(string){
        if(commit == keccak256(abi.encodePacked(_vote))) {
          voteCollected[num]++;
          return("this is successss");
        }
        else {
          //return("this is fuckedup");
          //tidak sah
        }
      }

      /** Find winner of Evoting
      * make looping function through voteCollected in length of names.length
      * @return proposal which is the proposal number win evoting
      */
      function getWinner() constant public returns(uint proposal){
        uint winningProposal = 0;
        for(uint i=1; i<=names.length; i++){
          if(voteCollected[i] > winningProposal){
            winningProposal = voteCollected[i];
            proposal = i - 1;
            return proposal;
          }
        }
      }

      /** Show the Winner Name!
      * Calls getWinner() function to get the index
      * of the winner contained in the proposals array and then
      * returns the name of the winner
      * @return string
      */
      function winnerName() view public returns (string)
      {
          return names[getWinner()];
      }
}
