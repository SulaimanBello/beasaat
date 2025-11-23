#!/bin/bash

# Update repository from GitHub by cloning to temp and copying files
# Usage: ./update-from-github.sh

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Update Repository from GitHub ===${NC}"
echo ""

# Get the remote repository URL
REPO_URL=$(git remote get-url origin)
if [ -z "$REPO_URL" ]; then
    echo -e "${RED}Error: No git remote 'origin' found${NC}"
    exit 1
fi

echo -e "${BLUE}Repository URL: $REPO_URL${NC}"
echo ""

# Get current directory
CURRENT_DIR=$(pwd)
CURRENT_DIR_NAME=$(basename "$CURRENT_DIR")

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo -e "${BLUE}Cloning repository to temporary location...${NC}"
echo -e "${YELLOW}Note: You may be prompted for your SSH passphrase if using SSH keys${NC}"
echo ""

# Enable terminal prompts for git (important for authentication)
export GIT_TERMINAL_PROMPT=1

# Configure SSH to allow interactive passphrase input
export GIT_SSH_COMMAND="ssh -o BatchMode=no -o StrictHostKeyChecking=no"

# Clone the repository to temp directory with full output
git clone "$REPO_URL" "$TEMP_DIR/repo"

# Check if clone was successful
if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}Error: Failed to clone repository${NC}"
    echo -e "${YELLOW}This could be due to:${NC}"
    echo -e "  - Authentication failure (wrong passphrase)"
    echo -e "  - SSH key not configured"
    echo -e "  - Network connection issues"
    echo -e "  - Repository access permissions"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo ""

echo -e "${BLUE}Updating files in current directory...${NC}"

# Copy files from temp to current directory (excluding .git directory)
# Try rsync first (better at preserving permissions and handling edge cases)
if command -v rsync &> /dev/null; then
    rsync -av --exclude='.git' "$TEMP_DIR/repo/" "$CURRENT_DIR/"
    COPY_STATUS=$?
else
    # Fallback to cp if rsync is not available
    echo -e "${YELLOW}rsync not found, using cp instead...${NC}"
    # Copy all files including hidden ones
    cp -rf "$TEMP_DIR/repo/"* "$CURRENT_DIR/" 2>/dev/null || true
    # Copy hidden files (excluding . and ..)
    find "$TEMP_DIR/repo" -mindepth 1 -maxdepth 1 -name '.*' ! -name '.git' -exec cp -rf {} "$CURRENT_DIR/" \; 2>/dev/null || true
    COPY_STATUS=$?
fi

if [ $COPY_STATUS -ne 0 ]; then
    echo -e "${RED}Warning: Some files may not have been copied correctly${NC}"
fi

# Clean up temp directory
echo -e "${BLUE}Cleaning up temporary directory...${NC}"
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}✓ Repository updated successfully!${NC}"
echo -e "${BLUE}Files have been updated from: $REPO_URL${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  - Run 'git status' to see the changes"
echo "  - Run 'git diff' to review specific changes"
echo "  - Commit changes if needed with 'git add .' and 'git commit'"
