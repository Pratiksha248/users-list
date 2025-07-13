#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token (must be set as environment variables)
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
            echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
        else
            echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
            echo "$collaborators"
        fi
    else
        echo "❌ Unexpected response from GitHub API:"
        echo "$response" | jq .
        echo "⚠️  Possible causes:"
        echo "   - Repository '${REPO_OWNER}/${REPO_NAME}' does not exist"
        echo "   - Invalid GitHub token or insufficient permissions"
        echo "   - API rate limit exceeded"
        exit 1
    fi
}

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
