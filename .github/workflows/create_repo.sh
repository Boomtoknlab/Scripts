#!/bin/sh

# Replace with your actual token
TOKEN="YOUR_PERSONAL_ACCESS_TOKEN"
REPO_NAME="my-new-repo"
DESCRIPTION="My new repository"
PRIVATE=false

# Create the repository
curl -H "Authorization: token $TOKEN" \
     -d "{\"name\":\"$REPO_NAME\", \"description\":\"$DESCRIPTION\", \"private\":$PRIVATE}" \
     https://api.github.com/user/repos
