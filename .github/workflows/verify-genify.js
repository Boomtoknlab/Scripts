const { ethers } = require("ethers");
const fs = require("fs");

// Use an appropriate RPC URL (for Ethereum, BSC, or another network as needed)
// Replace with your preferred RPC endpoint if necessary
const RPC_URL = process.env.RPC_URL || "https://cloudflare-eth.com";

// Genify Battle Passcard Contract and Token ID
const GENIFY_CONTRACT = process.env.GENIFY_CONTRACT || "0xfCDc908aecDaC96bcCc8B69002C907A01Bb554DB";
const TOKEN_ID = process.env.TOKEN_ID || "3050309";

// Minimal ERC721 ABI (only ownerOf function)
const ABI = ["function ownerOf(uint256 tokenId) public view returns (address)"];

async function verifyGenify() {
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const contract = new ethers.Contract(GENIFY_CONTRACT, ABI, provider);

  try {
    const owner = await contract.ownerOf(TOKEN_ID);
    console.log("✅ Genify Battle Passcard Owner:", owner);

    // Read allowed wallet addresses from allowed_genify_wallets.json
    const allowedWallets = JSON.parse(fs.readFileSync("allowed_genify_wallets.json")).wallets;

    if (allowedWallets.includes(owner.toLowerCase())) {
      console.log("✅ Access Granted: User owns Genify Battle Passcard #50309.");
      process.exit(0);
    } else {
      console.log("⛔ Access Denied: User does not own the required Genify Battle Passcard.");
      process.exit(1);
    }
  } catch (error) {
    console.error("⚠️ Error verifying Genify Battle Passcard ownership:", error);
    process.exit(1);
  }
}

verifyGenify();
