#!/bin/bash

# Usage: ./check_and_create_branch.sh <repository_url> <branch_name>

repository_url=$1
branch_name=$2

# Clone the repository
git clone $repository_url temp_repo

# Move into the cloned repository directory
cd temp_repo || exit

# Check if the branch exists
if git rev-parse --quiet --verify "$branch_name"; then
    echo "Branch '$branch_name' exists in the repository."
else
    echo "Branch '$branch_name' does not exist in the repository. Creating..."
    # Create branch from master
    git checkout -b $branch_name origin/master
    echo "Branch '$branch_name' created successfully from master."
fi

# Clean up cloned repository
cd ..
rm -rf temp_repo


>>>>>>>>>>>>>>>>>>>>>>>>>.

#!/bin/bash

# Usage: ./check_and_create_branch.sh <repository_url> <branch_name>

repository_url=$1
branch_name=$2

# Extract owner and repository name from the URL
IFS='/' read -r -a url_parts <<< "$repository_url"
owner=${url_parts[3]}
repo=${url_parts[4]}

# Check if the branch exists
if curl --head --silent --fail "https://api.github.com/repos/$owner/$repo/branches/$branch_name"; then
    echo "Branch '$branch_name' exists in the repository."
else
    echo "Branch '$branch_name' does not exist in the repository. Creating..."
    # Create branch from master
    master_sha=$(curl -s "https://api.github.com/repos/$owner/$repo/git/refs/heads/master" | jq -r '.object.sha')
    create_branch_response=$(curl -s -X POST "https://api.github.com/repos/$owner/$repo/git/refs" \
        -H "Authorization: token <YOUR_GITHUB_TOKEN>" \
        -d "{\"ref\":\"refs/heads/$branch_name\",\"sha\":\"$master_sha\"}")
    if [[ $(echo "$create_branch_response" | jq -r '.ref') == "refs/heads/$branch_name" ]]; then
        echo "Branch '$branch_name' created successfully from master."
    else
        echo "Failed to create branch '$branch_name'."
    fi
fi

