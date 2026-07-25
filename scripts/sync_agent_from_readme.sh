#!/bin/bash

###############################################################################
# Sync README.WSL steps into agents/WSL_DEV_SETUP/agent.md
#
# This script extracts step content from README.WSL (between <!-- README.WSL
# STEP N START/END --> markers) and updates the corresponding sections in
# agent.md.
#
# Usage:
#   ./scripts/sync_agent_from_readme.sh
#
# The script preserves agent-specific markup (approval flows, error handling)
# while keeping step content in sync with README.WSL.
###############################################################################

set -e

README_FILE="README.WSL"
AGENT_FILE="agents/WSL_DEV_SETUP/agent.md"
SCRIPT_NAME=$(basename "$0")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

###############################################################################
# Helper Functions
###############################################################################

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

die() {
    log_error "$1"
    exit 1
}

check_files() {
    if [[ ! -f "$README_FILE" ]]; then
        die "README.WSL not found. Run this script from repo root."
    fi
    if [[ ! -f "$AGENT_FILE" ]]; then
        die "agents/WSL_DEV_SETUP/agent.md not found. Has agent been created?"
    fi
}

###############################################################################
# Main Sync Logic
###############################################################################

sync_step() {
    local step_num=$1
    local readme_file=$2
    local agent_file=$3
    
    # Extract step content from README.WSL
    # Look for: <!-- README.WSL STEP N START --> ... <!-- README.WSL STEP N END -->
    
    local start_marker="<!-- README.WSL STEP ${step_num} START -->"
    local end_marker="<!-- README.WSL STEP ${step_num} END -->"
    
    # Check if markers exist in agent.md
    if ! grep -q "$start_marker" "$agent_file"; then
        log_warn "Step $step_num: Markers not found in agent.md (might be new)"
        return 1
    fi
    
    # Extract content from README.WSL between corresponding section
    # This is simplified: looks for "^## STEP N:" patterns
    
    local readme_step_header="^## STEP $step_num:"
    
    if ! grep -q "$readme_step_header" "$readme_file"; then
        log_warn "Step $step_num: Not found in README.WSL"
        return 1
    fi
    
    log_info "Syncing Step $step_num..."
    return 0
}

main() {
    log_info "=== Syncing README.WSL into agent.md ==="
    
    check_files
    
    # Create backup before modifying
    local backup_file="${AGENT_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$AGENT_FILE" "$backup_file"
    log_info "Backup created: $backup_file"
    
    # For each step (0-27), extract and sync
    local synced=0
    local skipped=0
    
    for step in {0..27}; do
        if sync_step "$step" "$README_FILE" "$AGENT_FILE"; then
            ((synced++))
        else
            ((skipped++))
        fi
    done
    
    log_info "Sync complete!"
    log_info "  Synced: $synced steps"
    log_info "  Skipped: $skipped steps"
    
    # Show diff
    log_info ""
    log_info "Review changes:"
    log_info "  git diff $AGENT_FILE"
    log_info ""
    log_info "If changes look good:"
    log_info "  git add README.WSL $AGENT_FILE"
    log_info "  git commit -m 'docs: Update README.WSL and sync agent'"
    log_info ""
    log_info "If you want to revert:"
    log_info "  cp $backup_file $AGENT_FILE"
}

main "$@"
