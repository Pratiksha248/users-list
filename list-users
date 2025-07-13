#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    response="$(github_api_get "$endpoint")"

    # Check if the response is a valid array (expected format)
    if echo "$response" | jq -e 'type == "array"' > /dev/null; then
        collaborators="$(echo "$response" | jq -r '.[] | select(.permissions.pull == true) | .login')"

        # Display the list of collaborators with read access
        if [[ -z "$collaborators" ]]; then
            echo "No use
