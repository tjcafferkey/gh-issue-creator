#!/bin/bash

# This script creates multiple GitHub issues from a CSV file
# CSV format should be: title,body,labels (comma-separated)
# Example: "Fix login bug","The login form doesn't validate email","bug,high-priority"
# Command: ./create-issues.sh issues.csv woocommerce/woocommerce

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI is not installed. Please install it first:"
    echo "https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "Please login to GitHub CLI first using: gh auth login"
    exit 1
fi

# Check arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <issues.csv> [repository]"
    echo "Example: $0 issues.csv username/repo"
    echo "If repository is not specified, uses the current directory's repository"
    exit 1
fi

input_file="$1"
repository="$2"

# Check if file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File $input_file not found"
    exit 1
fi

# If repository is provided, set it as the current repository
if [ ! -z "$repository" ]; then
    echo "Creating issues in repository: $repository"
    repo_arg="--repo $repository"
else
    echo "Creating issues in current repository"
    repo_arg=""
fi

# Print CSV contents for debugging
echo "Reading issues from CSV:"
cat "$input_file"
echo "---"

# Read CSV and create issues
# Skip header line and process each row
while IFS=, read -r title body labels || [ -n "$title" ]; do
    # Remove quotes and trim whitespace
    title=$(echo "$title" | tr -d '"' | xargs)
    body=$(echo "$body" | tr -d '"' | xargs)
    labels=$(echo "$labels" | tr -d '"' | xargs)
    
    # Skip header row
    if [ "$title" = "title" ]; then
        continue
    fi
    
    # Skip empty rows
    if [ -z "$title" ]; then
        continue
    fi
    
    echo "Processing issue: $title"
    
    # Try to create with labels first, fall back to no labels if it fails
    if [ ! -z "$labels" ]; then
        echo "Attempting to create issue with labels: $labels"
        gh issue create $repo_arg --title "$title" --body "$body" --label "$labels" || {
            echo "Note: Some labels don't exist. Creating issue without labels..."
            gh issue create $repo_arg --title "$title" --body "$body"
        }
    else
        echo "Creating issue without labels"
        gh issue create $repo_arg --title "$title" --body "$body"
    fi
    
    # Add a small delay to avoid rate limiting
    sleep 1
done < "$input_file"

echo "All issues have been created!"