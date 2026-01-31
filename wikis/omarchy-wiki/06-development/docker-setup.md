# Docker Setup

## Quick Start

```bash
# Install Docker (if not already installed)
sudo pacman -S docker docker-compose docker-buildx

# Start Docker daemon
sudo systemctl start docker
sudo systemctl enable docker

# Add yourself to docker group (avoid sudo)
sudo usermod -aG docker $USER
# Log out and back in for group to take effect

# Install development databases
omarchy-install-docker-dbs PostgreSQL Redis

# Install lazydocker TUI
omarchy-pkg-add lazydocker

# Launch lazydocker
lazydocker
```

---

## Table of Contents

1. [Overview](#overview)
2. [Docker Installation](#docker-installation)
3. [Database Containers](#database-containers)
4. [Lazydocker TUI](#lazydocker-tui)
5. [Docker Configuration](#docker-configuration)
6. [Examples](#examples)
   - [Basic: Setting Up PostgreSQL](#example-1-basic-setting-up-postgresql-for-development)
   - [Intermediate: Multi-Database Setup](#example-2-intermediate-multi-database-development-setup)
   - [Advanced: Custom Container Workflows](#example-3-advanced-custom-container-workflows)
7. [Docker Compose](#docker-compose)
8. [Docker Buildx](#docker-buildx)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Docker is the containerization platform used in Omarchy for running isolated development environments, databases, and services. Instead of installing databases like PostgreSQL or MySQL directly on your system, you run them in Docker containers - providing clean isolation, easy version management, and reproducible setups.

Omarchy provides `omarchy-install-docker-dbs` to quickly spin up common development databases with sensible defaults. These containers are configured to:

- **Bind to localhost only** (127.0.0.1) for security
- **Restart automatically** with `--restart unless-stopped`
- **Use standard ports** (5432 for PostgreSQL, 3306 for MySQL, etc.)
- **Require no authentication** for local development (PostgreSQL trust mode, MySQL empty password)

Additionally, `lazydocker` provides a terminal UI for managing containers, viewing logs, and monitoring resource usage - no need to remember Docker commands.

---

## Docker Installation

### Installing Docker

Docker is typically installed via the package manager:

```bash
sudo pacman -S docker docker-compose docker-buildx
```

Components:
- **docker**: Core Docker engine and CLI
- **docker-compose**: Tool for defining multi-container applications
- **docker-buildx**: Extended build capabilities with BuildKit

### Starting Docker Daemon

Enable Docker to start automatically:

```bash
# Start now
sudo systemctl start docker

# Enable on boot
sudo systemctl enable docker

# Check status
sudo systemctl status docker
```

### Running Docker Without Sudo

Add your user to the `docker` group:

```bash
# Add current user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or run:
newgrp docker

# Test: Run docker without sudo
docker ps
```

**Security note**: Users in the `docker` group have root-equivalent privileges. Only add trusted users.

### Verifying Installation

```bash
# Check Docker version
docker --version

# Run test container
docker run hello-world

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a
```

---

## Database Containers

### omarchy-install-docker-dbs

Omarchy provides a convenient installer for common development databases.

**Usage**:

```bash
# Interactive mode (select with gum)
omarchy-install-docker-dbs

# Command-line mode (specify databases)
omarchy-install-docker-dbs PostgreSQL MySQL Redis
```

**Supported databases**:
- PostgreSQL
- MySQL
- MariaDB
- Redis
- MongoDB
- MSSQL (Microsoft SQL Server)

### Database Configurations

Each database is installed with development-friendly defaults:

#### PostgreSQL

```bash
omarchy-install-docker-dbs PostgreSQL
```

**Container details**:
- **Image**: `postgres:17`
- **Name**: `postgres17`
- **Port**: `127.0.0.1:5432:5432`
- **Authentication**: Trust mode (no password required)
- **Environment**: `POSTGRES_HOST_AUTH_METHOD=trust`

**Connection string**:
```
postgresql://localhost/postgres
```

**Connecting**:
```bash
# Using psql
docker exec -it postgres17 psql -U postgres

# From host (if psql installed)
psql -h localhost -U postgres
```

#### MySQL

```bash
omarchy-install-docker-dbs MySQL
```

**Container details**:
- **Image**: `mysql:8.4`
- **Name**: `mysql8`
- **Port**: `127.0.0.1:3306:3306`
- **Root password**: Empty (no password)
- **Environment**: `MYSQL_ALLOW_EMPTY_PASSWORD=true`

**Connection string**:
```
mysql://root@localhost:3306
```

**Connecting**:
```bash
# Using mysql client
docker exec -it mysql8 mysql -u root

# From host (if mysql client installed)
mysql -h 127.0.0.1 -u root
```

#### MariaDB

```bash
omarchy-install-docker-dbs MariaDB
```

**Container details**:
- **Image**: `mariadb:11.8`
- **Name**: `mariadb11`
- **Port**: `127.0.0.1:3306:3306`
- **Root password**: Empty
- **Environment**: `MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true`

**Note**: Cannot run simultaneously with MySQL (same port 3306).

#### Redis

```bash
omarchy-install-docker-dbs Redis
```

**Container details**:
- **Image**: `redis:7`
- **Name**: `redis`
- **Port**: `127.0.0.1:6379:6379`
- **No authentication** by default

**Connecting**:
```bash
# Using redis-cli
docker exec -it redis redis-cli

# From host
redis-cli -h localhost
```

#### MongoDB

```bash
omarchy-install-docker-dbs MongoDB
```

**Container details**:
- **Image**: `mongo:noble`
- **Name**: `mongodb`
- **Port**: `127.0.0.1:27017:27017`
- **Username**: `admin`
- **Password**: `admin123`

**Connection string**:
```
mongodb://admin:admin123@localhost:27017
```

#### MSSQL (SQL Server)

```bash
omarchy-install-docker-dbs MSSQL
```

**Container details**:
- **Image**: `mcr.microsoft.com/mssql/server:2022-CU12-ubuntu-22.04`
- **Name**: `mssql`
- **Port**: `127.0.0.1:1433:1433`
- **SA password**: `@dmin123`
- **Environment**: `ACCEPT_EULA=Y`, `MSSQL_PID=Developer`

**Connection string**:
```
Server=localhost,1433;User Id=sa;Password=@dmin123;
```

---

## Lazydocker TUI

### Overview

Lazydocker is a terminal UI for Docker that provides:
- Visual container management
- Real-time log streaming
- Resource usage monitoring
- Quick container actions (start, stop, restart, remove)
- Image and volume management

### Installation

```bash
omarchy-pkg-add lazydocker
```

### Usage

Launch lazydocker:

```bash
lazydocker
```

**Keyboard shortcuts** (in lazydocker):
- `↑/↓`: Navigate containers
- `Enter`: View container details/logs
- `r`: Restart container
- `s`: Stop container
- `d`: Remove container
- `e`: Execute shell in container
- `l`: View logs
- `q`: Quit

**Interface sections**:
1. **Containers**: Running and stopped containers
2. **Images**: Downloaded Docker images
3. **Volumes**: Docker volumes
4. **Stats**: CPU, memory, network usage

### Why Use Lazydocker

**Instead of remembering**:
```bash
docker ps
docker logs -f container-name
docker exec -it container-name bash
docker stats
docker system df
```

**Just run**:
```bash
lazydocker
```

And navigate visually with arrow keys and shortcuts.

---

## Docker Configuration

### Container Auto-Restart

All containers installed via `omarchy-install-docker-dbs` use `--restart unless-stopped`:

- **Starts on boot** if Docker daemon is enabled
- **Restarts on crash** automatically
- **Stops when manually stopped** (doesn't restart after `docker stop`)

Manually adding restart policy:

```bash
docker run -d --restart unless-stopped nginx
```

Or update existing container:

```bash
docker update --restart unless-stopped container-name
```

### Port Binding Security

Omarchy binds database ports to `127.0.0.1` (localhost only) for security:

```bash
# Secure: Only accessible from host
-p 127.0.0.1:5432:5432

# Insecure: Accessible from network
-p 5432:5432  # Don't do this for databases!
```

### Data Persistence

By default, database containers store data in Docker volumes (persistent across container restarts).

To persist data with a host directory:

```bash
docker run -d \
  -v /path/on/host:/var/lib/postgresql/data \
  -e POSTGRES_HOST_AUTH_METHOD=trust \
  postgres:17
```

### Docker Daemon Configuration

Location: `/etc/docker/daemon.json`

Example configuration:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
```

Apply changes:

```bash
sudo systemctl restart docker
```

---

## Examples

### Example 1: Basic - Setting Up PostgreSQL for Development

**Scenario**: You're building a Rails app and need PostgreSQL.

```bash
# Install PostgreSQL container
$ omarchy-install-docker-dbs PostgreSQL
[docker output...]

# Verify it's running
$ docker ps
CONTAINER ID   IMAGE         STATUS          PORTS                      NAMES
abc123def456   postgres:17   Up 10 seconds   127.0.0.1:5432->5432/tcp   postgres17

# Connect to PostgreSQL
$ docker exec -it postgres17 psql -U postgres
psql (17.0)
Type "help" for help.

postgres=# CREATE DATABASE myapp_development;
CREATE DATABASE

postgres=# \l
                                                List of databases
        Name        |  Owner   | Encoding | Locale Provider |   Collation    |    Ctype
--------------------+----------+----------+-----------------+----------------+----------------
 myapp_development  | postgres | UTF8     | libc            | en_US.utf8     | en_US.utf8

postgres=# \q

# Configure Rails database.yml
$ cat config/database.yml
development:
  adapter: postgresql
  database: myapp_development
  host: localhost
  port: 5432
  username: postgres

# Run Rails migrations
$ rails db:migrate
```

**What happened**:
- PostgreSQL 17 running in Docker container
- Bound to localhost:5432
- No password required (trust authentication)
- Container auto-restarts on reboot
- Rails connects to it like a local database

---

### Example 2: Intermediate - Multi-Database Development Setup

**Scenario**: Your team uses PostgreSQL for the main app, Redis for caching, and MySQL for a legacy service.

```bash
# Install all three databases at once
$ omarchy-install-docker-dbs PostgreSQL Redis MySQL

# Check all running
$ docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
NAMES        STATUS         PORTS
postgres17   Up 5 seconds   127.0.0.1:5432->5432/tcp
redis        Up 5 seconds   127.0.0.1:6379->6379/tcp
mysql8       Up 5 seconds   127.0.0.1:3306->3306/tcp

# Open lazydocker for visual management
$ lazydocker
# [Interactive TUI appears showing all three containers]

# Test PostgreSQL
$ docker exec -it postgres17 psql -U postgres -c "SELECT version();"
                                                 version
----------------------------------------------------------------------------------------------------------
 PostgreSQL 17.0 (Debian 17.0-1.pgdg120+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 12.2.0-14) 12.2.0, 64-bit

# Test Redis
$ docker exec -it redis redis-cli ping
PONG

# Test MySQL
$ docker exec -it mysql8 mysql -u root -e "SELECT VERSION();"
+-----------+
| VERSION() |
+-----------+
| 8.4.0     |
+-----------+
```

**Application configuration** (Rails with PostgreSQL + Redis):

```yaml
# config/database.yml
production:
  adapter: postgresql
  host: localhost
  port: 5432
  database: myapp_production
  username: postgres

# config/cable.yml
production:
  adapter: redis
  url: redis://localhost:6379/1
```

**What happened**:
- Three database containers running simultaneously
- Each on standard ports (no conflicts)
- All bound to localhost for security
- All set to auto-restart
- Managed visually with lazydocker

---

### Example 3: Advanced - Custom Container Workflows

**Scenario**: You need a specific PostgreSQL version with custom configuration and persistent data.

```bash
# Create a directory for persistent data
$ mkdir -p ~/docker/postgres-data

# Run custom PostgreSQL container
$ docker run -d \
  --name postgres15-custom \
  --restart unless-stopped \
  -p 127.0.0.1:5433:5432 \
  -v ~/docker/postgres-data:/var/lib/postgresql/data \
  -v ~/docker/postgres-init.sql:/docker-entrypoint-initdb.d/init.sql \
  -e POSTGRES_PASSWORD=securepass \
  -e POSTGRES_DB=myapp \
  postgres:15

# Check it's running
$ docker ps -f name=postgres15-custom
CONTAINER ID   IMAGE         STATUS         PORTS                      NAMES
xyz789abc123   postgres:15   Up 5 seconds   127.0.0.1:5433->5432/tcp   postgres15-custom

# Monitor logs in real-time
$ docker logs -f postgres15-custom
[PostgreSQL initialization logs...]

# Connect on custom port
$ psql -h localhost -p 5433 -U postgres -d myapp
Password for user postgres: [enter securepass]
psql (15.0)
Type "help" for help.

myapp=# \dt
# [Shows tables created from init.sql]
```

**Using docker-compose for complex setup**:

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    restart: unless-stopped
    ports:
      - "127.0.0.1:5432:5432"
    environment:
      POSTGRES_PASSWORD: devpass
      POSTGRES_DB: myapp_dev
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

  redis:
    image: redis:7
    restart: unless-stopped
    ports:
      - "127.0.0.1:6379:6379"
    volumes:
      - redis-data:/data

volumes:
  postgres-data:
  redis-data:
```

Run the stack:

```bash
# Start all services
$ docker-compose up -d

# View logs
$ docker-compose logs -f

# Stop all services
$ docker-compose down

# Stop and remove volumes (deletes data)
$ docker-compose down -v
```

**What happened**:
- Custom PostgreSQL 15 on port 5433 (to avoid conflict with postgres17)
- Data persisted to `~/docker/postgres-data` (survives container deletion)
- Initialization SQL runs on first startup
- Password-protected (more secure than trust mode)
- Managed with docker-compose for reproducible setup

---

## Docker Compose

### Overview

Docker Compose is a tool for defining and running multi-container applications using YAML configuration files.

### Basic Usage

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  web:
    image: nginx
    ports:
      - "8080:80"

  db:
    image: postgres:17
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust
```

Commands:

```bash
# Start all services
docker-compose up -d

# View running services
docker-compose ps

# View logs
docker-compose logs -f web

# Stop all services
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

### Development Workflow Example

```yaml
# docker-compose.yml for Rails development
version: '3.8'

services:
  db:
    image: postgres:17
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust
    volumes:
      - postgres-data:/var/lib/postgresql/data

  redis:
    image: redis:7

  web:
    build: .
    command: rails server -b 0.0.0.0
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    depends_on:
      - db
      - redis
    environment:
      DATABASE_URL: postgresql://postgres@db/myapp_development
      REDIS_URL: redis://redis:6379/1

volumes:
  postgres-data:
```

Run the application:

```bash
docker-compose up
```

This starts PostgreSQL, Redis, and your Rails app with automatic linking.

---

## Docker Buildx

### Overview

Docker Buildx extends Docker's build capabilities with BuildKit, enabling:
- Multi-platform builds (ARM, x86)
- Advanced caching
- Parallel build stages
- Build secrets management

### Installation

Included with `docker-buildx` package:

```bash
sudo pacman -S docker-buildx
```

### Usage

Create a builder:

```bash
# Create and use a new builder
docker buildx create --use

# List builders
docker buildx ls
```

Build for multiple platforms:

```bash
# Build for ARM and x86
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myapp:latest \
  .
```

Advanced caching:

```bash
# Use cache from registry
docker buildx build \
  --cache-from type=registry,ref=myregistry/myapp:cache \
  --cache-to type=registry,ref=myregistry/myapp:cache \
  -t myapp:latest \
  .
```

---

## Troubleshooting

### Permission Denied Error

**Problem**: `docker: Got permission denied while trying to connect to the Docker daemon socket`

**Solution**: Add user to docker group

```bash
sudo usermod -aG docker $USER
newgrp docker  # Or log out and back in
```

### Container Fails to Start

**Problem**: Database container exits immediately

**Solution**: Check logs for errors

```bash
docker logs container-name

# Common issues:
# - Port already in use
# - Corrupted data volume
# - Insufficient memory
```

Fix port conflict:

```bash
# Stop conflicting service
sudo systemctl stop postgresql  # If PostgreSQL installed locally

# Or use different port
docker run -p 127.0.0.1:5433:5432 postgres:17
```

### Can't Connect to Database

**Problem**: Application can't connect to database in container

**Solution**: Check container is running and port binding

```bash
# Verify container is running
docker ps | grep postgres

# Check port binding
docker port postgres17
# Should show: 5432/tcp -> 127.0.0.1:5432

# Test connection
telnet localhost 5432
# Should connect successfully
```

Ensure connection string uses `localhost` not `127.0.0.1` (or vice versa) depending on application requirements.

### Docker Daemon Not Running

**Problem**: `Cannot connect to the Docker daemon`

**Solution**: Start Docker daemon

```bash
sudo systemctl start docker
sudo systemctl enable docker  # Auto-start on boot
```

### Cleaning Up Disk Space

Docker accumulates images, volumes, and build cache over time:

```bash
# See disk usage
docker system df

# Remove unused containers, images, networks
docker system prune

# Remove unused volumes too (WARNING: deletes data)
docker system prune --volumes

# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune -a
```

---

## Best Practices

### 1. Use Named Containers

Always name containers for easy reference:

```bash
# Good
docker run -d --name postgres-dev postgres:17

# Bad (random name)
docker run -d postgres:17
```

### 2. Bind to Localhost Only

Never expose database ports to the network:

```bash
# Secure
-p 127.0.0.1:5432:5432

# Insecure (exposes to network)
-p 5432:5432
```

### 3. Use Auto-Restart for Databases

Ensure databases restart after reboot:

```bash
docker run -d --restart unless-stopped postgres:17
```

### 4. Persist Important Data

Use volumes or bind mounts for data:

```bash
# Named volume (managed by Docker)
docker run -v postgres-data:/var/lib/postgresql/data postgres:17

# Bind mount (specific host path)
docker run -v ~/data/postgres:/var/lib/postgresql/data postgres:17
```

### 5. Use docker-compose for Multi-Container Apps

Instead of running multiple `docker run` commands, use `docker-compose.yml` for reproducible setups.

### 6. Monitor with Lazydocker

Use lazydocker for visual monitoring and management instead of memorizing CLI commands.

### 7. Clean Up Regularly

Prevent disk bloat:

```bash
# Weekly cleanup
docker system prune -f

# Monthly deep clean
docker system prune -a --volumes
```

### 8. Pin Image Versions

Use specific versions in production:

```bash
# Good
postgres:17.0

# Bad (version drifts over time)
postgres:latest
```

---

## Related Documentation

- **[Mise Integration](./mise-integration.md)** - Runtime version management
- **[Language Environments](./language-environments.md)** - Setting up development environments
- **[Editor Setup](./editor-setup.md)** - Configuring editors for development
- **Package Management** - Installing system packages

**External Resources**:
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Lazydocker GitHub](https://github.com/jesseduffield/lazydocker)
- [Docker Buildx Documentation](https://docs.docker.com/buildx/working-with-buildx/)
