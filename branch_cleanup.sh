#!/bin/bash

# Branch Cleanup Script for extending-move repository
# This script removes obsolete copilot branches as specified in the cleanup requirements
# 
# Generated on: $(date)
# Repository: peterswimm/extending-move

echo "Starting branch cleanup for extending-move repository..."
echo "This script will delete 8 copilot branches that are no longer needed."
echo ""

# Fetch the latest changes to ensure we have the most up-to-date branch information
echo "Fetching latest changes from origin..."
git fetch origin

echo ""
echo "Current branches before cleanup:"
git ls-remote origin | grep copilot

echo ""
echo "Deleting obsolete copilot branches..."

# Delete each specified branch from the remote repository
echo "1/8 Deleting copilot/fix-9aad2147-9ea5-494d-b88a-e5d9817183d4..."
git push origin --delete copilot/fix-9aad2147-9ea5-494d-b88a-e5d9817183d4

echo "2/8 Deleting copilot/fix-9852002c-2c5d-4738-8110-c1211a19b711..."
git push origin --delete copilot/fix-9852002c-2c5d-4738-8110-c1211a19b711

echo "3/8 Deleting copilot/fix-a113d2e0-5946-4325-a698-49bb446ddfdf..."
git push origin --delete copilot/fix-a113d2e0-5946-4325-a698-49bb446ddfdf

echo "4/8 Deleting copilot/fix-add6b6e0-ac13-41b2-99d6-9c2200d4b427..."
git push origin --delete copilot/fix-add6b6e0-ac13-41b2-99d6-9c2200d4b427

echo "5/8 Deleting copilot/fix-daeaa56a-6264-492c-9454-2644dc2d104f..."
git push origin --delete copilot/fix-daeaa56a-6264-492c-9454-2644dc2d104f

echo "6/8 Deleting copilot/fix-ec264cb5-e87d-4b7a-bba1-8bdd9f358e37..."
git push origin --delete copilot/fix-ec264cb5-e87d-4b7a-bba1-8bdd9f358e37

echo "7/8 Deleting copilot/fix-f5b33083-e598-43d2-a2fc-4885dbae2829..."
git push origin --delete copilot/fix-f5b33083-e598-43d2-a2fc-4885dbae2829

echo "8/8 Deleting copilot/fix-fb1624c3-19e4-4df1-93d0-6438cef8182f..."
git push origin --delete copilot/fix-fb1624c3-19e4-4df1-93d0-6438cef8182f

echo ""
echo "Branch cleanup completed!"
echo ""
echo "Remaining branches after cleanup:"
git ls-remote origin | grep -E "(main|copilot)"

echo ""
echo "Expected remaining branches:"
echo "- main (primary branch)"
echo "- copilot/fix-c93868bf-3eeb-4455-abe3-79990bb10d76 (current working branch - not deleted)"

echo ""
echo "Cleanup summary:"
echo "✓ Deleted 8 obsolete copilot branches"
echo "✓ Preserved main branch" 
echo "✓ Preserved current working branch (copilot/fix-c93868bf-3eeb-4455-abe3-79990bb10d76)"