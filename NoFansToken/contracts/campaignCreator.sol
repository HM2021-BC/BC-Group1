pragma solidity ^0.5.0;
import './CrowdCollab.sol';

contract CampaignCreator{
    address [] public campaigns;

function createCampaign (uint minContribution, string memory description) public {
    address newCampaign = address (new CrowdCollab(
        msg.sender,
        minContribution,
        description
    ));

    campaigns.push(newCampaign);
}

function getDeployedCampaigns() public view returns(address[] memory){
    return campaigns;
}
}