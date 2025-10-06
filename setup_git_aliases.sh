#!/bin/bash

# Setup Git Aliases for BACKDRP.FM
# This script configures useful git aliases for improved workflow

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 Setting up Git aliases for BACKDRP.FM${NC}\n"

# Status aliases
echo -e "${YELLOW}Setting up status aliases...${NC}"
git config --global alias.st "status -sb"
git config --global alias.s "status"

# Log aliases
echo -e "${YELLOW}Setting up log aliases...${NC}"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.ll "log --pretty=format:'%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]' --decorate --numstat"
git config --global alias.last "log -1 HEAD --stat"
git config --global alias.history "log --graph --oneline --decorate --all"

# Commit aliases
echo -e "${YELLOW}Setting up commit aliases...${NC}"
git config --global alias.cm "commit -m"
git config --global alias.ca "commit -am"
git config --global alias.amend "commit --amend --no-edit"
git config --global alias.amendm "commit --amend -m"

# Branch aliases
echo -e "${YELLOW}Setting up branch aliases...${NC}"
git config --global alias.br "branch"
git config --global alias.branches "branch -a"
git config --global alias.co "checkout"
git config --global alias.cob "checkout -b"
git config --global alias.cod "checkout develop"
git config --global alias.com "checkout main"

# Cleanup aliases
echo -e "${YELLOW}Setting up cleanup aliases...${NC}"
git config --global alias.cleanup "!git branch --merged | grep -v '\\*\\|main\\|develop' | xargs -n 1 git branch -d"
git config --global alias.prune-remote "remote prune origin"

# Diff aliases
echo -e "${YELLOW}Setting up diff aliases...${NC}"
git config --global alias.df "diff"
git config --global alias.dfs "diff --staged"
git config --global alias.dfw "diff --word-diff"

# Stash aliases
echo -e "${YELLOW}Setting up stash aliases...${NC}"
git config --global alias.stash-all "stash save --include-untracked"
git config --global alias.sl "stash list"
git config --global alias.sa "stash apply"
git config --global alias.ss "stash save"

# Undo aliases
echo -e "${YELLOW}Setting up undo aliases...${NC}"
git config --global alias.undo "reset HEAD~1 --soft"
git config --global alias.undohard "reset HEAD~1 --hard"
git config --global alias.unstage "reset HEAD --"

# Pull/Push aliases
echo -e "${YELLOW}Setting up pull/push aliases...${NC}"
git config --global alias.pl "pull"
git config --global alias.ps "push"
git config --global alias.psu "push -u origin HEAD"
git config --global alias.pf "push --force-with-lease"

# Other useful aliases
echo -e "${YELLOW}Setting up miscellaneous aliases...${NC}"
git config --global alias.contributors "shortlog -sn --all --no-merges"
git config --global alias.aliases "config --get-regexp alias"
git config --global alias.wip "commit -am 'WIP: work in progress'"
git config --global alias.save "!git add -A && git commit -m 'SAVEPOINT'"
git config --global alias.wipe "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard"

# BACKDRP.FM specific aliases
echo -e "${YELLOW}Setting up BACKDRP.FM specific aliases...${NC}"
git config alias.test-commit "!git add . && git commit -m 'test: add tests' && git push"
git config alias.feature "!f() { git checkout -b feature/\$1; }; f"
git config alias.bugfix "!f() { git checkout -b fix/\$1; }; f"
git config alias.hotfix "!f() { git checkout -b hotfix/\$1; }; f"

echo ""
echo -e "${GREEN}✅ Git aliases configured successfully!${NC}"
echo ""
echo -e "${BLUE}Available aliases:${NC}"
echo ""
echo -e "${YELLOW}Status:${NC}"
echo "  git st          - Short status"
echo "  git s           - Full status"
echo ""
echo -e "${YELLOW}Logs:${NC}"
echo "  git lg          - Pretty graph log"
echo "  git ll          - Log with file stats"
echo "  git last        - Last commit details"
echo "  git history     - Full history graph"
echo ""
echo -e "${YELLOW}Commits:${NC}"
echo "  git cm          - Commit with message"
echo "  git ca          - Commit all with message"
echo "  git amend       - Amend last commit (no edit)"
echo "  git wip         - Quick WIP commit"
echo ""
echo -e "${YELLOW}Branches:${NC}"
echo "  git co          - Checkout"
echo "  git cob         - Checkout new branch"
echo "  git feature X   - Create feature/X branch"
echo "  git bugfix X    - Create fix/X branch"
echo "  git cleanup     - Delete merged branches"
echo ""
echo -e "${YELLOW}Undo:${NC}"
echo "  git undo        - Undo last commit (keep changes)"
echo "  git undohard    - Undo last commit (discard changes)"
echo "  git unstage     - Unstage files"
echo ""
echo -e "${YELLOW}View all aliases:${NC}"
echo "  git aliases"
echo ""
