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
* MetaMask extension is required to connect the wallet with the application 
``` 
    https://metamask.io/
```

* With the metamask account u a required to register or log into a account
once logged in 
1. click select a network 
2. show test networks 
3. click sepolia as the network

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
cd TimeBlockApp

```

## 6. Smart Contract Deployment

### Compile and Deploy

1. Open `contracts/` in Remix IDE
2. Compile each `.sol` file
3. Deploy to Sepolia or local Hardhat network

### Update ABI.js

* Copy ABI from Remix and paste into `static/ABI.js`

### Configure HTML Scripts

* Insert deployed contract addresses in the `<script>` tags at the top of each HTML file

## 7. Running the App

### Open in Browser

```bash
got to your Repository directory on the local device and run the following commands
    npm install -g lite-server
    lite-server
```
once installed Navigate to cd TimeBlockApp
then enter in the cmd lite-server which will open the application on `http://localhost:3000`

### Connect Wallet

* Approve MetaMask connection on page load
* Switch network to Sepolia please ensuring that funds are avaliable 

## 8. Using the App

### Manufacturer Workflow

1. Add new watch

2. Mint certificate
3. Transfer to Reseller

### Retailer Workflow

1. View incoming certificates
2. Set watch price
3. List watch for sale

### Buyer Workflow

1. View certificate authenticity
2. Deposit ETH into escrow
3. Claim watch on-chain

### Reseller Workflow

1. Verify certificate
2. Purchase from Retailer
3. Transfer ownership

## 9. Troubleshooting

* MetaMask not detecting site: ensure network matches
* ABI mismatch: recompile and update `ABI.js`
* Price not updating: clear localStorage

## 10. Future Improvements

* Multi-watch portfolios
* IPFS for certificate storage
* Mainnet deployment

## 11. License

MIT License. See [LICENSE](LICENSE) for details.

## 12. Acknowledgements

* Ethereum docs
* Ethers.js library
* Remix IDE
* Testnet faucets

* anhduongnguyen, Jay Bowls , Oliver Gibson

