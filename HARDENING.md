<!-- markdownlint-disable -->

# Hardening Report: actionshub--chef-install/6.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **actionshub--chef-install/6.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b): In the 'Install Chef (Linux/macOS)' step, the shell variable ${VERSION_FLAG} is expanded **unquoted** in the final sudo bash invocation: `sudo bash "$TEMP_SCRIPT" -c "${CHANNEL}" -P "${INSTALL_PROJECT}" ${VERSION_FLAG}`. VERSION_FLAG is constructed from $VERSION, which is sourced from inputs.version (a workflow-controllable value). An unquoted expansion allows the shell to parse metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, glob chars) out of the value, enabling command injection. It should be quoted as `"${VERSION_FLAG}"` or handled via an array.

Locations:

- `action.yml:107`

### github-env-injection (severity: high)

In the 'Install Chef (Windows)' step, the value of $installRoot (derived from $env:WINDOWS_PATH, which maps to inputs.windowsPath — a caller-controlled input) is written directly to $GITHUB_PATH without the required newline-stripping sanitization (`tr -d '\n\r'`). The offending line is: `"$($installRoot)bin" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append`. A malicious caller could inject newlines into inputs.windowsPath to smuggle additional entries into GITHUB_PATH.

Locations:

- `action.yml:183`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

1. script-injection fix (Linux/macOS step): Replaced the string variable VERSION_FLAG (which was expanded unquoted as `${VERSION_FLAG}`) with a bash array VERSION_ARGS. Array is set as `VERSION_ARGS=(-v "$VERSION")` when VERSION is non-empty, and the sudo bash invocation uses `"${VERSION_ARGS[@]+"${VERSION_ARGS[@]}"}"` to safely expand it (empty when no version). This keeps -v and its value as separate properly-quoted arguments, preventing shell metacharacter injection from inputs.version.

2. github-env-injection fix (Windows step): Added sanitization of $installRoot before writing to $GITHUB_PATH. Uses PowerShell's `-replace '[\r\n]', ''` to strip newlines/carriage-returns from the caller-controlled windowsPath input before appending to GITHUB_PATH, preventing newline injection that could smuggle additional entries into the PATH.

