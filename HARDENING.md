<!-- markdownlint-disable -->

# Hardening Report: actionshub--chef-install/4.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **actionshub--chef-install/4.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The workflow file .github/workflows/generic-linters.yml references four Actions using mutable tags/branches instead of pinned full-length commit SHAs. Mutable refs can be silently updated to point to malicious code. Failing references:
- `actions/checkout@v6` (used twice, lines ~14 and ~21)
- `actionshub/yamllint@main` (line ~16)
- `actionshub/markdownlint@main` (line ~23)
All should be replaced with 40-character hex commit SHAs (e.g. `actions/checkout@<sha> # v6`).

Locations:

- `.github/workflows/generic-linters.yml:14`
- `.github/workflows/generic-linters.yml:16`
- `.github/workflows/generic-linters.yml:21`
- `.github/workflows/generic-linters.yml:23`

### missing-permissions (severity: medium)

The workflow file .github/workflows/generic-linters.yml has no top-level `permissions:` key, and neither of its jobs (`yamllint`, `mdl`) defines a job-level `permissions:` block. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (e.g. write access to contents). A minimal `permissions:` block (e.g. `contents: read`) should be added at the top level or on each job.

Locations:

- `.github/workflows/generic-linters.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed .github/workflows/generic-linters.yml: (1) Pinned all four action references to full commit SHAs — actions/checkout@v6 → d23441a48e516b6c34aea4fa41551a30e30af803 (used in both jobs), actionshub/yamllint@main → 184f72d121829c82b16569eccceb713b2c19d89d, actionshub/markdownlint@main → 6c82ff529253530dfbf75c37570876c52692835f. Original tags/branches preserved as inline comments. (2) Added top-level `permissions: contents: read` block to restrict the workflow token to the minimum needed for linting (read-only checkout).

