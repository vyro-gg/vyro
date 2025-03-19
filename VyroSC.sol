// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title VyroAdCampaign
 * @dev This contract allows advertisers to create engagement campaigns
 * where users complete tasks (e.g., follows, retweets, content creation)
 * and earn rewards with on-chain verification.
 */
contract VyroAdCampaign {
    struct Campaign {
        address advertiser;
        uint256 rewardPerTask;
        uint256 totalBudget;
        uint256 remainingBudget;
        uint256 expiry;
        bool active;
        mapping(address => bool) hasClaimed;
        TaskType taskType;
    }
    
    enum TaskType { FOLLOW, RETWEET, CONTENT_CREATION }
    
    mapping(address => Campaign) public campaigns;
    address[] public campaignAddresses;
    
    event CampaignCreated(address campaignAddress, address advertiser, uint256 rewardPerTask, uint256 totalBudget, uint256 expiry, TaskType taskType);
    event TaskCompleted(address campaign, address user, uint256 reward, string proof);
    event CampaignWithdrawn(address campaign, address advertiser, uint256 remainingFunds);
    event CampaignExpired(address campaign);
    
    /**
     * @dev Creates a new campaign.
     * @param _rewardPerTask Reward given per completed task.
     * @param _totalBudget Total campaign budget.
     * @param _validityHours Duration of the campaign in hours.
     * @param _taskType Type of engagement task.
     */
    function createCampaign(uint256 _rewardPerTask, uint256 _totalBudget, uint256 _validityHours, TaskType _taskType) external payable returns (address) {
        require(msg.value == _totalBudget, "Insufficient funds sent");
        require(_rewardPerTask > 0 && _totalBudget > 0, "Invalid reward or budget");
        require(_validityHours > 0, "Campaign duration must be positive");
        
        address campaignAddress = address(uint160(uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)))));
        
        Campaign storage campaign = campaigns[campaignAddress];
        campaign.advertiser = msg.sender;
        campaign.rewardPerTask = _rewardPerTask;
        campaign.totalBudget = _totalBudget;
        campaign.remainingBudget = _totalBudget;
        campaign.expiry = block.timestamp + (_validityHours * 1 hours);
        campaign.active = true;
        campaign.taskType = _taskType;
        
        campaignAddresses.push(campaignAddress);
        
        emit CampaignCreated(campaignAddress, msg.sender, _rewardPerTask, _totalBudget, campaign.expiry, _taskType);
        return campaignAddress;
    }
    
    /**
     * @dev Allows users to complete tasks and earn rewards with on-chain verification.
     * @param _campaign Address of the campaign.
     * @param proof Proof of engagement (e.g., tweet link, screenshot hash).
     */
    function completeTask(address _campaign, string memory proof) external {
        Campaign storage campaign = campaigns[_campaign];
        require(block.timestamp < campaign.expiry, "Campaign expired");
        require(campaign.remainingBudget >= campaign.rewardPerTask, "Campaign out of funds");
        require(!campaign.hasClaimed[msg.sender], "Task already completed by user");
        require(bytes(proof).length > 0, "Invalid proof");
        
        // On-chain verification can be extended with oracles or additional mechanisms
        require(verifyTaskCompletion(proof), "Task verification failed");
        
        campaign.hasClaimed[msg.sender] = true;
        campaign.remainingBudget -= campaign.rewardPerTask;
        payable(msg.sender).transfer(campaign.rewardPerTask);
        
        emit TaskCompleted(_campaign, msg.sender, campaign.rewardPerTask, proof);
    }
    
    /**
     * @dev Mock verification function for on-chain proof validation.
     */
    function verifyTaskCompletion(string memory proof) internal pure returns (bool) {
        return bytes(proof).length > 10; // Replace with real verification logic
    }
    
    /**
     * @dev Allows the advertiser to withdraw remaining funds after campaign expiry.
     * @param _campaign Address of the campaign.
     */
    function withdrawFunds(address _campaign) external {
        Campaign storage campaign = campaigns[_campaign];
        require(msg.sender == campaign.advertiser, "Only advertiser can withdraw");
        require(block.timestamp >= campaign.expiry, "Campaign still active");
        require(campaign.active, "Funds already withdrawn");
        
        uint256 remainingFunds = campaign.remainingBudget;
        campaign.remainingBudget = 0;
        campaign.active = false;
        payable(msg.sender).transfer(remainingFunds);
        
        emit CampaignWithdrawn(_campaign, msg.sender, remainingFunds);
    }
    
    /**
     * @dev Checks and marks campaigns as expired.
     */
    function expireCampaigns() external {
        for (uint i = 0; i < campaignAddresses.length; i++) {
            address _campaign = campaignAddresses[i];
            Campaign storage campaign = campaigns[_campaign];
            if (block.timestamp >= campaign.expiry && campaign.active) {
                campaign.active = false;
                emit CampaignExpired(_campaign);
            }
        }
    }
    
    /**
     * @dev Returns the total number of campaigns created.
     */
    function getCampaignCount() external view returns (uint256) {
        return campaignAddresses.length;
    }
}
