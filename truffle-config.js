// const path = require("path");
const HDWalletProvider = require('truffle-hdwallet-provider');
const MNEMONIC = "general initial steel spirit inmate rack fiber equal soldier dash galaxy spring";

module.exports = {

  // contracts_build_directory: path.join(__dirname, "client/src/contracts"),
networks: {
     dev: {
       host: '127.0.0.1',
       port: 8545,
       network_id: '*',
       timeoutBlocks: 50000,
       networkCheckTimeout: 100000
     },
     testnet: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://data-seed-prebsc-1-s1.binance.org:8545/`),
      network_id: 97,   // This network is yours, in the cloud.
      timeoutBlocks: 200,
      confirmations: 5,
      production: true,
      networkCheckTimeout: 100000    // Treats this network as if it was a public net. (default: false)
    }
  },
compilers: {
   solc: {
       version: "0.8.6",
       optimizer: {
          enabled: true,
          runs: 200
       }
   }
}
};