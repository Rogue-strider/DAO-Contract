// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract demo {
    
    struct Proposal{
        uint id;
        string description;
        uint amount;
        address payable receipient;
        uint votes;
        uint end;
        bool isExecuted;
    }

    mapping(address=>bool) private isInvestor;
    mapping(address=>uint) private numOfshares;
    mapping(address=>mapping(uint=>bool)) public isVoted;
    mapping(address=>mapping(uint=>bool)) public withdrawlStatus;
    address[] public investorsList;
    mapping(uint=>Proposal) public proposals;

    uint public totalShares;
    uint public avaiableFund;
    uint public contributionTimeEnd;
    uint public nextProposalId;
    uint public voteTime;
    uint public quorum;
    address public manager;

    constructor(uint _contributionTimeEnd, uint _voteTime, uint _quorum){
        require(_quorum>0 && _quorum<100, "Not valid values");
        contributionTimeEnd=block.timestamp+_contributionTimeEnd;
        voteTime=_voteTime;
        quorum=_quorum;
        manager=msg.sender;
    }

    modifier onlyInvestor(){
        require(isInvestor[msg.sender]==true,"Not an investor");
        _;
    }

    modifier onlyManager(){
        require(manager==msg.sender,"Not an Manager");
        _;
    }

    function contribution() public payable{
        require(contributionTimeEnd>=block.timestamp, "Contribution Time Ended");
        require(msg.value>0,"Send More than 0 ether");
        isInvestor[msg.sender]=true;
        numOfshares[msg.sender]=numOfshares[msg.sender]+msg.value;
        totalShares+=msg.value; 
        avaiableFund+=msg.value;
        investorsList.push(msg.sender);
    }
    
    function redeemShare(uint amount) public onlyInvestor(){
        require(numOfshares[msg.sender]>=amount, "You dont have enough shares");
        require(avaiableFund>=amount, "Not enough funds");
        numOfshares[msg.sender]-=amount;
        if(numOfshares[msg.sender]==0){
            isInvestor[msg.sender]=false;
        }
        avaiableFund-=amount;
        payable(msg.sender).transfer(amount);
    }

    function transferShare(uint amount, address to) public onlyInvestor(){
        require(avaiableFund>=amount, "Not enough funds");
        require(numOfshares[msg.sender]>=amount, "You dont have enough shares");
        require(isInvestor[to], "The address is not an investor");
        numOfshares[msg.sender]-=amount;
        numOfshares[to]+=amount;
        if(numOfshares[msg.sender]==0){
            isInvestor[msg.sender]=false;
        }
        numOfshares[to]+=amount;
        isInvestor[to]=true;
        investorsList.push(to);
    }
    

    function createProposal(string calldata description, uint amount, address payable receipient) public onlyManager(){
         require(avaiableFund>=amount, "Not enough funds");
         proposals[nextProposalId]=Proposal(nextProposalId, description, amount, receipient,
         0,block.timestamp+voteTime, false);
         nextProposalId++;
    }

    function voteProposal(uint proposalId) public onlyInvestor(){
        Proposal storage proposal = proposals[proposalId];
        require(isVoted[msg.sender][proposalId]==false, "You have already voted for this proposal");
        require(block.timestamp<=proposal.end, "Voting ended");
        require(proposal.isExecuted==false, "Its already executed");
        isVoted[msg.sender][proposalId]=true;
        proposal.votes+=numOfshares[msg.sender];
    }

    function executeProposal(uint proposalId) public onlyManager(){
        Proposal storage proposal = proposals[proposalId];
        require(((proposal.votes*100)/totalShares)>=quorum, "Majority does not support");
        proposal.isExecuted=true;
        avaiableFund-=proposal.amount;
        _transfer(proposal.amount, proposal.receipient);
    }

    function _transfer(uint amount, address payable receipient) public {
       receipient.transfer(amount);
    }
    function ProposalList() public view returns(Proposal[] memory){
        Proposal[] memory arr = new Proposal[](nextProposalId-1);
        for(uint i=0;i<nextProposalId;i++){
            arr[i]=proposals[i];
        }
        return arr;
    }
}