<!-- markdownlint-disable -->

# Hardening Report: actionshub--chef-install/6.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **actionshub--chef-install/6.0.0** was hardened automatically. 4 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In the 'Install Chef (Linux/macOS)' run step, the shell variable `${VERSION_FLAG}` is expanded unquoted in the final command: `sudo bash "$TEMP_SCRIPT" -c "${CHANNEL}" -P "${INSTALL_PROJECT}" ${VERSION_FLAG}`. `VERSION_FLAG` is constructed from `$VERSION`, which is sourced from `inputs.version` (an untrusted caller-controlled input). An unquoted expansion allows shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) embedded in the input to be interpreted by the shell, enabling command injection. The fix is to quote it: `"${VERSION_FLAG}"`.

Locations:

- `action.yml:107`

### github-env-injection (severity: high)

In the 'Install Chef (Windows)' run step, the value of `$env:WINDOWS_PATH` — which is set from `inputs.windowsPath` (an untrusted caller-controlled input) — is written directly to `$GITHUB_PATH` via `"$($installRoot)bin" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append` without any newline sanitization. An attacker-controlled value containing newlines could inject additional entries into `$GITHUB_PATH`, enabling PATH hijacking. The value must be sanitized (stripping `\n` and `\r`) before being written to the special environment file.

Locations:

- `action.yml:196`

### unpinned-uses (severity: high)

All four `uses:` references in the workflow file use mutable tag or branch refs instead of immutable 40-character SHA commit hashes, making the workflow vulnerable to supply-chain attacks if the referenced action tags are moved or the branches are force-pushed. Failing references:
- `uses: actions/checkout@v6` (line 13)
- `uses: actionshub/yamllint@main` (line 15)
- `uses: actions/checkout@v6` (line 21)
- `uses: actionshub/markdownlint@main` (line 23)

Locations:

- `.github/workflows/generic-linters.yml:13`
- `.github/workflows/generic-linters.yml:15`
- `.github/workflows/generic-linters.yml:21`
- `.github/workflows/generic-linters.yml:23`

### missing-permissions (severity: medium)

The workflow file has no top-level `permissions:` key, and neither of its two jobs (`yamllint`, `mdl`) defines a job-level `permissions:` block. Without explicit permissions, the workflow inherits the default repository token permissions, which may be broader than necessary (e.g., write access to contents). A minimal `permissions:` block (e.g., `contents: read`) should be added at the top level or per job.

Locations:

- `.github/workflows/generic-linters.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions

**Notes:**

Fixed all four findings: (1) script-injection in action.yml line 107: changed unquoted `${VERSION_FLAG}` to `${VERSION_FLAG:+"${VERSION_FLAG}"}` to prevent shell metacharacter injection while preserving empty-argument behavior; (2) github-env-injection in action.yml line 196: added PowerShell newline sanitization (`-replace '[\r\n]', ''`) before writing to $GITHUB_PATH to prevent PATH hijacking; (3) unpinned-uses in generic-linters.yml: pinned all four action references to full commit SHAs (actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803, actionshub/yamllint@184f72d121829c82b16569eccceb713b2c19d89d, actionshub/markdownlint@6c82ff529253530dfbf75c37570876c52692835f) with original refs preserved as comments; (4) missing-permissions in generic-linters.yml: added top-level `permissions: contents: read` block.

