#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="/Users/thanhnguyen99/Documents/du_an_ca_nhan/chat_888"
NOTES_FILE="/ghi_chu.md"
LAST_COMMIT=10db7bd
AUTHOR=ThanhNguyen99IT
DATE=2025-09-01 18:49:52 +0700
SUBJECT=✨ Add animated bottom navigation bar with smooth transitions and improved UX
BODY=- Add custom bottom navigation bar with animated bump effect
- Implement smooth icon and circle transitions between tabs
- Remove text labels for cleaner UI
- Increase icon sizes for better touch targets
- Add HitTestBehavior.opaque for larger click areas
- Implement proper animation controller with null safety
- Add 4 main pages: Home, Contacts, Posts, Profile
- Update app structure to use MainPage as entry point

{
  echo "## Commit "
  echo "- Author: "
  echo "- Date: "
  echo "- Title: "
  if [[ -n "" ]]; then
    echo "- Notes: |"
    # indent body
    echo "" | sed s/^/
