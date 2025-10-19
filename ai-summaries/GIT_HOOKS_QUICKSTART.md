# Git Hooks Quick Start Guide

## Installation

```bash
# Install git hooks
./script/git-hooks install

# Verify installation
./script/git-hooks status
```

## What Happens Automatically

### When You Commit (`git commit`)

✅ Code formatting check (`cargo fmt`)
✅ Clippy linting (`./script/clippy`)
✅ TODO/FIXME validation
✅ Typo detection
✅ Cargo.lock verification

### When You Push (`git push`)

✅ Branch protection (warns on main)
✅ Quick test suite (2-min timeout)
✅ Debug code detection
✅ Large file detection
✅ Commit message validation

## Common Commands

```bash
# Skip hooks (use sparingly)
git commit --no-verify
git push --no-verify

# Test hooks without git operations
./script/git-hooks test pre-commit
./script/git-hooks test pre-push

# Fix common issues
cargo fmt                    # Fix formatting
./script/clippy              # View clippy errors
cargo update --workspace     # Update Cargo.lock

# Generate code coverage
./script/coverage            # HTML report
./script/coverage --open     # Open in browser
./script/coverage --package gpui  # Specific package

# Install coverage tools
./script/coverage --install
```

## Bypassing Hooks

**Pre-commit failures:**
```bash
# Fix the issue (recommended)
cargo fmt
git add -u
git commit

# Or skip (not recommended)
git commit --no-verify
```

**Pre-push failures:**
```bash
# Let CI run full tests (safe)
git push --no-verify

# Or run locally first
cargo test --workspace
```

## Hook Management

```bash
./script/git-hooks install    # Install hooks
./script/git-hooks uninstall  # Remove hooks
./script/git-hooks status     # Check status
./script/git-hooks help       # Show help
```

## Code Coverage

```bash
# Basic usage
./script/coverage                          # Generate HTML report
./script/coverage --format lcov            # Generate LCOV format
./script/coverage --threshold 70           # Set minimum threshold
./script/coverage --package gpui --open    # Package-specific + open

# Coverage options
--format <html|lcov|json|text>   # Output format
--output <dir>                   # Output directory
--package <name>                 # Specific package
--threshold <num>                # Minimum coverage %
--open                           # Open report in browser
--install                        # Install coverage tools
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `cargo fmt` errors | Run `cargo fmt` to auto-fix |
| Clippy warnings | Fix code or see `./script/clippy` |
| Tests timeout | Normal for large suites, CI runs full tests |
| Typos found | Fix typos or add to `typos.toml` |
| Hook not executable | Run `chmod +x .git/hooks/pre-commit` |
| Coverage tool missing | Run `./script/coverage --install` |

## Quick Reference

### Pre-commit Flow
```
git commit
    ↓
[Format check] → cargo fmt --check
    ↓
[Linting] → ./script/clippy
    ↓
[TODO check] → ./script/check-todos
    ↓
[Typos] → typos
    ↓
[Cargo.lock] → cargo update --locked
    ↓
✅ Commit allowed or ❌ Fix issues
```

### Pre-push Flow
```
git push
    ↓
[Branch check] → Warn if main
    ↓
[Quick tests] → cargo nextest/test (2-min)
    ↓
[Debug code] → grep for dbg!
    ↓
[Large files] → Check diff stats
    ↓
[Commit msgs] → Conventional format check
    ↓
✅ Push allowed or ❌ Fix issues
```

## Best Practices

1. **Install hooks early** - Run `./script/git-hooks install` when you clone
2. **Fix issues, don't skip** - Use `--no-verify` only when necessary
3. **Run checks locally** - `cargo fmt` and `./script/clippy` before committing
4. **Monitor coverage** - Check coverage reports in PRs
5. **Use conventional commits** - Format: `type(scope): description`

## Getting Help

```bash
./script/git-hooks help     # Hook management help
./script/coverage --help    # Coverage script help
```

See full documentation: [docs/git-hooks.md](docs/git-hooks.md)
