# Git Workflow Guide for BACKDRP.FM

This document outlines the Git workflow and best practices for the BACKDRP.FM project.

## Table of Contents

- [Branch Strategy](#branch-strategy)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)
- [Git Hooks](#git-hooks)
- [Useful Commands](#useful-commands)

## Branch Strategy

We follow **GitHub Flow** - a lightweight, branch-based workflow.

### Main Branches

**`main`**
- Production-ready code
- Always deployable
- Protected branch (requires PR for changes)
- All commits must pass CI/CD checks

### Working Branches

Create feature branches off `main` using descriptive names:

```bash
# Feature development
git feature user-authentication
git feature video-sharing

# Bug fixes
git bugfix login-timeout
git bugfix video-playback-crash

# Hotfixes (urgent production fixes)
git hotfix critical-auth-bug

# Refactoring
git cob refactor/service-layer
git cob refactor/video-player

# Testing
git cob test/integration-tests
git cob test/profile-screen
```

### Branch Naming Convention

```
<type>/<description>

Types:
- feature/   New features or enhancements
- fix/       Bug fixes
- hotfix/    Critical production fixes
- refactor/  Code refactoring
- test/      Adding or updating tests
- docs/      Documentation changes
- chore/     Maintenance tasks
```

**Examples:**
- `feature/video-comments`
- `fix/ios-crash-on-login`
- `hotfix/security-patch`
- `refactor/auth-service`
- `test/video-player-integration`

## Commit Messages

We use **Conventional Commits** format for clear, structured commit history.

### Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, no logic changes)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks
- **build**: Build system changes
- **ci**: CI/CD changes
- **revert**: Reverting a previous commit

### Scope

The scope should be the name of the affected module:
- `auth`
- `video`
- `profile`
- `artist`
- `search`
- `settings`

### Examples

```bash
feat(auth): add Google Sign-In integration
fix(video): resolve crash on iOS when loading video
docs(readme): update installation instructions
test(profile): add profile screen widget tests
refactor(services): extract video service into separate class
perf(video): optimize video thumbnail loading
chore(deps): update Firebase dependencies to v4.0.0
```

### Quick Commits

```bash
# Using alias
git cm "feat(video): add video sharing"

# Stage all and commit
git ca "fix(auth): resolve login timeout"

# Quick WIP commit
git wip
```

## Pull Request Process

### 1. Create Feature Branch

```bash
# Create and switch to new branch
git feature video-comments

# Or use checkout
git cob feature/video-comments
```

### 2. Make Changes and Commit

```bash
# Make your changes
# ...

# Stage changes
git add .

# Commit with conventional commit message
git cm "feat(video): add comment functionality"

# The pre-commit hook will automatically:
# - Run flutter analyze
# - Check code formatting
# - Run unit tests
# - Check for debug statements
# - Prevent committing sensitive files
```

### 3. Push to Remote

```bash
# Push and set upstream
git psu

# Or explicit push
git push -u origin feature/video-comments
```

### 4. Create Pull Request

1. Go to GitHub repository
2. Click "Pull Request"
3. Fill out the PR template (auto-populated)
4. Request reviewers
5. Wait for CI/CD checks to pass

### 5. Code Review

- Address reviewer comments
- Make changes and push to same branch
- CI/CD runs automatically on each push
- Get approval from reviewer(s)

### 6. Merge

Once approved and all checks pass:
1. **Squash and merge** (recommended) - for clean history
2. **Merge commit** - preserves all commits
3. Delete the feature branch after merge

```bash
# After merge, update local main
git com
git pull
git cleanup  # Delete merged local branches
```

## Release Process

### Version Numbering

Follow **Semantic Versioning** (SemVer):
```
MAJOR.MINOR.PATCH

1.0.0 - Initial release
1.1.0 - New features (backward compatible)
1.1.1 - Bug fixes
2.0.0 - Breaking changes
```

### Creating a Release

```bash
# 1. Ensure you're on main and up to date
git com
git pull

# 2. Create and push tag
git tag -a v1.2.0 -m "Release v1.2.0 - Add video sharing feature"
git push origin v1.2.0

# 3. Create release on GitHub
# Go to Releases → Create new release
# - Tag: v1.2.0
# - Title: v1.2.0 - Video Sharing
# - Description: List of changes
# - Attach build artifacts (optional)
```

### Pre-release Versions

```bash
# Beta releases
git tag -a v1.2.0-beta.1 -m "Beta release"

# Release candidates
git tag -a v1.2.0-rc.1 -m "Release candidate 1"
```

### Update Version in pubspec.yaml

```yaml
version: 1.2.0+10
# Format: version+buildNumber
```

## Git Hooks

### Pre-commit Hook

Automatically runs before each commit:
- ✅ Flutter analyze
- ✅ Code formatting check
- ✅ Unit tests
- ✅ Debug statement detection
- ✅ Sensitive file protection

**To skip (use sparingly):**
```bash
git commit --no-verify -m "message"
```

### Commit-msg Hook

Validates commit messages follow conventional commits format.

**To temporarily disable:**
```bash
git commit --no-verify -m "your message"
```

## Useful Commands

### Status & Info

```bash
git st              # Short status
git s               # Full status
git lg              # Pretty log graph
git history         # Full history
git last            # Last commit details
```

### Branching

```bash
git feature X       # Create feature/X branch
git bugfix X        # Create fix/X branch
git branches        # List all branches
git cleanup         # Delete merged branches
```

### Committing

```bash
git cm "message"    # Commit with message
git ca "message"    # Add all and commit
git amend           # Amend last commit
git wip             # Quick WIP commit
```

### Undoing Changes

```bash
git undo            # Undo last commit (keep changes)
git undohard        # Undo last commit (discard changes)
git unstage         # Unstage files
```

### Stashing

```bash
git ss              # Stash changes
git sl              # List stashes
git sa              # Apply stash
git stash-all       # Stash including untracked files
```

### Viewing Changes

```bash
git df              # View unstaged changes
git dfs             # View staged changes
git dfw             # Word diff
```

### Syncing

```bash
git pl              # Pull from remote
git ps              # Push to remote
git psu             # Push and set upstream
git pf              # Force push (with lease)
```

## Best Practices

### Do's ✅

- ✅ Create feature branches for all changes
- ✅ Write descriptive commit messages
- ✅ Keep commits focused and atomic
- ✅ Run tests before pushing
- ✅ Pull latest changes before creating new branches
- ✅ Request code reviews for all PRs
- ✅ Delete branches after merging
- ✅ Use conventional commit format
- ✅ Keep main branch stable and deployable

### Don'ts ❌

- ❌ Commit directly to main
- ❌ Force push to main
- ❌ Commit sensitive files (.env, keys, etc.)
- ❌ Skip pre-commit hooks without good reason
- ❌ Create overly large commits
- ❌ Use vague commit messages ("fix bug", "update")
- ❌ Leave branches unmerged for long periods
- ❌ Commit commented-out code
- ❌ Commit debug/console logs

## CI/CD Pipeline

All branches are automatically tested via GitHub Actions:

**On Push/PR to main:**
1. ✅ Code analysis (`flutter analyze`)
2. ✅ Format check (`flutter format`)
3. ✅ Unit tests (`flutter test`)
4. ✅ Build iOS (macOS runner)
5. ✅ Build Android (Ubuntu runner)
6. ✅ Build macOS (macOS runner)
7. ✅ Integration tests (optional)

**Check Results:**
- View in GitHub Actions tab
- Must pass before merging
- Fix any failures before requesting review

## Emergency Procedures

### Hotfix Process

For critical production bugs:

```bash
# 1. Create hotfix branch from main
git com
git pull
git hotfix critical-security-issue

# 2. Make minimal fix
# ...

# 3. Commit with fix type
git cm "fix(security): patch XSS vulnerability"

# 4. Push and create PR immediately
git psu

# 5. Fast-track review and merge
# 6. Tag and release immediately
git tag -a v1.2.1 -m "Hotfix: Security patch"
git push origin v1.2.1
```

### Reverting Changes

```bash
# Revert a commit
git revert <commit-hash>

# Revert a merge
git revert -m 1 <merge-commit-hash>

# Push revert
git push
```

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Git Documentation](https://git-scm.com/doc)

## Questions?

If you have questions about the Git workflow:
1. Check this document first
2. Ask in team discussions
3. Create an issue for workflow improvements
