#!/usr/bin/env bash
set -euo pipefail

# Default path for the git and ssh executables.
GIT_CMD="${GIT_CMD:-git}"
SSH_CMD="${SSH_CMD:-ssh}"

# Check if github.com is reachable (offline or sandboxed builder)
if ! getent hosts github.com &>/dev/null; then
  echo "Warning: github.com is unreachable. Skipping all clones." >&2
  exit 0
fi

# Ensure git uses the same ssh binary as defined in SSH_CMD.
export GIT_SSH_COMMAND="$SSH_CMD"

if ! command -v "$GIT_CMD" &> /dev/null; then
  echo "Error: Git command not found at '$GIT_CMD'." >&2
  echo "Please install git or provide a valid path via GIT_CMD env var." >&2
  exit 1
fi

# Check if SSH to GitHub is available.
SSH_AVAILABLE=false
if command -v "$SSH_CMD" &>/dev/null; then
  set +eo pipefail
  SSH_OUTPUT=$("$SSH_CMD" -o BatchMode=yes -o ConnectTimeout=2 -T git@github.com 2>&1)
  set -eo pipefail
  if echo "$SSH_OUTPUT" | grep -q "successfully authenticated"; then
    SSH_AVAILABLE=true
    echo "ssh git@github.com works!" >&2
  else
    echo "ssh command is available, but '$SSH_CMD git@github.com' failed: $SSH_OUTPUT" >&2
  fi
else
  echo "ssh command is not available (tried '$SSH_CMD')" >&2
fi

# Clones a GitHub repository if it doesn't already exist locally, and prints the target directory path.
#   @param {string} $1 The GitHub repository, in "owner/repo" format, or a full git URL.
clone() {
  local repo="$1"
  repo="${repo#https://github.com/}"
  repo="${repo#git@github.com:}"
  repo="${repo%.git}"
  local owner="${repo%%/*}"
  local protocol="https"

  if [[ "$owner" =~ ^(vorburger|MariaDB4j|enola-dev)$ ]] && [ "$SSH_AVAILABLE" == "true" ]; then
    protocol="ssh"
  fi

  local repo_url
  if [ "$protocol" == "ssh" ]; then
    repo_url="git@github.com:$repo.git"
  else
    repo_url="https://github.com/$repo.git"
  fi

  local target_dir="$HOME/git/github.com/$repo"
  if [ ! -d "$target_dir" ]; then
    echo "Cloning '$repo_url' into '$target_dir'..." >&2
    mkdir -p "$(dirname "$target_dir")"
    "$GIT_CMD" clone "$repo_url" "$target_dir"
    cd "$target_dir"

    if [ "$protocol" == "https" ]; then
      local repo_name="${repo##*/}"
      local fork_url="git@github.com:vorburger/$repo_name.git"
      "$GIT_CMD" remote add vorburger "$fork_url"
    fi
  # SILENCE!
  # else
  #   echo "Directory '$target_dir' already exists. Skipping." >&2
  fi

  # NOTE: This 'echo' is NOT informational for the user, but it's this function's return value!!
  echo "$target_dir"
}

if [ "$#" -eq 0 ]; then
    clone vorburger/dotfiles
    clone vorburger/nixfiles
    clone vorburger/aifiles

    clone scopatz/nanorc
    clone seitz/nanonix
else
    for repo in "$@"; do
        clone "$repo"
    done
fi
