#!/bin/bash

# Repository Branch Cleanup Script
# This script removes all copilot/* branches to streamline the repository
# Run this script with appropriate permissions to clean up both local and remote branches

set -e

echo "Starting repository branch cleanup..."
echo "Current branch: $(git branch --show-current)"

# Ensure we're on main branch
if [ "$(git branch --show-current)" != "main" ]; then
    echo "Switching to main branch..."
    git checkout main
fi

echo ""
echo "=== LISTING BRANCHES TO BE DELETED ==="

# List all copilot branches (local and remote)
echo "Local copilot branches:"
git branch | grep -E "^\s*copilot/" || echo "  (none found)"

echo ""
echo "Remote copilot branches:"
git ls-remote --heads origin | grep "copilot/" | sed 's/.*refs\/heads\//  /' || echo "  (none found)"

echo ""
echo "=== DELETING LOCAL COPILOT BRANCHES ==="

# Delete local copilot branches
for branch in $(git branch | grep -E "^\s*copilot/" | sed 's/^\s*//'); do
    echo "Deleting local branch: $branch"
    git branch -D "$branch"
done

echo ""
echo "=== DELETING REMOTE COPILOT BRANCHES ==="

# List of remote copilot branches to delete (identified from git ls-remote)
remote_branches=(
    "copilot/fix-9852002c-2c5d-4738-8110-c1211a19b711"
    "copilot/fix-9aad2147-9ea5-494d-b88a-e5d9817183d4"
    "copilot/fix-a113d2e0-5946-4325-a698-49bb446ddfdf"
    "copilot/fix-add6b6e0-ac13-41b2-99d6-9c2200d4b427"
    "copilot/fix-c93868bf-3eeb-4455-abe3-79990bb10d76"
    "copilot/fix-daeaa56a-6264-492c-9454-2644dc2d104f"
    "copilot/fix-ec264cb5-e87d-4b7a-bba1-8bdd9f358e37"
    "copilot/fix-f5b33083-e598-43d2-a2fc-4885dbae2829"
    "copilot/fix-fb1624c3-19e4-4df1-93d0-6438cef8182f"
)

# Delete remote branches
for branch in "${remote_branches[@]}"; do
    echo "Deleting remote branch: $branch"
    git push origin --delete "$branch" || echo "  Warning: Failed to delete $branch (may not exist or insufficient permissions)"
done

echo ""
echo "=== CLEANING UP REMOTE TRACKING REFERENCES ==="

# Clean up remote tracking references
git remote prune origin

echo ""
echo "=== FINAL VERIFICATION ==="

echo "Remaining local branches:"
git branch

echo ""
echo "Remaining remote branches:"
git ls-remote --heads origin

echo ""
echo "Branch cleanup completed!"
echo "Repository now contains only the main branch and any other necessary branches."