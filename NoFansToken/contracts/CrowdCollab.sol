pragma solidity ^0.5.0;

contract CrowdCollab { 

    // address of manager, who manages campaign
    address public manager;

    // min contribution value in ETH
    uint public minimumContribution;

    // description about your campaign
    string public campaignDescription;
    // a mapping list of supporter address, to check if address is
    // supporter or not
    mapping(address=>bool) public supporters;

    // current number of supporter in campaign,
    // when any one contribute money for project, he/she will
    // become supporter
    uint public numberSupporters;

    // list of expense request for project
    Request[] public requests;

    /**
    * Request expense detail information
    */
    struct Request {
        string description;
        uint amount;
        address payable recipient;
        bool complete;
        mapping(address=>bool) approvals;
        uint approvalCount;
    }

    modifier managerOnly() {
        require(msg.sender == manager);
        _;
    }

    modifier supporterOnly() {
        require(supporters[msg.sender]);
        _;
    }

    constructor(
        address creator, 
        uint minContribution, 
        string memory description
        ) public {
        manager = creator;
        minimumContribution = minContribution;
        campaignDescription = description;
    }

    function support() public payable {
        require(msg.value > minimumContribution);
        supporters[msg.sender] = true;
        numberSupporters ++;
    }

    function createRequest(
        string memory description, 
        uint amount,
        address payable recipient
    ) public managerOnly {
        Request memory newRequest = Request({
        description: description,
        amount: amount,
        recipient: recipient,
        complete: false,
        approvalCount: 0
    });
    requests.push(newRequest);
    }

    function approveRequest(uint requestId) 
    public supporterOnly {
        Request storage request = requests[requestId];
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender] = true;
        request.approvalCount ++;
    }

    function finalizeRequest(uint requestId) 
    public managerOnly {
        Request storage request = requests[requestId];
        require(!request.complete);
        require(request.approvalCount > (numberSupporters/2) );
        request.recipient.transfer(request.amount);
        request.complete = true;
     }

}