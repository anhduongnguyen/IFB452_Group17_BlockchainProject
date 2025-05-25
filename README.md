REMIX DEFAULT WORKSPACE

Remix default workspace is present when:
i. Remix loads for the very first time 
ii. A new workspace is created with 'Default' template
iii. There are no files existing in the File Explorer

This workspace contains 3 directories:

1. 'contracts': Holds three contracts with increasing levels of complexity.
2. 'scripts': Contains four typescript files to deploy a contract. It is explained below.
3. 'tests': Contains one Solidity test file for 'Ballot' contract & one JS test file for 'Storage' contract.

SCRIPTS

The 'scripts' folder has four typescript files which help to deploy the 'Storage' contract using 'web3.js' and 'ethers.js' libraries.

For the deployment of any other contract, just update the contract's name from 'Storage' to the desired contract and provide constructor arguments accordingly 
in the file `deploy_with_ethers.ts` or  `deploy_with_web3.ts`

In the 'tests' folder there is a script containing Mocha-Chai unit tests for 'Storage' contract.

To run a script, right click on file name in the file explorer and click 'Run'. Remember, Solidity file must already be compiled.
Output from script will appear in remix terminal.

Please note, require/import is supported in a limited manner for Remix supported modules.
For now, modules supported by Remix are ethers, web3, swarmgw, chai, multihashes, remix and hardhat only for hardhat.ethers object/plugin.
For unsupported modules, an error like this will be thrown: '<module_name> module require is not supported by Remix IDE' will be shown.
# TimeBlock Blockchain App

## 1. Project Overview

* **Purpose:** Timeblocks purpose is to be a blockchain platform where users can have the ability to
track the authenticity, manufacturer history , ownership and sell/ resell luxurys on the blockchain.
* **Motivation:** whatches are one of the highest counterfit iteams with over 40million fake watches sold annually loosing trust with 3rd party buyers inside the market.
beacuse of the lack of trust timeblock has the ability to create a safe decentrailised blockchain to host and give its users the ability to Verify the watches authenticity through the chain 
instead of old paper work that could be misleading. 
* **Intended Users:** Manufacturer, Retailer, Buyer, Reseller.
* **Blockchain Integration:**  <to be added>


`
## 2. Key Features

* **Role-based Dashboards:** tailerd Dashboards for differenet stakeholders of the application which only shows relavent data relating to them. 
* **Certificate Viewing:** Mint a timeblock certificate at the manufacturer which contains serial number, model, production date, and specifications.
* **Price Setting & Listings:** Retailers and Resellers can set or update sale prices on their dashboard; list watches for sale.
* **Fund Deposit & Release:** transaction smart contract holds buyer funds securely in escrow.
* **Ownership Transfer:** The Management Contract enables for transfers to occur from the first sale from manufacturer to retailer , then primary sale to a buyer 
* **Transaction History:** access to the transaction history of the watch giving a clear authenticity view on the watches history

## 3. Tech Stack

* **Frontend:** HTML, CSS, JavaScript
* **Blockchain:** Solidity
* **Libraries:** Ethers.js
* **Tools:** MetaMask, Remix IDE, lite-server
* **Deployment** localhost

## 4. Folder Structure

```
├── contracts/                   # The contract directory contains the three smart contracts used on the project             
│   ├── ManagementContract.sol   # Management contract - Write access to Assign NFTs and Write Verify & transfer ownership
│   ├── RegistrationContract.sol # RegistrationContract - The ability to read and write to mint the TimeBlock Chain certificates
│   └── TransactionContract.sol  # TransactionContract  - Write access to pay via escrow and Read access to trigger payment release
├── TimeBlockApp/                # The TimeBlockApp directory contains the front end for the blockchain application
│   ├── node_modules/            # npm dependencies used inside the project
│   ├── static/                  # The static directory contains all the data that doesnt change within the project
│   │   ├── style.css            # THe styling used on the html and js
│   │   ├── ABI.js               # Contract ABIs and addresses
│   │   └── img/                 # the images used for the stakholders and other important figures on the website
│   ├── customer.html            # Customer/Buyer interface
│   ├── home.html                # Home/Landing page
│   ├── index.html               # Main entry point (dashboard selection)
│   ├── manufacturer.html        # Manufacturer dashboard
│   ├── retailer.html            # Retailer dashboard
│   ├── reseller.html            # Reseller dashboard
│   ├── package.json             # npm project config
│   └── package-lock.json        # npm lock file
└── README.md                    # Project overview and setup instructions
```

## 5. Getting Started

### Prerequisites

* Node.js & npm are required to run the localhost
```
    https://nodejs.org/en & https://www.npmjs.com/
    
