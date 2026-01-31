# Development Tools

Pre-installed development tools for software engineering workflows in omarchy.

## Table of Contents
- [Overview](#overview)
- [Container Tools](#container-tools)
- [Version Control](#version-control)
- [System Monitoring](#system-monitoring)
- [Developer Utilities](#developer-utilities)
- [Runtime Management](#runtime-management)
- [Examples](#examples)
- [Related Documentation](#related-documentation)

## Overview

Omarchy includes a comprehensive suite of development tools optimized for modern software engineering. These tools cover containerization, version control, system monitoring, and runtime management.

**Core Development Tools:**
- **Docker** - Container platform with Docker Compose
- **lazydocker** - Terminal UI for Docker management
- **lazygit** - Terminal UI for Git operations
- **github-cli** - Official GitHub command-line tool
- **btop** - Advanced system monitor
- **mise** - Runtime version manager

All tools are installed via `omarchy-base.packages` and ready to use out of the box.

## Container Tools

### Docker

**Packages:**
```
docker              # Container engine
docker-buildx       # Extended build capabilities
docker-compose      # Multi-container orchestration
```

**Service Management:**
```bash
# Check Docker status
systemctl status docker

# Start Docker service
sudo systemctl start docker

# Enable Docker at boot
sudo systemctl enable docker

# Add user to docker group (requires re-login)
sudo usermod -aG docker $USER
```

**Basic Usage:**
```bash
# Run a container
docker run hello-world

# List running containers
docker ps

# List all containers
docker ps -a

# View images
docker images

# Remove container
docker rm container-name

# Remove image
docker rmi image-name
```

### lazydocker

**Description:** Terminal UI for managing Docker containers, images, volumes, and networks.

**Launch:**
```bash
lazydocker
```

**Features:**
- Visual container management
- Real-time logs
- Resource usage graphs
- Quick container actions (start, stop, remove)
- Image management
- Volume and network inspection
- Keyboard-driven interface

**Key Bindings:**
- `[` / `]` - Switch between panels
- `Enter` - View details/logs
- `d` - Remove container/image
- `s` - Stop container
- `r` - Restart container
- `e` - Execute command in container
- `q` - Quit

### Docker Database Setup

**Command:** `omarchy-install-docker-dbs`

Interactive script to install common databases as Docker containers.

**Supported Databases:**
- MySQL 8.4
- PostgreSQL 17
- MariaDB 11.8
- Redis 7
- MongoDB
- Microsoft SQL Server 2022

**Usage:**
```bash
# Interactive mode - select databases from menu
omarchy-install-docker-dbs

# Command-line mode - specify databases
omarchy-install-docker-dbs MySQL PostgreSQL Redis
```

**Container Details:**

| Database | Port | Container Name | Credentials |
|----------|------|----------------|-------------|
| MySQL | 3306 | mysql8 | root / (empty) |
| PostgreSQL | 5432 | postgres17 | trust auth |
| MariaDB | 3306 | mariadb11 | root / (empty) |
| Redis | 6379 | redis | (none) |
| MongoDB | 27017 | mongodb | admin / admin123 |
| MSSQL | 1433 | mssql | sa / @dmin123 |

**Features:**
- Containers auto-restart unless stopped
- Bound to localhost (127.0.0.1) only
- Development-friendly credentials
- Latest stable versions

**Example:**
```bash
# Install MySQL and PostgreSQL
omarchy-install-docker-dbs MySQL PostgreSQL

# Connect to MySQL
mysql -h 127.0.0.1 -u root

# Connect to PostgreSQL
psql -h 127.0.0.1 -U postgres
```

## Version Control

### Git

**Package:** Built into base system

**Configuration:**
```bash
# Set user info
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# View config
git config --list
```

### lazygit

**Description:** Terminal UI for Git operations with keyboard-driven workflow.

**Launch:**
```bash
# From any git repository
lazygit
```

**Features:**
- Visual branch management
- Interactive staging
- Commit history viewer
- Merge conflict resolution
- Stash management
- Remote operations
- Cherry-picking and rebasing
- File diff viewer

**Key Bindings:**
- `1-5` - Switch between panels (Status, Files, Branches, Commits, Stash)
- `Space` - Stage/unstage file
- `a` - Stage all files
- `c` - Commit
- `P` - Push
- `p` - Pull
- `n` - New branch
- `m` - Merge
- `r` - Rebase
- `q` - Quit

### GitHub CLI

**Package:** `github-cli` (gh)

**Authentication:**
```bash
# Login to GitHub
gh auth login

# Follow prompts to authenticate via browser or token
```

**Common Operations:**
```bash
# Create a repository
gh repo create my-project --public

# Clone a repository
gh repo clone username/repo

# List your repositories
gh repo list

# View pull requests
gh pr list

# Create pull request
gh pr create --title "Feature" --body "Description"

# View pull request
gh pr view 123

# Merge pull request
gh pr merge 123

# Create issue
gh issue create --title "Bug" --body "Description"

# List issues
gh issue list

# View workflow runs
gh run list

# View workflow details
gh run view
```

## System Monitoring

### btop

**Description:** Advanced system monitor with beautiful interface.

**Launch:**
```bash
btop
```

**Features:**
- CPU usage per core
- Memory and swap usage
- Disk I/O statistics
- Network usage graphs
- Process management
- Mouse support
- Customizable themes
- Resource history graphs

**Key Bindings:**
- `q` - Quit
- `k` - Kill process
- `t` - Toggle tree view
- `f` - Filter processes
- `+` / `-` - Scale graphs
- `m` - Toggle memory mode
- `n` - Toggle network mode

### dust

**Description:** Modern disk usage analyzer (faster than du).

**Usage:**
```bash
# Analyze current directory
dust

# Analyze specific directory
dust ~/Documents

# Show more depth
dust -d 5

# Reverse sort (smallest first)
dust -r

# Only show directories
dust -t
```

## Developer Utilities

### Command-Line Tools

**File Search:**
```bash
# Find files by name (faster than find)
fd pattern

# Find in specific directory
fd pattern ~/Documents

# Find by type
fd -t f    # files only
fd -t d    # directories only

# Case-insensitive
fd -i pattern
```

**Content Search:**
```bash
# Search file contents (faster than grep)
rg "pattern"

# Search specific file types
rg "pattern" -t py    # Python files
rg "pattern" -t js    # JavaScript files

# Case-insensitive
rg -i "pattern"

# Show context
rg "pattern" -C 3     # 3 lines before/after
```

**File Viewing:**
```bash
# Better cat with syntax highlighting
bat file.js

# Show line numbers
bat -n file.js

# View diff
bat --diff file.js
```

**Directory Listing:**
```bash
# Modern ls alternative
eza

# Long format
eza -l

# Tree view
eza --tree

# With git status
eza --git
```

### JSON Processing

**Package:** `jq`

```bash
# Pretty-print JSON
echo '{"name":"value"}' | jq

# Extract field
jq '.name' file.json

# Filter array
jq '.[] | select(.age > 30)' users.json

# Transform data
jq '{name: .name, email: .email}' user.json
```

### YAML Processing

**Package:** `libyaml`

```bash
# Parse YAML with Python
python -c "import yaml; print(yaml.safe_load(open('file.yml')))"
```

### XML Processing

**Package:** `xmlstarlet`

```bash
# Format XML
xmlstarlet fo file.xml

# Extract elements
xmlstarlet sel -t -v "//element" file.xml

# Edit XML
xmlstarlet ed -u "//element" -v "new-value" file.xml
```

### Documentation

**Package:** `tldr`

```bash
# Quick command examples
tldr git

# Update cache
tldr --update

# List all pages
tldr --list
```

## Runtime Management

### mise

**Description:** Universal runtime version manager (replaces asdf, nvm, rbenv, etc.)

**Configuration:** `~/.config/mise/config.toml`

**Usage:**
```bash
# Install a runtime
mise install node@20
mise install python@3.12
mise install ruby@3.3

# Set global version
mise use -g node@20
mise use -g python@3.12

# Set local version (project-specific)
mise use node@20

# List installed runtimes
mise list

# List available versions
mise ls-remote node

# Update mise
mise self-update

# Install from .tool-versions
mise install
```

**Supported Runtimes:**
- Node.js
- Python
- Ruby
- Go
- PHP
- Rust
- Java
- And many more...

**Project Configuration:**

Create `.mise.toml` in project root:
```toml
[tools]
node = "20"
python = "3.12"
ruby = "3.3"
```

Or use `.tool-versions` (asdf-compatible):
```
node 20.0.0
python 3.12.0
ruby 3.3.0
```

## Examples

### Example 1: Git Workflow with lazygit

```bash
# Navigate to repository
cd ~/projects/my-app

# Launch lazygit
lazygit

# Workflow:
# 1. Press '2' to view Files panel
# 2. Press 'Space' on modified files to stage
# 3. Press 'c' to commit
# 4. Enter commit message
# 5. Press 'P' to push to remote

# Or use command line:
git add .
git commit -m "Update feature"
git push
```

### Example 2: Docker Development Environment

```bash
# Install databases for development
omarchy-install-docker-dbs MySQL Redis

# Start lazydocker to manage containers
lazydocker

# View running containers
# Press Enter on container to view logs

# Or use Docker commands:
docker ps
docker logs mysql8
docker exec -it mysql8 mysql -u root

# Stop container when done
docker stop mysql8

# Restart container
docker start mysql8
```

### Example 3: Multi-Language Project Setup

```bash
# Create new project
mkdir ~/projects/fullstack-app
cd ~/projects/fullstack-app

# Set up runtime versions
mise use node@20
mise use python@3.12
mise use ruby@3.3

# Verify versions
node --version
python --version
ruby --version

# Install dependencies
npm install
pip install -r requirements.txt
bundle install

# View installed runtimes
mise list
```

### Example 4: System Monitoring During Development

```bash
# Terminal 1: Run application
npm run dev

# Terminal 2: Monitor system resources
btop

# Terminal 3: Watch Docker containers
lazydocker

# Terminal 4: Monitor disk usage
watch -n 5 dust
```

### Example 5: GitHub CLI Workflow

```bash
# Authenticate
gh auth login

# Create new repository
gh repo create my-project --public

# Clone it
gh repo clone my-project
cd my-project

# Make changes
git add .
git commit -m "Initial commit"
git push

# Create pull request
gh pr create --title "Add feature" --body "Description"

# List PRs
gh pr list

# Merge PR
gh pr merge 1
```

## Package List

Development tools from `omarchy-base.packages`:

```
# Container Tools
docker
docker-buildx
docker-compose
lazydocker

# Version Control
lazygit
github-cli

# Monitoring
btop
dust

# Search & Filter
fd                  # Find files
ripgrep            # Search content
fzf                # Fuzzy finder

# File Tools
bat                # Better cat
eza                # Better ls
tree-sitter-cli    # Parser

# Data Processing
jq                 # JSON processor
libyaml            # YAML library
xmlstarlet         # XML processor

# Runtime Management
mise               # Version manager
cargo              # Rust package manager
luarocks           # Lua package manager

# Development
clang              # C/C++ compiler
llvm               # Compiler infrastructure

# Utilities
tldr               # Command examples
man                # Manual pages
```

## Troubleshooting

### Docker Permission Denied

**Problem:** `permission denied while trying to connect to the Docker daemon socket`

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Re-login or run:
newgrp docker

# Or use sudo:
sudo docker ps
```

### Database Container Won't Start

**Problem:** Database container fails to start after installation

**Solution:**
```bash
# Check logs
docker logs mysql8

# Check if port is already in use
ss -tulpn | grep 3306

# Stop conflicting service
sudo systemctl stop mysql

# Restart container
docker restart mysql8
```

### mise Runtime Not Found

**Problem:** Installed runtime not available in PATH

**Solution:**
```bash
# Ensure mise is activated in shell
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
source ~/.bashrc

# Or for current session
eval "$(mise activate bash)"

# Verify installation
mise list
which node
```

### lazygit Not Showing Changes

**Problem:** lazygit shows empty repository

**Solution:**
```bash
# Ensure you're in a git repository
git status

# Initialize if needed
git init

# Ensure lazygit can access git
which git
git --version

# Check git config
git config --list
```

## Best Practices

### Docker Usage
- Use Docker Compose for multi-container apps
- Mount volumes for persistent data
- Use .dockerignore to exclude files
- Tag images with versions
- Clean up unused containers and images regularly
- Use lazydocker for visual management

### Git Workflow
- Use lazygit for interactive staging
- Commit frequently with descriptive messages
- Create feature branches
- Use gh CLI for GitHub operations
- Keep branches up to date with main

### Runtime Management
- Use mise for consistent runtime versions across projects
- Create `.mise.toml` or `.tool-versions` per project
- Pin versions for reproducibility
- Update runtimes regularly for security

### System Monitoring
- Use btop for quick system overview
- Monitor Docker container resources in lazydocker
- Use dust to find large directories
- Set up alerts for resource thresholds

### Development Environment
- Keep database containers running with `--restart unless-stopped`
- Use localhost bindings for security
- Document runtime versions in README
- Use Docker Compose for complex setups

## Related Documentation

- [Mise Integration](../06-development/mise-integration.md) - Detailed runtime management
- [Docker Setup](../06-development/docker-setup.md) - Advanced Docker configuration
- [Language Environments](../06-development/language-environments.md) - Language-specific setups
- [Package Management](../02-core-commands/package-management.md) - Installing additional tools
- [Core Applications](./core-applications.md) - Essential applications

---

*Last Updated: 2025-10-21*
*Source: omarchy-base.packages, omarchy-install-docker-dbs*
