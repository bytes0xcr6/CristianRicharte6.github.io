require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("dotenv").config();

ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY;
PRIVATE_KEY = process.env.PRIVATE_KEY;
MUMBAI_KEY = process.env.MUMBAI_KEY;
POLYGON_KEY = process.env.POLYGON_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    // localhost: {
    //   url: "http://127.0.0.1:8545",
    // },
    // hardhat: {},
    testnet: {
      url: "https://rpc.ankr.com/polygon_mumbai",
      chainId: 80001,
      gasPrice: 12450000,
      accounts: [MUMBAI_KEY],
    },
    // mainnet: {
    //   url: "https://polygon.llamarpc.com",
    //   chainId: 137,
    //   gasPrice: 12450000,
    //   accounts: [POLYGON_KEY],
    // },
  },
  gasReporter: {
    outputFile: "gas-report.txt",
    noColors: true,
    enabled: true,
    // currency: "USD",
    coinmarketcap: COINMARKETCAP_API_KEY,
    token: "MATIC",
  },
  allowUnlimitedContractSize: false,
};
