# Git Quick Reference Card

Quick commands for daily Git workflow in BACKDRP.FM.

## 🌿 Branch Management

```bash
# Create feature branch
git feature video-sharing
git feature user-profile

# Create bug fix branch
git bugfix login-crash
git bugfix ios-issue

# Create hotfix branch
git hotfix critical-security-bug

# Switch branches
git com                    # Switch to main
git co feature/video       # Switch to feature branch

# View branches
git branches               # List all branches
git br                     # List local branches

# Delete merged branches
git cleanup
```

## 💾 Committing Changes

```bash
# Quick commit
git cm "feat(video): add sharing"

# Add all and commit
git ca "fix(auth): resolve timeout"

# Amend last commit
git amend

# Quick WIP commit
git wip

# Commit format examples
git cm "feat(auth): add Google login"
git cm "fix(video): resolve iOS crash"
git cm "test(profile): add widget tests"
git cm "docs(readme): update setup guide"
git cm "refactor(services): extract video service"
```

## 📤 Pushing & Pulling

```bash
# Push and set upstream
git psu

# Regular push
git ps

# Pull latest
git pl

# Update main
git com && git pull
```

## 📊 Status & Logs

```bash
# Short status
git st

# Full status
git s

# Pretty log graph
git lg

# Full history
git history

# Last commit
git last
```

## ↩️ Undoing Changes

```bash
# Undo last commit (keep changes)
git undo

# Undo last commit (discard changes)
git undohard

# Unstage files
git unstage

# Discard local changes
git checkout -- <file>
```

## 📦 Stashing

```bash
# Save work in progress
git ss

# List stashes
git sl

# Apply stash
git sa

# Stash including untracked
git stash-all
```

## 🔍 Viewing Changes

```bash
# View unstaged changes
git df

# View staged changes
git dfs

# Word diff
git dfw
```

## 🚀 Complete Workflow

### New Feature

```bash
# 1. Update main
git com
git pull

# 2. Create feature branch
git feature video-comments

# 3. Make changes and commit
git cm "feat(video): add comment system"

# 4. Push to remote
git psu

# 5. Create PR on GitHub
# 6. After merge
git com
git pull
git cleanup
```

### Bug Fix

```bash
# 1. Create fix branch
git bugfix profile-crash

# 2. Fix and commit
git cm "fix(profile): resolve crash on iOS"

# 3. Push and PR
git psu

# 4. Merge and cleanup
git com && git pull && git cleanup
```

### Hotfix (Critical)

```bash
# 1. Branch from main
git com && git pull
git hotfix security-patch

# 2. Fix immediately
git cm "fix(security): patch vulnerability"

# 3. Push and merge ASAP
git psu

# 4. Tag and release
git tag -a v1.0.1 -m "Hotfix: security patch"
git push origin v1.0.1
```

## 📋 Commit Message Types

```bash
feat      # New feature
fix       # Bug fix
docs      # Documentation
style     # Formatting
refactor  # Code refactoring
perf      # Performance
test      # Tests
chore     # Maintenance
build     # Build system
ci        # CI/CD
revert    # Revert commit
```

## 🏷️ Releases

```bash
# Create release tag
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0

# View tags
git tag -l

# Delete tag
git tag -d v1.0.0
git push origin --delete v1.0.0
```

## 🔧 Pre-commit Hook

Automatically runs:
- ✅ flutter analyze
- ✅ flutter format check
- ✅ flutter test
- ✅ Debug statement check
- ✅ Sensitive file check

**Skip (emergency only):**
```bash
git commit --no-verify -m "emergency"
```

## 📝 Commit Format

```
<type>(<scope>): <subject>

Examples:
feat(auth): add Google Sign-In
fix(video): resolve playback crash
test(profile): add unit tests
docs(api): update API documentation
```

## 🎯 Branch Naming

```
feature/video-sharing
fix/login-timeout
hotfix/critical-bug
refactor/auth-service
test/integration-tests
docs/api-guide
chore/update-deps
```

## 🆘 Emergency Commands

```bash
# Undo last commit (keep work)
git undo

# Discard all local changes
git undohard

# Abort merge
git merge --abort

# Abort rebase
git rebase --abort

# Force pull (CAREFUL!)
git fetch origin
git reset --hard origin/main
```

## 🔥 One-Liners

```bash
# Create feature and commit
git feature auth && git cm "feat(auth): add login"

# Add all, commit, push
git ca "fix(bug): quick fix" && git ps

# Update main and create branch
git com && git pull && git feature new-feature

# Cleanup after merge
git com && git pull && git cleanup

# Quick status
git st

# View last 5 commits
git lg -5
```

## 💡 Pro Tips

1. **Always create a branch**: Never commit directly to main
2. **Pull before branching**: `git com && git pull` before creating new branch
3. **Commit often**: Small, focused commits are better
4. **Use descriptive names**: Both for branches and commits
5. **Clean up merged branches**: Run `git cleanup` regularly
6. **Check before pushing**: `git st` and `git lg` before `git ps`

## 📚 View All Aliases

```bash
git aliases
```

## 🔗 Quick Links

- Full Guide: `GIT_WORKFLOW.md`
- Setup Complete: `GIT_SETUP_COMPLETE.md`
- Integration Tests: `INTEGRATION_TEST_SETUP.md`

---

**Print this and keep it handy!** 🎯
