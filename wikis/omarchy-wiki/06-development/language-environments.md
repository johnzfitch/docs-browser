# Language Development Environments

## Quick Start

```bash
# Install Ruby on Rails
omarchy-install-dev-env ruby

# Install Node.js
omarchy-install-dev-env node

# Install Python with uv
omarchy-install-dev-env python

# Install PHP with Laravel
omarchy-install-dev-env laravel

# Install Go
omarchy-install-dev-env go

# Install Elixir with Phoenix
omarchy-install-dev-env phoenix
```

---

## Table of Contents

1. [Overview](#overview)
2. [How It Works](#how-it-works)
3. [Supported Languages](#supported-languages)
4. [Framework Support](#framework-support)
5. [Examples](#examples)
   - [Basic: Setting Up Ruby on Rails](#example-1-basic-setting-up-ruby-on-rails)
   - [Intermediate: Multi-Language Project](#example-2-intermediate-multi-language-project)
   - [Advanced: Phoenix Full-Stack Application](#example-3-advanced-phoenix-full-stack-application)
6. [Language-Specific Details](#language-specific-details)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)
9. [Related Documentation](#related-documentation)

---

## Overview

`omarchy-install-dev-env` is Omarchy's unified language environment installer. Instead of manually installing runtimes, package managers, and frameworks, this single command sets up complete, opinionated development environments for multiple languages.

Each language installation includes:
- **Runtime**: The language itself (via mise or system installer)
- **Package manager**: gem, npm, pip, cargo, etc.
- **Framework tools**: Rails, Laravel, Phoenix installers when requested
- **Dependencies**: System libraries required for the language
- **Configuration**: Optimized settings and PATH updates

The goal: Run one command, get a fully working development environment ready for `rails new`, `npm create`, `mix phx.new`, etc.

---

## How It Works

`omarchy-install-dev-env` uses a combination of:

1. **mise**: For most language runtimes (Ruby, Node, Python, Go, Java, Elixir, etc.)
2. **System packages**: For languages better installed via pacman (PHP)
3. **Official installers**: For languages with their own setup (Rust, OCaml, .NET)
4. **Package managers**: Automatically installs framework generators (Rails, Laravel, Phoenix)

**General workflow**:

```bash
omarchy-install-dev-env <language>
  ↓
1. Install system dependencies (if needed)
  ↓
2. Install language runtime (via mise or installer)
  ↓
3. Install package manager (if separate from runtime)
  ↓
4. Install framework tools (if applicable)
  ↓
5. Configure PATH and settings
  ↓
6. Print next steps
```

---

## Supported Languages

### Runtime Languages

| Language | Command | Runtime Source | Version |
|----------|---------|----------------|---------|
| Ruby | `omarchy-install-dev-env ruby` | mise | latest |
| Node.js | `omarchy-install-dev-env node` | mise | lts |
| Bun | `omarchy-install-dev-env bun` | mise | latest |
| Deno | `omarchy-install-dev-env deno` | mise | latest |
| Python | `omarchy-install-dev-env python` | mise | latest |
| Go | `omarchy-install-dev-env go` | mise | latest |
| Rust | `omarchy-install-dev-env rust` | rustup | stable |
| Java | `omarchy-install-dev-env java` | mise | latest |
| Zig | `omarchy-install-dev-env zig` | mise | latest |
| Elixir | `omarchy-install-dev-env elixir` | mise | latest |
| PHP | `omarchy-install-dev-env php` | pacman | system |
| OCaml | `omarchy-install-dev-env ocaml` | opam | latest |
| .NET | `omarchy-install-dev-env dotnet` | mise | latest |
| Clojure | `omarchy-install-dev-env clojure` | mise | latest |

### Framework-Specific Installations

| Framework | Command | Includes |
|-----------|---------|----------|
| Ruby on Rails | `omarchy-install-dev-env ruby` | Ruby + Rails gem |
| Laravel | `omarchy-install-dev-env laravel` | PHP + Composer + Laravel installer + Node |
| Symfony | `omarchy-install-dev-env symfony` | PHP + Symfony CLI |
| Phoenix | `omarchy-install-dev-env phoenix` | Elixir + Erlang + Phoenix installer |

---

## Framework Support

### Ruby on Rails

**Installation**:

```bash
omarchy-install-dev-env ruby
```

**What gets installed**:
- Ruby (latest via mise)
- RubyGems package manager
- Rails gem (latest stable)
- libyaml system dependency

**Configuration**:
- Enables `.ruby-version` file support
- Configures mise to auto-detect Ruby version files

**Next steps** (printed after installation):
```
You can now run: rails new myproject
```

**Example workflow**:

```bash
# Install Ruby + Rails
omarchy-install-dev-env ruby

# Create new Rails app
rails new blog --database=postgresql

cd blog

# Install database (if needed)
omarchy-install-docker-dbs PostgreSQL

# Setup database
rails db:create db:migrate

# Start server
rails server
# Visit http://localhost:3000
```

---

### Node.js / JavaScript

**Installation**:

```bash
omarchy-install-dev-env node
```

**What gets installed**:
- Node.js LTS (via mise)
- npm package manager (included with Node)

**Alternative JavaScript runtimes**:

```bash
# Bun (faster alternative to Node)
omarchy-install-dev-env bun

# Deno (secure TypeScript runtime)
omarchy-install-dev-env deno
```

**Example workflow**:

```bash
# Install Node
omarchy-install-dev-env node

# Create React app
npx create-react-app my-app
cd my-app
npm start

# Or Vue
npm create vue@latest
cd my-vue-app
npm install
npm run dev

# Or Next.js
npx create-next-app my-next-app
cd my-next-app
npm run dev
```

---

### Laravel (PHP)

**Installation**:

```bash
omarchy-install-dev-env laravel
```

**What gets installed**:
- PHP (via pacman)
- Composer (PHP package manager)
- Node.js (for Laravel Mix/Vite)
- Laravel installer (global Composer package)
- PHP extensions: sqlite, xdebug, bcmath, intl, iconv, openssl, pdo_sqlite, pdo_mysql

**Configuration**:
- Adds `~/.config/composer/vendor/bin` to PATH
- Enables common PHP extensions in `/etc/php/php.ini`
- Configures Xdebug for debugging

**Next steps**:
```
You can now run: laravel new myproject
```

**Example workflow**:

```bash
# Install Laravel environment
omarchy-install-dev-env laravel

# Create new Laravel project
laravel new blog

cd blog

# Install database
omarchy-install-docker-dbs MySQL

# Configure .env
cp .env.example .env
php artisan key:generate

# Run migrations
php artisan migrate

# Start server
php artisan serve
# Visit http://localhost:8000
```

---

### Symfony (PHP)

**Installation**:

```bash
omarchy-install-dev-env symfony
```

**What gets installed**:
- PHP (same as Laravel)
- Symfony CLI (official Symfony command-line tool)

**Example workflow**:

```bash
# Install Symfony environment
omarchy-install-dev-env symfony

# Create new Symfony web app
symfony new --webapp myproject

cd myproject

# Start Symfony server
symfony serve
# Visit https://localhost:8000
```

---

### Phoenix (Elixir)

**Installation**:

```bash
omarchy-install-dev-env phoenix
```

**What gets installed**:
- Erlang (latest via mise)
- Elixir (latest via mise)
- Hex package manager
- Rebar build tool
- Phoenix project generator (`mix phx.new`)

**Next steps**:
```
You can now run: mix phx.new my_app
```

**Example workflow**:

```bash
# Install Phoenix environment
omarchy-install-dev-env phoenix

# Create new Phoenix app
mix phx.new blog --database postgres

cd blog

# Install database
omarchy-install-docker-dbs PostgreSQL

# Create and migrate database
mix ecto.create
mix ecto.migrate

# Start Phoenix server
mix phx.server
# Visit http://localhost:4000
```

---

### Python

**Installation**:

```bash
omarchy-install-dev-env python
```

**What gets installed**:
- Python (latest via mise)
- pip package manager (included with Python)
- uv (fast Python package installer and virtual environment manager)

**Example workflow**:

```bash
# Install Python
omarchy-install-dev-env python

# Create virtual environment with uv
uv venv myproject
source myproject/bin/activate

# Install packages
uv pip install django

# Create Django project
django-admin startproject blog
cd blog

# Run server
python manage.py runserver
# Visit http://localhost:8000
```

---

### Go

**Installation**:

```bash
omarchy-install-dev-env go
```

**What gets installed**:
- Go (latest via mise)

**Example workflow**:

```bash
# Install Go
omarchy-install-dev-env go

# Create new Go module
mkdir myapp
cd myapp
go mod init github.com/username/myapp

# Create main.go
cat > main.go <<EOF
package main

import "fmt"

func main() {
    fmt.Println("Hello, Omarchy!")
}
EOF

# Run
go run main.go

# Build binary
go build -o myapp
./myapp
```

---

### Rust

**Installation**:

```bash
omarchy-install-dev-env rust
```

**What gets installed**:
- Rust (via rustup official installer)
- Cargo package manager
- rustc compiler

**Example workflow**:

```bash
# Install Rust
omarchy-install-dev-env rust

# Create new Rust project
cargo new myapp
cd myapp

# Build and run
cargo run

# Build release
cargo build --release
./target/release/myapp
```

---

### Java

**Installation**:

```bash
omarchy-install-dev-env java
```

**What gets installed**:
- Java (latest JDK via mise)

**Example workflow**:

```bash
# Install Java
omarchy-install-dev-env java

# Verify installation
java --version

# Create simple Java program
cat > Hello.java <<EOF
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Omarchy!");
    }
}
EOF

# Compile and run
javac Hello.java
java Hello
```

---

## Examples

### Example 1: Basic - Setting Up Ruby on Rails

**Scenario**: You want to build a web application with Ruby on Rails.

```bash
# Step 1: Install Ruby and Rails
$ omarchy-install-dev-env ruby
Installing Ruby on Rails...

mise ~/Users/developer/.config/mise/config.toml tools: ruby@latest
Successfully installed ruby-3.3.5
Successfully installed rails-7.1.3

You can now run: rails new myproject

# Step 2: Verify installation
$ ruby --version
ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]

$ rails --version
Rails 7.1.3

# Step 3: Create new Rails app
$ rails new blog --database=postgresql
      create
      create  README.md
      create  Rakefile
      [...]
      run  bundle install
Fetching gem metadata from https://rubygems.org/...........
[...]

# Step 4: Setup database
$ cd blog
$ omarchy-install-docker-dbs PostgreSQL

# Step 5: Create database
$ rails db:create
Created database 'blog_development'
Created database 'blog_test'

# Step 6: Start Rails server
$ rails server
=> Booting Puma
=> Rails 7.1.3 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Listening on http://127.0.0.1:3000
Use Ctrl-C to stop

# Step 7: Visit http://localhost:3000
```

**What happened**:
- Ruby 3.3 installed via mise
- Rails gem installed globally
- New Rails app created with PostgreSQL configuration
- Database running in Docker container
- Rails server accessible at localhost:3000

---

### Example 2: Intermediate - Multi-Language Project

**Scenario**: You're building a microservices application with a Go backend and React frontend.

```bash
# Install Go for backend
$ omarchy-install-dev-env go
Installing Go...
mise ~/Users/developer/.config/mise/config.toml tools: go@latest

# Install Node for frontend
$ omarchy-install-dev-env node
Installing Node.js...
mise ~/Users/developer/.config/mise/config.toml tools: node@lts

# Verify both installed
$ go version
go version go1.21.5 linux/amd64

$ node --version
v22.9.0

# Create Go API backend
$ mkdir myproject && cd myproject
$ mkdir api && cd api

$ go mod init github.com/username/myproject-api

$ cat > main.go <<'EOF'
package main

import (
    "encoding/json"
    "log"
    "net/http"
)

type Response struct {
    Message string `json:"message"`
}

func handler(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(Response{Message: "Hello from Go!"})
}

func main() {
    http.HandleFunc("/api", handler)
    log.Println("Server starting on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
EOF

$ go run main.go &
Server starting on :8080

# Create React frontend
$ cd ..
$ npx create-react-app frontend
Creating a new React app in /home/developer/myproject/frontend...
[...]

$ cd frontend

# Update App.js to call Go API
$ cat > src/App.js <<'EOF'
import React, { useEffect, useState } from 'react';

function App() {
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetch('http://localhost:8080/api')
      .then(res => res.json())
      .then(data => setMessage(data.message));
  }, []);

  return <div><h1>{message}</h1></div>;
}

export default App;
EOF

$ npm start
Compiled successfully!
Local:            http://localhost:3000

# Visit http://localhost:3000
# Should display "Hello from Go!"
```

**What happened**:
- Go and Node installed side-by-side
- Go API running on port 8080
- React app running on port 3000
- React app communicates with Go backend
- Both managed with mise version control

---

### Example 3: Advanced - Phoenix Full-Stack Application

**Scenario**: Building a real-time chat application with Phoenix LiveView.

```bash
# Step 1: Install Phoenix environment
$ omarchy-install-dev-env phoenix
Installing Phoenix Framework...

mise ~/Users/developer/.config/mise/config.toml tools: erlang@latest, elixir@latest
Successfully installed erlang-27.0
Successfully installed elixir-1.17.0
* creating /home/developer/.mix/archives/phx_new

You can now run: mix phx.new my_app

# Step 2: Verify installation
$ elixir --version
Erlang/OTP 27 [erts-15.0]
Elixir 1.17.0 (compiled with Erlang/OTP 27)

$ mix --version
Mix 1.17.0 (compiled with Erlang/OTP 27)

# Step 3: Create Phoenix app with LiveView
$ mix phx.new chat --live
* creating chat/config/config.exs
* creating chat/config/dev.exs
[...]
Fetch and install dependencies? [Yn] Y
* running mix deps.get
[...]

# Step 4: Setup PostgreSQL
$ cd chat
$ omarchy-install-docker-dbs PostgreSQL

# Step 5: Create database
$ mix ecto.create
The database for Chat.Repo has been created

# Step 6: Generate LiveView chat component
$ mix phx.gen.live Messages Message messages content:text username:string
* creating lib/chat_web/live/message_live/
[...]
* injecting lib/chat_web/router.ex

# Step 7: Run migration
$ mix ecto.migrate
[info] == Running 20241021120000 Chat.Repo.Migrations.CreateMessages.change/0 forward
[info] create table messages
[info] == Migrated 20241021120000 in 0.0s

# Step 8: Start Phoenix server
$ mix phx.server
[info] Running ChatWeb.Endpoint with Bandit 1.5.0 at 127.0.0.1:4000 (http)
[info] Access ChatWeb.Endpoint at http://localhost:4000

# Visit http://localhost:4000/messages
# Real-time chat interface powered by LiveView!
```

**Advanced: Add real-time presence**

```elixir
# lib/chat_web/live/message_live/index.ex
defmodule ChatWeb.MessageLive.Index do
  use ChatWeb, :live_view
  alias Chat.Messages
  alias ChatWeb.Presence

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Messages.subscribe()
      Presence.track(self(), "users", socket.id, %{username: "User#{:rand.uniform(100)}"})
    end

    {:ok, assign(socket, messages: Messages.list_messages(), online_users: 0)}
  end

  def handle_info({:presence_diff, _}, socket) do
    users = Presence.list("users") |> map_size()
    {:noreply, assign(socket, online_users: users)}
  end

  def handle_info({:message_created, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> [message | messages] end)}
  end
end
```

**What happened**:
- Erlang VM and Elixir installed via mise
- Phoenix framework with LiveView installed
- PostgreSQL database running in Docker
- Real-time chat with presence tracking
- Zero JavaScript required (LiveView handles real-time updates)
- Production-ready foundation for scaling

---

## Language-Specific Details

### Ruby Configuration

**Version file support**:

```bash
# Automatically enabled by omarchy-install-dev-env ruby
mise settings add idiomatic_version_file_enable_tools ruby

# Now mise reads .ruby-version files
echo "3.2.2" > .ruby-version
ruby --version  # Uses 3.2.2
```

**System dependencies**:

```bash
# libyaml required for YAML parsing (Rails, etc.)
# Automatically installed with omarchy-install-dev-env ruby
```

**Gem installation**:

```bash
# Install gems without documentation (faster)
gem install rails --no-document
```

---

### PHP Configuration

**Enabled extensions**:
- bcmath (arbitrary precision math)
- intl (internationalization)
- iconv (character encoding)
- openssl (cryptography)
- pdo_sqlite (SQLite database)
- pdo_mysql (MySQL database)

**Xdebug setup**:

Xdebug is installed and enabled automatically:

```bash
# Check Xdebug status
php -v | grep Xdebug
# Should show: with Xdebug v3.x.x

# Configure in /etc/php/conf.d/xdebug.ini
sudo nano /etc/php/conf.d/xdebug.ini
```

**Composer global packages**:

```bash
# Add to PATH automatically by omarchy-install-dev-env
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Install global packages
composer global require laravel/installer
composer global require friendsofphp/php-cs-fixer
```

---

### Python Configuration

**uv package manager**:

```bash
# Installed automatically with omarchy-install-dev-env python
# Fast alternative to pip

# Create virtual environment
uv venv myproject

# Activate
source myproject/bin/activate

# Install packages (much faster than pip)
uv pip install django flask fastapi

# Freeze dependencies
uv pip freeze > requirements.txt

# Install from requirements
uv pip install -r requirements.txt
```

---

### Elixir Configuration

**Hex and Rebar**:

Automatically installed and configured:

```bash
# Hex: Elixir package manager
mix local.hex --force

# Rebar: Erlang build tool
mix local.rebar --force
```

**Phoenix installer**:

```bash
# Installed globally as mix archive
mix archive.install hex phx_new --force

# Now available as mix phx.new
mix phx.new --version
```

---

## Troubleshooting

### Command Not Found After Installation

**Problem**: `rails: command not found` after installing Ruby

**Solution**: Reload shell

```bash
# Reload shell configuration
source ~/.bashrc

# Or restart terminal
exec bash

# Or use mise exec explicitly
mise exec -- rails --version
```

### Wrong Version Being Used

**Problem**: `ruby --version` shows old version after installation

**Solution**: Check mise current versions

```bash
# See what's active
mise current

# Force global version
mise use --global ruby@latest

# Check again
ruby --version
```

### Package Manager Not in PATH

**Problem**: `composer: command not found` after Laravel install

**Solution**: PATH was updated in .bashrc; reload it

```bash
source ~/.bashrc

# Verify PATH
echo $PATH | grep composer
# Should show: /home/user/.config/composer/vendor/bin
```

### System Package Conflicts

**Problem**: PHP install fails because it's already installed

**Solution**: Remove old version or skip system install

```bash
# Remove existing PHP
sudo pacman -R php

# Reinstall via omarchy
omarchy-install-dev-env php
```

---

## Best Practices

### 1. Install Languages Before Frameworks

If manually installing frameworks:

```bash
# Install language first
omarchy-install-dev-env node

# Then framework
npm install -g @angular/cli
```

### 2. Use Framework-Specific Installers When Available

```bash
# Use this
omarchy-install-dev-env laravel

# Instead of
omarchy-install-dev-env php
composer global require laravel/installer
```

### 3. Keep Runtimes Updated

```bash
# Update mise itself
mise self-update

# Update all language runtimes
mise upgrade
```

### 4. Use Version Files in Projects

```bash
# Lock versions in your project
cd myproject
mise use ruby@3.2.2 node@20

# Commit .tool-versions
git add .tool-versions
git commit -m "Lock runtime versions"
```

### 5. Use Docker for Databases

Instead of installing PostgreSQL/MySQL/Redis system-wide:

```bash
omarchy-install-docker-dbs PostgreSQL Redis
```

Cleaner, easier to reset, version-specific.

### 6. Install Language First, Then Test

```bash
# Install
omarchy-install-dev-env ruby

# Verify before creating projects
ruby --version
gem --version
rails --version

# Then create project
rails new myapp
```

### 7. Read Installation Output

The installer prints next steps:

```bash
$ omarchy-install-dev-env ruby
[...]
You can now run: rails new myproject
```

Follow these instructions.

---

## Related Documentation

- **[Mise Integration](./mise-integration.md)** - Understanding mise version management
- **[Docker Setup](./docker-setup.md)** - Setting up databases with Docker
- **[Editor Setup](./editor-setup.md)** - Configuring editors for language support
- **Package Management** - Installing additional development tools

**External Resources**:
- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Laravel Documentation](https://laravel.com/docs)
- [Phoenix Framework Guides](https://hexdocs.pm/phoenix/overview.html)
- [Go Documentation](https://go.dev/doc/)
- [Rust Book](https://doc.rust-lang.org/book/)
