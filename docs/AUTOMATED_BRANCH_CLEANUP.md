# Automated Branch Cleanup

This repository includes an automated GitHub Action that performs regular branch cleanup to prevent the accumulation of obsolete branches.

## Overview

The **Automated Branch Cleanup** workflow automatically identifies and removes branches that are no longer needed, while protecting important branches like `main`, `master`, `develop`, and release branches.

## Key Features

- ✅ **Scheduled Execution**: Runs monthly (1st of each month at 2 AM UTC)
- ✅ **Manual Triggering**: Can be run on-demand via GitHub Actions UI
- ✅ **Dry Run Mode**: Safe preview mode to see what would be deleted
- ✅ **Configurable Protection**: Customize which branches to protect
- ✅ **Comprehensive Logging**: Detailed output and summary reports
- ✅ **Wildcard Support**: Protect branch patterns like `release/*` or `hotfix/*`

## How to Use

### Manual Execution

1. Navigate to the **Actions** tab in your GitHub repository
2. Click on **"Automated Branch Cleanup"** workflow
3. Click **"Run workflow"** button
4. Configure options:
   - **Dry Run**: Check this to preview changes without deleting branches (recommended)
   - **Protected Branches**: Specify comma-separated patterns of branches to protect

### Example Configurations

#### Standard Protection (Default)
```
main,master,develop,release/*,hotfix/*
```

#### Minimal Protection
```
main,production
```

#### Extended Protection
```
main,develop,staging,feature/important-*,release/*,hotfix/*
```

## Default Behavior

- **Scheduled runs**: Automatically delete obsolete branches (no dry run)
- **Manual runs**: Default to dry run mode for safety
- **Protected branches**: `main,master,develop,release/*,hotfix/*`

## Current Repository Status

This repository currently has multiple `copilot/fix-*` branches that were created during development. The automated cleanup will:

1. Identify all branches in the repository
2. Protect the `main` branch and any other specified protected branches
3. Delete all `copilot/fix-*` branches (they are temporary/obsolete)
4. Provide a detailed log of the cleanup process

## Safety Features

- **Dry Run Default**: Manual executions default to preview mode
- **Pattern Matching**: Exact and wildcard pattern support for protected branches
- **Comprehensive Logging**: See exactly what will be or was deleted
- **Error Handling**: Failed deletions are logged but don't stop the process
- **Final Verification**: Reports remaining branches after cleanup

## Integration with Existing Tools

This automation complements the existing manual cleanup tools:

- **cleanup-branches.sh**: Manual script for immediate cleanup
- **BRANCH_CLEANUP.md**: Documentation of cleanup procedures
- **GitHub Action**: Automated scheduled cleanup

## Monitoring

After each cleanup (when not in dry run mode), the workflow generates:

1. **Console logs** with detailed step-by-step output
2. **Summary report** showing what was protected vs. deleted
3. **Final state verification** listing remaining branches

## Support

For issues or questions about the automated branch cleanup:

1. Check the workflow logs in the Actions tab
2. Review the configuration in `.github/workflows/branch-cleanup.yml`
3. Test changes using dry run mode first
4. Refer to `BRANCH_CLEANUP.md` for additional context