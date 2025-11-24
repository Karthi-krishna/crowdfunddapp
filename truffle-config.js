// truffle-config.js

/**
 * Use this file to configure your truffle project.
 * More information about configuration can be found at:
 * https://trufflesuite.com/docs/truffle/reference/configuration
 */

module.exports = {
  contracts_build_directory: "./build/contracts",
  /**
   * Networks define how you connect to your ethereum client.
   */
  networks: {
    // This is the configuration for Ganache CLI
    development: {
      host: "127.0.0.1",     // Localhost (default)
      port: 8545,            // CORRECT Ganache CLI default port
      network_id: "*",       // Match any network ID
    },
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.20",      // <-- Explicitly set compiler version to match contract pragma
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};