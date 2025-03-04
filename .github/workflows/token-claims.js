const fs = require('fs');

function main() {
  try {
    const data = fs.readFileSync('allowed_claims_addresses.json', 'utf8');
    const addresses = JSON.parse(data);

    console.log("=== Token Claims Recipient Addresses ===");
    console.log("Primary Recipient:", addresses.primaryRecipient);
    console.log("Donations Address:", addresses.donationsAddress);
    console.log("Gifts Address:", addresses.giftsAddress);
    console.log("Funding Address:", addresses.fundingAddress);
    console.log("Contributor Claim Address:", addresses.contributorClaimAddress);
  } catch (error) {
    console.error("Error reading addresses:", error);
    process.exit(1);
  }
}

main();
