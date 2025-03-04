const { ethers } = require("ethers");
const fs = require("fs");

// Set your RPC URL (for example, a Polygon RPC endpoint)
const RPC_URL = process.env.RPC_URL || "https://polygon-rpc.com";

// Lens Protocol Profile Contract for @okeamah
const LENS_CONTRACT = process.env.LENS_CONTRACT || "0xe7E7EaD361f3AaCD73A61A9bD6C10cA17F38E945";

// Token ID for the profile
const TOKEN_ID = process.env.TOKEN_ID || "98100195239343667242200312822235695483801005379797495648145440091955614412923";

// Minimal ERC721 ABI to call ownerOf
const ABI = ["function ownerOf(uint256 tokenId) public view returns (address)"];

async function verifyLens() {
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const contract = new ethers.Contract(LENS_CONTRACT, ABI, provider);

  try {
    const owner = await contract.ownerOf(TOKEN_ID);
    console.log("✅ Lens Profile Token Owner:", owner);

    // Load allowed wallet addresses from allowed_lens_wallets.json
    const allowedWallets = JSON.parse(fs.readFileSync("allowed_lens_wallets.json")).wallets;

    if (allowedWallets.includes(owner.toLowerCase())) {
      console.log("✅ Access Granted: User owns the Lens profile token for @okeamah.");
      process.exit(0);
    } else {
      console.log("⛔ Access Denied: User does not own the required Lens profile token.");
      process.exit(1);
    }
  } catch (error) {
    console.error("⚠️ Error verifying Lens ownership:", error);
    process.exit(1);
  }
}

verifyLens();
