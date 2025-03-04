const { ethers } = require("ethers");
const fs = require("fs");

// BNB Smart Chain Mainnet RPC endpoint (use a provider of your choice)
const RPC_URL = process.env.RPC_URL || "https://bsc-dataseed.binance.org";

// NFT contract details
const NFT_CONTRACT = process.env.NFT_CONTRACT || "0xADc64685Bebe8d1402C5F7e6706Fccc3AEdB4a00";
const TOKEN_ID = process.env.TOKEN_ID || "3911358";

// Minimal ERC721 ABI (ownerOf)
const ABI = ["function ownerOf(uint256 tokenId) public view returns (address)"];

async function verifyBscNft() {
  try {
    const provider = new ethers.JsonRpcProvider(RPC_URL);
    const contract = new ethers.Contract(NFT_CONTRACT, ABI, provider);

    // Fetch the owner of the given token ID
    const owner = await contract.ownerOf(TOKEN_ID);
    console.log(`✅ NFT Owner for Token #${TOKEN_ID}:`, owner);

    // Read allowed wallet addresses
    const allowedWallets = JSON.parse(fs.readFileSync("allowed_bsc_wallets.json", "utf8")).wallets;

    // Check if the owner's address is in our allowed list
    if (allowedWallets.includes(owner.toLowerCase())) {
      console.log(`✅ Access Granted: Wallet ${owner} owns Token #${TOKEN_ID}.`);
      process.exit(0);
    } else {
      console.log(`⛔ Access Denied: Wallet ${owner} is not in the allowed list.`);
      process.exit(1);
    }
  } catch (error) {
    console.error("⚠️ Error verifying NFT ownership:", error);
    process.exit(1);
  }
}

verifyBscNft();