```

* Lite server is required 
```
    npm install -g lite-server
```

* MetaMask extension is required to connect the wallet with the application 
``` 
    https://metamask.io/
```

* With the metamask account u a required to register or log into a account
* Open MetaMask 

1. click the network dropdown
2. Enable “Show test networks”
3. Select “Sepolia Test Network”
* Once connected go to a faucet website e.g
```
    https://cloud.google.com/application/web3/faucet/ethereum/sepolia
```
1. add your wallet from metamask
2. select Ethereum Sepolia 
3. send to your address

* these steps are required as the crypto is required to use the smart contracts

### Clone the Repository

```bash
git clone https://github.com/anhduongnguyen/IFB452_Group17_BlockchainProject.git
cd IFB452_Group17_BlockchainProject
git checkout main
git pull

doing this will give u full access to the applications code
```

## 6. Smart Contract Deployment

### Compile and Deploy

1. Open `contracts/` in Remix IDE
2. Compile each `.sol` file
3. Dploy to Sepolia or local Hardhat network

### Update ABI.js

* Copy ABI from Remix and paste into `static/ABI.js`

### Configure HTML Scripts

* Insert deployed contract addresses in the `<script>` tags at the top of each HTML file

## 7. Running the App

### Open in Browser

* In the CMD get into the timeblockAPP directorty blockchain\TimeBlockApp once your in this sub directorty run this command
```bash
    lite-server
```
* This command will start the server and be hosted on the `http://localhost:3000`

### Connect Wallet

* When you first access the server you will be asked to connect your wallet
* To connect your wallet select the connect wallet button , you will be then prompt to sign in again to make the connection work.
* once logged in Switch the network to  Sepolia if its already not selected by default already.  

## 8. Using the App

### Manufacturer Workflow

1. Register a New WatchFill by entering in the serial number, brand, production date, and model then 
Click the Generate Certificate to mint a new NFT on the blockchain.to Confirm the on-chain transaction on the MetaMask app.
2. To View a Certificate Select the dropdown with the title view certificate about it. once clicked it will Show Certificates 
and its corasponding infomation (serial, brand, model, date).
3. Assign to Retailer by Entering the retailers crypto wallet address into the box , then choose the watch that is being transferd 
to the retailer and click Assign to transfer ownership. 

### Retailer Workflow
1. View Certificate by clicking on  the dropdown to pick a new assigned watch and click Show Certificate to verify authenticity.
2. Create a Watch Listing by  selecting a watch and entering a sale price once the price has been entered Click List for Sale.
3. Watches Listed for Sale  will Display at the bottem of the application showing all active listings active on the chain.
4. Transaction History Logs every incoming and outgoing transfers.

### Buyer Workflow 
1. Select a view and Switch between the  buyers View or the Sellers View using the dropdown at the top.
2. Verify & View Certificates by Selecting a watch and then clicking the View Certificate  to Verify before purchase.
3. Buy from a Retailer by Choose a listing then input the requierd amount of funds and enter the sellers address.
4. Transaction History shows the user all about current deposit, verification, and ownership-claim events with details.

### Reseller Workflow

1.  Verify & View Certificate by Ensuring any acquired watches remains genuine by selecting it and clicking View Certificate & Verify
2.  buying from a customer is a simple as selecting a watch listed by another seller , then entering the ETH amount and recipient address, then Buy Now.
3. Transaction History shows the user all about current deposit, verification, and ownership-claim events with detail

## 9. Troubleshooting

* server wont start 
```
    Check that lite-server is installed globally (npm install -g lite-server)
    Ensure that your in the correct directory (/TimeBlockApp) when starting the lite-server
```
* if metemask isnt working 
``` 
    ensure you are logged in with a valid account with funds
    verify that your network is on the correct currency sepolia
```

## 10. Future Improvements

1. Certificate lifecycle management improvments, this can be done by Implementing a system to revocation and renewal processes so that lost or compromised certificates can be invalidated or reissued securely.
2. Advanced analytics dashboard which can be given to stakeholders to view more data about how their whatches are going through the process 
3. Imporve performance and gass by Utilising smart contract design patterns and explore meta-transactions or relayer networks to lower user costs per each transaction.

## 11. License

MIT License. See [LICENSE](LICENSE) for details.

## 12. Acknowledgements

* Ethereum docs
* Ethers.js library
* Remix IDE
* Testnet faucets

* anhduongnguyen, Jay Bowls , Oliver Gibson

