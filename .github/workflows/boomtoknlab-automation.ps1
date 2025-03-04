# ====================================
# Boomtoknlab Automation PowerShell Script
# Author: David Okeamah
# GitHub: Boomtoknlab
# ====================================

param (
    [string]$wallet = "0x97293ceab815896883e8200aef5a4581a70504b2",
    [string]$rpcBase = "https://mainnet.base.org/",
    [string]$rpcBSC = "https://bsc-dataseed1.binance.org/",
    [string]$contractBoomBase = "0x02C9974C9f3E3D96E8acF8c8eb9C46e19125630a",
    [string]$contractBoomBSC = "0xcd6a51559254030ca30c2fb2cbdf5c492e8caf9c",
    [string]$uniswapPool = "0x9090f998bCAB813B297992D01CdbFBB287954E73",
    [string]$logPath = "C:\Logs",
    [int]$days = 30,
    [string]$emailTo = "recipient@email.com",
    [string]$smtpServer = "smtp.yourserver.com",
    [string]$githubUser = "Boomtoknlab",
    [string]$githubToken = "your_github_personal_access_token",
    [string]$repoName = "boomtoknlab-auto-repo",
    [string]$telegramBotToken = "your_telegram_bot_token",
    [string]$telegramChatID = "your_chat_id",
    [string]$discordWebhook = "your_discord_webhook_url",
    [string]$twinkleRepo = "twinkle-github-action",
    [string]$rewardRepo = "boom-token-reward"
)

# ------------------------
# 1. Fetch BOOM Token Balance on Base & BSC
# ------------------------
Write-Output "Checking BOOM Token Balance on Base..."
$web3 = New-Object -ComObject "Web3.Web3Client"
$balanceBase = $web3.GetERC20Balance($contractBoomBase, $wallet, $rpcBase)
$balanceBSC = $web3.GetERC20Balance($contractBoomBSC, $wallet, $rpcBSC)
Write-Output "Base Balance: $balanceBase BOOM"
Write-Output "BSC Balance: $balanceBSC BOOM"

# ------------------------
# 2. Fetch BOOM Token Price from CoinGecko
# ------------------------
Write-Output "Fetching BOOM Token price from CoinGecko..."
$coinData = Invoke-RestMethod -Uri "https://api.coingecko.com/api/v3/simple/price?ids=boom-token&vs_currencies=usd"
$boomPrice = $coinData."boom-token".usd
Write-Output "BOOM Token Price: $boomPrice USD"

# ------------------------
# 3. Fetch BOOM Token Liquidity Pool Data
# ------------------------
Write-Output "Fetching BOOM Token liquidity pool info..."
$poolData = Invoke-RestMethod -Uri "https://api.dexscreener.com/latest/dex/pairs/base/$uniswapPool"
$liquidity = $poolData.pair.liquidity.usd
Write-Output "BOOM Liquidity Pool: $$liquidity"

# ------------------------
# 4. Auto-Delete Old Logs
# ------------------------
Write-Output "Deleting logs older than $days days in $logPath..."
Get-ChildItem -Path $logPath -Recurse -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$days) } | Remove-Item -Force
Write-Output "Old logs deleted."

# ------------------------
# 5. GitHub Repository Creation (Boomtoknlab)
# ------------------------
Write-Output "Creating GitHub repository under Boomtoknlab..."
$headers = @{ Authorization = "token $githubToken" }
$body = @{ name = "$repoName"; private = $false } | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri "https://api.github.com/orgs/Boomtoknlab/repos" -Method Post -Headers $headers -Body $body
Write-Output "GitHub repository $repoName created successfully."

# ------------------------
# 6. Execute Twinkle GitHub Action
# ------------------------
Write-Output "Triggering Twinkle GitHub Action..."
$twinkleHeaders = @{ Authorization = "token $githubToken" }
$twinklePayload = @{ event_type = "twinkle-action-run" } | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri "https://api.github.com/repos/Boomtoknlab/$twinkleRepo/dispatches" -Method Post -Headers $twinkleHeaders -Body $twinklePayload
Write-Output "Twinkle GitHub Action triggered."

# ------------------------
# 7. Execute Boom Token Reward GitHub Action
# ------------------------
Write-Output "Triggering Boom Token Reward GitHub Action..."
$rewardHeaders = @{ Authorization = "token $githubToken" }
$rewardPayload = @{ event_type = "boom-reward-run" } | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri "https://api.github.com/repos/Boomtoknlab/$rewardRepo/dispatches" -Method Post -Headers $rewardHeaders -Body $rewardPayload
Write-Output "Boom Token Reward GitHub Action triggered."

# ------------------------
# 8. Send Notifications (Telegram & Discord)
# ------------------------
Write-Output "Sending notifications..."
$telegramMessage = "BOOM Token Price: $$boomPrice\nLiquidity: $$liquidity\nBalance on Base: $balanceBase BOOM\nBalance on BSC: $balanceBSC BOOM"
Invoke-RestMethod -Uri "https://api.telegram.org/bot$telegramBotToken/sendMessage" -Method Post -Body @{ chat_id = $telegramChatID; text = $telegramMessage } | Out-Null
Write-Output "Telegram notification sent."

$discordMessage = @{ content = "BOOM Token Update:\nPrice: $$boomPrice\nLiquidity: $$liquidity\nBase: $balanceBase BOOM\nBSC: $balanceBSC BOOM" } | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri $discordWebhook -Method Post -Headers @{ "Content-Type" = "application/json" } -Body $discordMessage
Write-Output "Discord notification sent."

Write-Output "All tasks completed successfully!"
