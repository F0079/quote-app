# Git hooks

Versioned hooks for this repository. Enable them once per clone:

```sh
git config core.hooksPath .githooks
```

## pre-commit

Blocks a commit that would add secrets or personal information (see `AGENTS.md`
→ *Privacy & data leakage*). It scans the staged index and fails on:

- private keys and known token shapes (AWS, GitHub, Slack, Google, `sk-…`);
- absolute user paths (`/home/<user>/`, `C:\Users\<user>\`);
- email addresses, except placeholders and `noreply` addresses.

Placeholders such as `<path>`, `<username>`, and `example.com` are ignored.

The scan itself needs no external tools. On top of it, the hook runs
`gitleaks git --staged` when a binary is available, preferring the project-local
copy installed by:

```sh
sh scripts/install-gitleaks.sh
```

That script pins a version, verifies its checksum, and unpacks the binary into
`.tools/` (gitignored), falling back to a `gitleaks` on `PATH` otherwise.

Bypass once, only when you are sure: `git commit --no-verify`.
