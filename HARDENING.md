<!-- markdownlint-disable -->

# Hardening Report: actionshub--chef-install/5.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **actionshub--chef-install/5.0.1** was hardened automatically. 4 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The 'Install Chef (Linux/macOS)' step in action.yml pipes a remotely fetched script directly to `sudo bash` without first saving it to a file for inspection: `curl -fsSL "https://${OMNITRUCK_URL}/install.sh" | sudo bash -s -- ...`. This allows a compromised or attacker-controlled server at `OMNITRUCK_URL` to execute arbitrary code with sudo privileges on the runner.

Locations:

- `action.yml:43`

### github-env-injection (severity: high)

The 'Add Chef to PATH (Windows)' step writes the user-controlled input `inputs.windowsPath` (via env var `WINDOWS_PATH`) directly to `$GITHUB_PATH` without sanitization: `echo "${WINDOWS_PATH}bin" >> "$GITHUB_PATH"`. An attacker can inject newlines into this value to add arbitrary entries to `$GITHUB_PATH`, enabling path-hijacking attacks. The required sanitization (`printf '%s' "$WINDOWS_PATH" | tr -d '\n\r'`) is absent.

Locations:

- `action.yml:60`

### unpinned-uses (severity: high)

All four `uses:` references in generic-linters.yml use mutable tag or branch refs instead of pinned 40-character SHA digests, making the workflow vulnerable to supply-chain attacks if those tags or branches are moved: `actions/checkout@v6` (×2), `actionshub/yamllint@main`, `actionshub/markdownlint@main`.

Locations:

- `.github/workflows/generic-linters.yml:14`
- `.github/workflows/generic-linters.yml:16`
- `.github/workflows/generic-linters.yml:21`
- `.github/workflows/generic-linters.yml:23`

### missing-permissions (severity: medium)

The workflow file generic-linters.yml has no top-level `permissions:` key and no job-level `permissions:` key on any of its jobs (`yamllint`, `mdl`). Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (e.g., `write` access to contents). A minimal `permissions: read-all` or specific scopes should be declared.

Locations:

- `.github/workflows/generic-linters.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, github-env-injection, unpinned-uses, missing-permissions

**Notes:**

1. unsafe-shell (action.yml line 43): Replaced `curl ... | sudo bash -s -- ...` with a two-step approach: download to a temp file via `mktemp`, then execute with `sudo bash`. Dropped the `--` (it was the shell's option terminator, not the script's). Used an if/else to handle the optional VERSION flag safely.
2. github-env-injection (action.yml line 60): Added sanitization of WINDOWS_PATH using `printf '%s' "$WINDOWS_PATH" | tr -d '\n\r'` before writing to $GITHUB_PATH.
3. unpinned-uses (generic-linters.yml lines 14, 16, 21, 23): Pinned all four `uses:` references to full 40-char SHAs — actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803 (v6), actionshub/yamllint@184f72d121829c82b16569eccceb713b2c19d89d (main), actionshub/markdownlint@6c82ff529253530dfbf75c37570876c52692835f (main).
4. missing-permissions (generic-linters.yml line 1): Added top-level `permissions: contents: read` block.

### Iteration 2

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the Windows install step in action.yml: replaced the unsafe `. { iwr -useb "https://$env:OMNITRUCK_URL/install.ps1" } | iex` pattern (PowerShell equivalent of curl|bash) with a safe approach that: (1) downloads install.ps1 to a temp file via Invoke-WebRequest -OutFile, (2) builds arguments as a PowerShell array to keep each token separate, (3) executes the saved script with the call operator & and splatting, and (4) removes the temp file afterward. This mirrors the safe download-then-execute pattern already used in the Linux/macOS step.

