const { Connection, clusterApiUrl } = require("@solana/web3.js");

const QUICKNODE_RPC = "https://late-serene-feather.solana-mainnet.quiknode.pro/3efa333c9866046a5a40f12c3d04a3e918e13421/";
const connection = new Connection(QUICKNODE_RPC, "confirmed");

(async () => {
    const version = await connection.getVersion();
    console.log("Solana Version:", version);
})();
