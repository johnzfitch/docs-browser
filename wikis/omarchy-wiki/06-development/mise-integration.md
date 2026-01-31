# Mise Integration

## Quick Start

```bash
# Install Node.js LTS
mise use --global node@lts

# Install Ruby latest
mise use --global ruby@latest

# Install multiple runtimes
mise use --global python@latest go@latest

# Check installed versions
mise list

# See currently active versions
mise current
```

---

## Table of Contents

1. [Overview](#overview)
2. [What is Mise](#what-is-mise)
3. [Omarchy's Mise Integration](#omarchys-mise-integration)
4. [Installing Language Runtimes](#installing-language-runtimes)
5. [Configuration](#configuration)
6. [Examples](#examples)
   - [Basic: Installing Node.js](#example-1-basic-installing-nodejs)
   - [Intermediate: Multi-Language Setup](#example-2-intermediate-multi-language-development-setup)
   - [Advanced: Project-Specific Versions](#example-3-advanced-project-specific-runtime-versions)
7. [Mise vs Other Version Managers](#mise-vs-other-version-managers)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Mise (formerly known as rtx) is the unified runtime version manager used in Omarchy for managing language runtimes and development tools. It replaces asdf, rbenv, nvm, pyenv, and other language-specific version managers with a single, fast, Rust-based tool.

Omarchy integrates mise deeply into its development workflow through the `omarchy-install-dev-env` command, which uses mise to set up complete language environments with a single command. Mise automatically manages Ruby, Node, Python, Go, Java, Elixir, and dozens of other language runtimes.

The key benefit: Install any language runtime with `mise use --global <language>@<version>`, and it's immediately available system-wide. No PATH manipulation, no shell hooks, no manual configuration required.

---

## What is Mise

### Core Concept

Mise is a polyglot runtime manager that handles version management for multiple programming languages and tools from a single CLI. It's written in Rust for speed and uses a plugin architecture similar to asdf but with better performance and ergonomics.

Key features:

- **Single tool for all languages**: Manage Node, Ruby, Python, Go, Java, Elixir, Rust, and more
- **Fast**: Written in Rust, significantly faster than asdf or language-specific managers
- **Idiomatic version files**: Automatically reads `.ruby-version`, `.node-version`, `.tool-versions`, and even `package.json` engines
- **Global and project versions**: Set system-wide defaults or per-project versions
- **Zero configuration**: Works out of the box with sensible defaults

### How It Works

When you run a command like `ruby` or `node`, mise intercepts the call and:

1. Checks for a `.tool-versions` or language-specific version file in the current directory
2. If found, uses that version; otherwise uses the global version
3. Automatically downloads and installs the runtime if not present
4. Executes the command with the correct version

Version selection hierarchy:
1. `.tool-versions` in current directory
2. `.tool-versions` in parent directories (walks up)
3. `.ruby-version`, `.node-version`, etc. (language-specific files)
4. `~/.config/mise/config.toml` (global configuration)

---

## Omarchy's Mise Integration

### Installation

Mise is installed automatically with Omarchy. It's available immediately in all shells (bash, zsh, fish).

### Integration Points

Omarchy integrates mise through:

1. **omarchy-install-dev-env**: High-level language environment installer
2. **Direct mise commands**: Full mise CLI available for manual control
3. **Automatic activation**: Mise is pre-configured in shell initialization
4. **Version file support**: Mise automatically detects `.ruby-version`, `.node-version`, etc.

### Pre-Configured Settings

Omarchy sets up mise with:

```toml
# ~/.config/mise/config.toml
[tools]
node = "22"  # or whatever version was set
```

Additional settings are configured via `mise settings`:

```bash
# Example: Enable .ruby-version file support
mise settings add idiomatic_version_file_enable_tools ruby
```

---

## Installing Language Runtimes

### Basic Installation

Install any language runtime with `mise use`:

```bash
# Install latest version globally
mise use --global ruby@latest
mise use --global node@lts
mise use --global python@3.12
mise use --global go@1.21

# Install specific version
mise use --global node@20.10.0

# Install multiple versions (latest becomes active)
mise use --global ruby@3.2 ruby@3.3
```

The `--global` flag writes to `~/.config/mise/config.toml`, making the runtime available system-wide.

### Project-Specific Versions

Create a `.tool-versions` file in your project:

```bash
# Set version for current project
cd ~/my-project
mise use node@18
mise use ruby@3.2
```

This creates/updates `.tool-versions`:

```
node 18.19.0
ruby 3.2.2
```

Mise automatically switches to these versions when you `cd` into the directory.

### Listing and Inspecting

```bash
# List all installed runtimes
mise list

# List available versions for a language
mise ls-remote node

# Show currently active versions
mise current

# Show where versions are defined
mise where node
```

---

## Configuration

### Global Configuration

Location: `~/.config/mise/config.toml`

```toml
[tools]
node = "22"
ruby = "latest"
python = "3.12"

[settings]
# Enable legacy version files
legacy_version_file = true

# Enable specific version file types
idiomatic_version_file_enable_tools = ["ruby", "python"]
```

### Project Configuration

Create `.tool-versions` in project root:

```
# .tool-versions
node 18.19.0
ruby 3.2.2
python 3.11.7
```

Or use `.mise.toml` for more advanced config:

```toml
# .mise.toml
[tools]
node = "20"
ruby = "3.3"

[env]
DATABASE_URL = "postgres://localhost/myapp"
```

### Environment Variables

Mise can manage environment variables per-project:

```toml
# .mise.toml
[env]
NODE_ENV = "development"
API_KEY = "local-dev-key"
```

These are loaded automatically when you enter the directory.

---

## Examples

### Example 1: Basic - Installing Node.js

**Scenario**: You need Node.js for a web project.

```bash
# Install Node LTS globally
$ mise use --global node@lts
mise ~/Users/developer/.config/mise/config.toml tools: node@lts

# Verify installation
$ node --version
v22.9.0

# npm is included automatically
$ npm --version
10.8.3

# Check where it's installed
$ which node
/home/zack/.local/share/mise/installs/node/22.9.0/bin/node
```

**What happened**:
- Mise downloaded and installed Node.js LTS (v22)
- Updated `~/.config/mise/config.toml` with `node = "22"`
- Made `node` and `npm` available globally

---

### Example 2: Intermediate - Multi-Language Development Setup

**Scenario**: You work on projects using Ruby, Node, and Python.

```bash
# Install all three languages
$ mise use --global ruby@latest node@lts python@latest
mise ~/Users/developer/.config/mise/config.toml tools: ruby@latest, node@lts, python@latest

# Check what's active
$ mise current
ruby     3.3.5      ~/.config/mise/config.toml
node     22.9.0     ~/.config/mise/config.toml
python   3.12.7     ~/.config/mise/config.toml

# All commands work immediately
$ ruby --version
ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]

$ node --version
v22.9.0

$ python --version
Python 3.12.7

# Install gems, npm packages, pip packages normally
$ gem install rails
$ npm install -g yarn
$ pip install django
```

**What happened**:
- Mise installed Ruby 3.3, Node 22, and Python 3.12
- All three are available globally across all directories
- Package managers (gem, npm, pip) work with their respective runtimes

---

### Example 3: Advanced - Project-Specific Runtime Versions

**Scenario**: Legacy project requires Node 18, but system default is Node 22.

```bash
# Check current (global) version
$ node --version
v22.9.0

# Enter legacy project directory
$ cd ~/projects/legacy-app

# Set project-specific Node version
$ mise use node@18
mise ~/projects/legacy-app/.tool-versions tools: node@18.19.0

# Check version again
$ node --version
v18.19.0

# Leave the directory
$ cd ~

# Version reverts to global default
$ node --version
v22.9.0
```

**What happened**:
- Created `.tool-versions` in `~/projects/legacy-app` with `node 18.19.0`
- Mise auto-switches to Node 18 when in that directory
- Exits the directory, reverts to global Node 22
- No manual version switching required

**Advanced: Multiple version files**

```bash
# Rails project with .ruby-version
$ cd ~/projects/rails-app
$ cat .ruby-version
3.2.2

# Mise automatically detects and uses it
$ ruby --version
ruby 3.2.2

# But .tool-versions takes precedence if present
$ echo "ruby 3.3.0" > .tool-versions
$ ruby --version
ruby 3.3.0
```

---

## Mise vs Other Version Managers

### Comparison Table

| Feature | Mise | asdf | rbenv/nvm/pyenv |
|---------|------|------|-----------------|
| Multi-language support | Yes (50+ languages) | Yes (plugins) | No (single language) |
| Performance | Fast (Rust) | Slow (Bash) | Medium |
| Version file support | `.tool-versions`, `.ruby-version`, etc. | `.tool-versions` | Language-specific |
| Auto-installation | Yes | Requires plugins | No |
| Configuration | TOML or version files | Version files | Shims + configs |
| Shell integration | Minimal overhead | Heavy (hook-based) | Shims (PATH modification) |

### Why Mise Over asdf

- **10x faster**: Rust vs Bash means near-instant runtime switching
- **Better UX**: `mise use node@lts` vs `asdf plugin add nodejs && asdf install nodejs latest && asdf global nodejs latest`
- **Backwards compatible**: Reads asdf's `.tool-versions` files
- **Active development**: Modern tooling, frequent updates

### Why Mise Over Language-Specific Managers

**Instead of**:
```bash
# Old way: Multiple tools, multiple configurations
rbenv install 3.3.0
rbenv global 3.3.0

nvm install 22
nvm use 22

pyenv install 3.12
pyenv global 3.12
```

**Use mise**:
```bash
# New way: One tool, consistent interface
mise use --global ruby@3.3 node@22 python@3.12
```

Benefits:
- Single configuration file (`~/.config/mise/config.toml`)
- Consistent commands across all languages
- Faster execution (no shell hook overhead)
- Unified version file format (`.tool-versions`)

### Migration from Other Tools

```bash
# From rbenv
mise use ruby@$(cat .ruby-version)

# From nvm
mise use node@$(cat .nvmrc)

# From asdf (automatic - mise reads .tool-versions)
mise install  # Reads existing .tool-versions
```

---

## Troubleshooting

### Runtime Not Found After Installation

**Problem**: `bash: node: command not found` after `mise use --global node@lts`

**Solution**: Reload shell or restart terminal

```bash
# Reload shell configuration
source ~/.bashrc

# Or restart terminal
exec bash
```

**Why**: Mise updates PATH via shell initialization; reload needed for changes to take effect.

### Wrong Version Being Used

**Problem**: `node --version` shows wrong version

**Solution**: Check version hierarchy

```bash
# See where version is coming from
$ mise current
node     18.0.0     ~/projects/legacy-app/.tool-versions

# See all places defining node
$ mise where node
/home/zack/.local/share/mise/installs/node/18.0.0

# Override with global version temporarily
$ mise exec -- node --version
v22.9.0
```

**Fix**: Remove or update local `.tool-versions` if needed:

```bash
cd ~/projects/legacy-app
rm .tool-versions  # Or edit it
mise use node@22   # Set to desired version
```

### Gem/NPM Package Not Found

**Problem**: Installed `rails` but `rails` command not found

**Solution**: Mise needs to shim the new binary

```bash
# After installing a gem/npm package with a binary:
mise reshim

# Or install via mise exec to auto-reshim:
mise exec -- gem install rails
```

### Clearing Cache

```bash
# Clear download cache
mise cache clear

# Reinstall a runtime
mise uninstall node@22
mise install node@22
```

---

## Best Practices

### 1. Use Global Defaults, Override Locally

Set sane global defaults:

```bash
mise use --global node@lts ruby@latest python@latest
```

Override in projects as needed:

```bash
cd ~/old-project
mise use node@16  # Creates local .tool-versions
```

### 2. Commit .tool-versions to Git

Include `.tool-versions` in your repository:

```bash
# In your project
mise use node@18 ruby@3.2
git add .tool-versions
git commit -m "Lock runtime versions"
```

Benefits:
- Team uses same versions
- CI/CD uses same versions
- Reproducible builds

### 3. Enable Idiomatic Version Files

For compatibility with existing projects:

```bash
# Enable .ruby-version support
mise settings add idiomatic_version_file_enable_tools ruby

# Now mise auto-reads .ruby-version
cd ~/rails-project
cat .ruby-version  # 3.2.2
ruby --version     # ruby 3.2.2 (auto-detected)
```

### 4. Use mise exec for Scripts

In scripts that should work anywhere:

```bash
#!/bin/bash
# Instead of: ruby script.rb
# Use:
mise exec -- ruby script.rb
```

This ignores local `.tool-versions` and uses global version.

### 5. Check Active Versions Before Debugging

First step in any runtime issue:

```bash
mise current  # Shows what's active and why
```

### 6. Keep Mise Updated

```bash
# Update mise itself
mise self-update

# Update all installed runtimes to latest patch versions
mise upgrade
```

---

## Related Documentation

- **[Language Environments](./language-environments.md)** - Using `omarchy-install-dev-env` for full language setups
- **[Docker Setup](./docker-setup.md)** - Containerized development environments
- **[Editor Setup](./editor-setup.md)** - Configuring editors for development
- **Core Commands** - Package management and system tools

**External Resources**:
- [Mise Official Documentation](https://mise.jdx.dev/)
- [Mise GitHub Repository](https://github.com/jdx/mise)
- [Comparison with asdf](https://mise.jdx.dev/comparison-to-asdf.html)
