# ==============================================================================
#  ZSH THEME HEURISTICS
#  Set the theme based on the execution environment, following a strict priority.
# ==============================================================================

# --- Helper Functions for Detection ---

# Checks if the script is running inside any container environment.
# This is the most robust, systemd-free detection method.
# Priority: 1
_is_in_container() {
  # Fast check for standard container environment files created by
  # Podman (/run/.containerenv) or Docker (/.dockerenv).
  if [ -f /run/.containerenv ] || [ -f /.dockerenv ]; then
    return 0 # True, in a container
  fi

  # Fallback to the fundamental check: Control Groups (cgroups).
  # This works for virtually all container runtimes (Docker, LXC, etc.).
  # - v1: The path will contain a runtime keyword like "docker" or "lxc".
  # - v2: The path will simply be "/" for a process in a container.
  if [ -f /proc/self/cgroup ] && (grep -qE 'docker|lxc|podman' /proc/self/cgroup || [[ "$(head -n 1 /proc/self/cgroup)" == "0::/" ]]); then
    return 0 # True, in a container
  fi

  return 1 # False, not in a container
}

# Checks if the script is running in an SSH session.
# This method is designed to be accurate even after using `su` or `sudo`.
# Priority: 2 & 3
_is_in_ssh_session() {
  # Fast check for standard environment variables. Works on initial login.
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    return 0 # True, in an SSH session
  fi

  # Robust fallback that survives `su` and `sudo`. `who am i` reliably
  # shows the client IP/hostname for remote sessions.
  if who am i 2>/dev/null | grep -q '([0-9a-zA-Z\.:-]*)'; then
    return 0 # True, in an SSH session
  fi

  return 1 # False, not an SSH session
}

# --- Main Logic ---
# The script evaluates each condition according to your ranking.

# Rank 1: Am I in a container?
if _is_in_container; then
  ZSH_THEME="agnoster"

# Rank 2 & 3: Am I in an SSH session (as root or normal user)?
# The theme is the same for both, so no need to differentiate user/root here.
elif _is_in_ssh_session; then
  ZSH_THEME="linuxonly"

# Rank 4 & 5: Fallback to a normal local session (as root or user).
# This is the default if not in a container or SSH session.
else
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# Cleanup the helper functions so they don't pollute the shell environment.
unset -f _is_in_container
unset -f _is_in_ssh_session
