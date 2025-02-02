# Astar Network Related Tools and Documentation

This page independently develops and publishes tools and documentation related to the Astar Network.

dApp Staking Data
=============

https://agent.sun-t-sarah.work/

![image](https://github.com/user-attachments/assets/032f077c-0b2f-4313-9522-442c175b27f6)

## Staking Amount by dApp Staker

Displays a list of stakers for each dApp in dAppStaking.

- The number next to the dApp Name represents the total number of stakers.
- The data is formatted from on-chain data.
- By default, it is displayed in descending order of staking amount (switchable via the table header).
- dApps with many stakers may take some time to display.
- By selecting a dApp and pressing “Export CSV Data,” you can export a file that lists stakers and their stake amounts.
- The list of dApps itself is based on the data from **Jan. 28, 2025**.
- Please be aware that there may be changes to specifications or delays in updating the list of dApps without prior notice.
- EVM (e.g., Metamask) addresses are now displayed. The following information is available.
  * You can see the addresses staked with EVM [ (Staker/EVM) ] column.
  * You can see the native addresses of those staked with EVM [ (Staker/Native) ] column.
  * For those staked natively, the [ (Staker/EVM) ] column shows "N/A".

![image](https://github.com/user-attachments/assets/47f8b6ff-8b6c-4d53-b09c-f05c5e06104a)


## dApp Ranking During Build&Earn Subperiod

This board is updated irregularly.

- No. ( Ranking number by Total Staked Amount )
- Name ( Project Name )
- Category
- TotalStaked ( Total Staking Amount during Build&Earn Subperiod )
- Stakers
- MEAN ( Average per Staker )
- MEDIAN ( Median of Staking Amount )
- STDDEV ( Standard Deviation of Staking Amount )
- Tier ( Tier Level )
- Rank ( Rank in Tier )
- Reward ( Rewards per ERA calculated by Tier and Rank )

![image](https://github.com/user-attachments/assets/7496444f-5c3b-4cbb-a7fa-99d0802115cd)

## dApp Ranking During Voting Subperiod

This page displays the rankings during the "Voting Subperiod". 
Currently, it is manually operated to update once or twice a day during the "Voting Subperiod".

- Rank
- Project Name
- Category
- Stakers
- VotingStaked

![image](https://github.com/tksarah/bc/assets/11060137/f4533b9c-9a63-4b3b-a06a-c21108cb5dd4)

## ID Search

On this page, you can input the CSV obtained from 'Staking Amount by dApp Staker' and display the ones from the staker list that have their on-chain IDs.

![image](https://github.com/user-attachments/assets/e09038ab-6bc3-40f5-8253-cc8958624ac7)



