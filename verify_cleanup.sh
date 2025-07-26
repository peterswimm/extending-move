#!/bin/bash

# Branch Status Verification Script
# This script checks the current state of branches in the extending-move repository

echo "Branch Status Verification for extending-move repository"
echo "======================================================="
echo ""

# Fetch latest information
echo "Fetching latest branch information..."
git fetch origin 2>/dev/null

echo ""
echo "Current remote branches:"
echo "------------------------"
git ls-remote origin | grep refs/heads/ | sort

echo ""
echo "Copilot branches analysis:"
echo "---------------------------"

# Check for the branches that should be deleted
branches_to_delete=(
    "copilot/fix-9aad2147-9ea5-494d-b88a-e5d9817183d4"
    "copilot/fix-9852002c-2c5d-4738-8110-c1211a19b711"
    "copilot/fix-a113d2e0-5946-4325-a698-49bb446ddfdf"
    "copilot/fix-add6b6e0-ac13-41b2-99d6-9c2200d4b427"
    "copilot/fix-daeaa56a-6264-492c-9454-2644dc2d104f"
    "copilot/fix-ec264cb5-e87d-4b7a-bba1-8bdd9f358e37"
    "copilot/fix-f5b33083-e598-43d2-a2fc-4885dbae2829"
    "copilot/fix-fb1624c3-19e4-4df1-93d0-6438cef8182f"
)

deleted_count=0
remaining_count=0

for branch in "${branches_to_delete[@]}"; do
    if git ls-remote origin | grep -q "refs/heads/$branch"; then
        echo "❌ STILL EXISTS: $branch"
        ((remaining_count++))
    else
        echo "✅ DELETED: $branch"
        ((deleted_count++))
    fi
done

echo ""
echo "Branches that should be preserved:"
echo "----------------------------------"

# Check main branch
if git ls-remote origin | grep -q "refs/heads/main"; then
    echo "✅ PRESERVED: main"
else
    echo "❌ MISSING: main (this should exist!)"
fi

# Check current working branch
if git ls-remote origin | grep -q "refs/heads/copilot/fix-c93868bf-3eeb-4455-abe3-79990bb10d76"; then
    echo "✅ PRESERVED: copilot/fix-c93868bf-3eeb-4455-abe3-79990bb10d76 (current working branch)"
else
    echo "❌ MISSING: copilot/fix-c93868bf-3eeb-4455-abe3-79990bb10d76 (current working branch)"
fi

echo ""
echo "Summary:"
echo "--------"
echo "Branches to delete: 8 total"
echo "Already deleted: $deleted_count"
echo "Still remaining: $remaining_count"

if [ $remaining_count -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS: All target branches have been deleted!"
    echo "✅ Repository cleanup is complete."
else
    echo ""
    echo "⚠️  PENDING: $remaining_count branches still need to be deleted."
    echo "📋 Run the branch_cleanup.sh script to complete the cleanup."
fi

echo ""
echo "All copilot branches currently on remote:"
git ls-remote origin | grep "refs/heads/copilot" | cut -d'/' -f3- | sort