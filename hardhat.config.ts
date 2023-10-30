import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@openzeppelin/hardhat-upgrades";

import "dotenv/config";
import "./tasks";

const settings = {
  optimizer: {
    enabled: true,
    runs: 200,
  },
};
const accounts = [ process.env.PRIVATE_KEY ];
module.exports = {
  solidity: {
    compilers: [ "8.19", "8.9", "8.2", "6.0" ].map(v => (
      { version: `0.${v}`, settings }
    )),
  },
  networks: {
    dfk: {
      url: `https://subnets.avax.network/defi-kingdoms/dfk-chain/rpc`,
      chainId: 53935,
      accounts,
    },
    klaytn: { url: "https://public-node-api.klaytnapi.com/v1/cypress", chainId: 8217, accounts: accounts },
  },
  etherscan: {
    apiKey: {
      dfk: "not needed",
      klaytn: "not needed",
    },
    customChains: [
      {
        network: "dfk",
        chainId: 53935,
        urls: {
          apiURL: "https://api.routescan.io/v2/network/mainnet/evm/53935/etherscan",
          browserURL: "https://53935.routescan.io",
        },
      },
      {
        network: "klaytn",
        chainId: 8217,
        urls: { apiURL: "https://scope.klaytn.com/api", browserURL: "https://scope.klaytn.com/" },
      },
    ],
  },
};
