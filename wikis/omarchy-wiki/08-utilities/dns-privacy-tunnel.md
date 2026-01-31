# DNS Privacy Tunnel

**Purpose:** Complete DNS privacy via private recursive DNS resolver on your internetuniverse server, tunneled through sshuttle VPN.

**Use Case:** Route all DNS queries through your own server for maximum privacy - no third-party DNS providers, all queries go directly to root DNS servers.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Overview](#overview)
- [Architecture](#architecture)
- [Setup](#setup)
- [Scripts](#scripts)
- [Configuration](#configuration)
- [Privacy & Security](#privacy--security)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

### Start DNS Tunnel

dns-tunnel-on

Or use SUPER + O → Start DNS Tunnel

### Stop DNS Tunnel

dns-tunnel-off

Or use SUPER + O → Stop DNS Tunnel

### Check Status

dns-tunnel-status

Or use SUPER + O → DNS Tunnel Status

---

## Overview

The DNS privacy tunnel provides **maximum DNS privacy** by:

1. **Your Own Recursive Resolver** - Unbound on internetuniverse server queries root DNS directly
2. **No Third Parties** - No Quad9, Cloudflare, Google, or any DNS provider involved
3. **Encrypted Tunnel** - All DNS traffic tunneled through SSH via sshuttle
4. **Complete Privacy** - No logging, no tracking, no external visibility

### Privacy Level: Maximum

```
omarchy → sshuttle (SSH tunnel) → internetuniverse server → Unbound → Root DNS servers
```

**What this means:**
- ✅ ISP cannot see your DNS queries (encrypted via SSH)
- ✅ No DNS provider logging your queries (you ARE the DNS provider)
- ✅ Queries go directly to authoritative servers (no middleman)
- ✅ DNSSEC validation ensures authenticity
- ✅ Local caching for performance

---

## Architecture

### Components

**Server-Side (internetuniverse - 195.250.27.45):**
- **Unbound** - Recursive DNS resolver
- Config: `/etc/unbound/unbound.conf.d/privacy.conf`
- Listens on: All interfaces (port 53)
- Features: DNSSEC validation, aggressive caching, query minimization

**Client-Side (omarchy):**
- **sshuttle** - VPN-like SSH tunnel
- Routes: All DNS traffic (port 53) + optionally all traffic
- Connection: SSH to internet@195.250.27.45
- Auto-reconnect: On disconnect

### Data Flow

1. **Application makes DNS query** (e.g., Firefox requests "example.com")
2. **Local resolver intercepts** (systemd-resolved)
3. **sshuttle routes through tunnel** (encrypted via SSH)
4. **internetuniverse server receives** query
5. **Unbound queries root DNS** (recursive resolution)
6. **Result cached** (both server and client)
7. **Response returned** to application

---

## Setup

### Part 1: Server Setup (internetuniverse)

Run on your omarchy machine:

dns-server-setup

This script will:
1. SSH to internetuniverse server
2. Install Unbound
3. Deploy privacy-focused configuration
4. Download root hints and trust anchors
5. Start and enable Unbound service
6. Test DNS resolution

**Manual steps if needed:**

ssh internet

Install Unbound:

sudo yum install -y unbound

Or on Debian/Ubuntu:

sudo apt-get install -y unbound

Deploy config:

Place config at `/etc/unbound/unbound.conf.d/privacy.conf`
(Config file location: `~/.local/share/unbound-privacy.conf`)

Start service:

sudo systemctl enable --now unbound

Test:

dig @127.0.0.1 example.com

### Part 2: Client Setup (omarchy)

**Already complete!** Scripts are ready:
- ✅ sshuttle installed
- ✅ dns-tunnel-on script created
- ✅ dns-tunnel-off script created
- ✅ dns-tunnel-status script created
- ✅ SUPER+O menu integration added

### Part 3: Optional Auto-Start

Enable DNS tunnel on login:

systemctl --user enable dns-tunnel.service

Disable auto-start:

systemctl --user disable dns-tunnel.service

---

## Scripts

### dns-server-setup

Location: `~/.local/bin/dns-server-setup`

**Purpose:** Deploy Unbound to internetuniverse server (one-time setup)

**Usage:**

dns-server-setup

**What it does:**
- Uploads Unbound configuration
- Installs Unbound on server
- Downloads root hints and trust anchors
- Starts Unbound service
- Tests DNS resolution

**Note:** Run once to set up the server

---

### dns-tunnel-on

Location: `~/.local/bin/dns-tunnel-on`

**Purpose:** Start DNS privacy tunnel

**Usage:**

dns-tunnel-on

**Features:**
- Tests SSH connection first
- Starts sshuttle VPN tunnel
- Routes DNS queries (port 53) through tunnel
- Optionally routes all traffic (0/0)
- Excludes local networks (192.168.x.x, 10.x.x.x)
- Anti-fingerprinting: Human-like delay (0.43-2s) after network check

**Example Output:**

🔒 Starting DNS privacy tunnel...

🔍 Testing SSH connection to internet...
🚀 Starting sshuttle VPN tunnel...
   Server: 195.250.27.45
   Routing: DNS queries (port 53)

✅ DNS tunnel is active!

All DNS queries now route through your private server

Test with: dig example.com
Status: dns-tunnel-status
Stop: dns-tunnel-off

---

### dns-tunnel-off

Location: `~/.local/bin/dns-tunnel-off`

**Purpose:** Stop DNS privacy tunnel

**Usage:**

dns-tunnel-off

**Features:**
- Gracefully stops sshuttle
- Cleans up PID file
- Verifies shutdown
- Returns to default DNS (Quad9 if configured)

---

### dns-tunnel-status

Location: `~/.local/bin/dns-tunnel-status`

**Purpose:** Check DNS tunnel status and test resolution

**Usage:**

dns-tunnel-status

**Features:**
- Shows tunnel running/stopped status
- Displays process info (PID, runtime)
- Tests DNS resolution
- Shows active DNS servers
- Provides control commands

**Example Output:**

🔍 DNS Tunnel Status
====================

Status: ✅ ACTIVE

Process:
  PID: 12345 | Started: 10:30 | Runtime: 0:15

Tunnel Details:
  Server: internet (195.250.27.45)
  Mode: Full VPN with DNS routing

DNS Test:
  ✅ DNS resolution working

Active DNS Servers:
  Current DNS Server: 195.250.27.45

Controls:
  dns-tunnel-on  - Start tunnel
  dns-tunnel-off - Stop tunnel

---

### dns-config-backup

Location: `~/.local/bin/dns-config-backup`

**Purpose:** Backup DNS configuration before changes

**Usage:**

dns-config-backup

**What it does:**
- Backs up `/etc/systemd/resolved.conf`
- Saves current DNS settings
- Creates timestamped restore script

**Backups:** `~/dev/lib/omarchy-archive/08-utilities/dns-backups/`

**Restore:**

~/dev/lib/omarchy-archive/08-utilities/dns-backups/[timestamp]/restore.sh

---

## Configuration

### Unbound Server Configuration

File: `/etc/unbound/unbound.conf.d/privacy.conf`

**Key Settings:**

**Privacy:**
- No query logging
- No reply logging
- Hide server identity
- Query name minimization (send minimal info to upstream)

**Security:**
- DNSSEC validation enabled
- Harden against DNS attacks
- Block private address responses

**Performance:**
- 2 threads
- 128MB message cache
- 256MB RRset cache
- Cache TTL: 1-24 hours
- Prefetch popular queries

**Access Control:**
- Allow: localhost, RFC1918 private networks
- Deny: everything else

### sshuttle Tunnel Configuration

**Routing:**
- Mode: Full VPN (0/0)
- Excludes: Local networks (192.168.x.x, 10.x.x.x)
- DNS: Routed through tunnel (--dns flag)

**Connection:**
- Remote: internet@195.250.27.45
- Auth: SSH key (from ~/.ssh/config)
- Daemon: Yes (runs in background)
- PID file: /tmp/dns-tunnel.pid

---

## Privacy & Security

### Privacy Guarantees

✅ **No Third-Party DNS Providers**
- Unbound queries root DNS directly
- No Quad9, Cloudflare, Google, etc.
- You control the entire DNS path

✅ **No Query Logging**
- Unbound configured with `log-queries: no`
- No record of what domains you visit
- Complete privacy

✅ **Encrypted Transport**
- All DNS queries tunneled via SSH
- ISP cannot see DNS traffic
- Man-in-the-middle protection

✅ **DNSSEC Validation**
- Cryptographic verification of DNS responses
- Protection against DNS spoofing
- Root trust anchor updated automatically

### Security Considerations

**Benefits:**
- ✅ ISP cannot monitor DNS queries
- ✅ No centralized DNS logging
- ✅ DNSSEC prevents spoofing
- ✅ SSH tunnel provides encryption

**Trade-offs:**
- ⚠️ internetuniverse server can see your DNS queries
- ⚠️ Server logs connections (but not queries)
- ⚠️ Requires trust in your server provider

**Mitigation:**
- Server is YOUR cPanel host (you control it)
- Unbound logging disabled in config
- SSH key authentication only
- Can audit server logs anytime

### Anti-Fingerprinting

**Human-like Delays:**
- Random delay (0.43-2s) after network checks
- Prevents timing-based fingerprinting
- Mimics human interaction patterns

---

## Troubleshooting

### Tunnel Won't Start

**Problem:** `dns-tunnel-on` fails with connection error

**Solutions:**

1. Test SSH connection:

ssh internet

2. Check if tunnel already running:

dns-tunnel-status

3. Stop existing tunnel first:

dns-tunnel-off

4. Check sshuttle is installed:

pacman -Q sshuttle

---

### DNS Resolution Fails

**Problem:** DNS queries timeout or fail

**Solutions:**

1. Check tunnel status:

dns-tunnel-status

2. Test server DNS directly:

ssh internet 'dig @127.0.0.1 example.com'

3. Check Unbound on server:

ssh internet 'sudo systemctl status unbound'

4. View Unbound logs:

ssh internet 'sudo journalctl -u unbound -n 50'

---

### Slow DNS Queries

**Problem:** DNS resolution is slower than before

**Explanation:**
- Recursive DNS is slower than forwarding DNS
- First query to a domain is uncached (slower)
- Subsequent queries are fast (cached)

**Solutions:**

1. **Normal behavior** - First queries are slower, accept it
2. **Prefetch enabled** - Popular queries cached before expiry
3. **Increase cache size** - Edit Unbound config (already at 256MB)
4. **Use hybrid mode** - Forward to Quad9 instead of recursive

---

### Tunnel Disconnects Frequently

**Problem:** sshuttle keeps disconnecting

**Solutions:**

1. Check internet connection stability
2. Enable systemd auto-restart:

systemctl --user enable dns-tunnel.service

3. Check server SSH config (ServerAliveInterval in ~/.ssh/config)
4. Increase SSH keepalive:

Edit ~/.ssh/config:
ServerAliveInterval 15
ServerAliveCountMax 3

---

### Can't Access Local Network

**Problem:** Local devices unreachable when tunnel active

**Explanation:** sshuttle excludes local networks by default

**Solutions:**

Edit `dns-tunnel-on` script, ensure these lines exist:

--exclude 192.168.0.0/16 --exclude 10.0.0.0/8

This excludes local networks from tunneling.

---

## Performance Expectations

### DNS Query Times

**Before (Quad9 DNS-over-TLS):**
- First query: ~50-100ms
- Cached query: <10ms

**After (Private Recursive DNS):**
- First query (uncached): ~200-500ms
- Cached query: ~50-100ms (via tunnel)
- Second query (server cached): ~20-50ms

**Note:** Privacy has a small performance cost. Recursive DNS is inherently slower than forwarding DNS.

### Caching Benefits

**After running for a while:**
- Popular domains cached on server (1-24 hours)
- Repeat queries very fast (<50ms)
- Prefetch keeps cache warm

---

## Related Documentation

- [SSH Control](./ssh-control.md) - SSH server management
- [Network Drive Mounting](./network-drive-mounting.md) - SSHFS integration
- [Security & Auth](../07-system-setup/security-auth.md) - SSH key management

---

**Created:** 2025-11-02
**Updated:** 2025-11-02
**Purpose:** Maximum DNS privacy via private recursive resolver on internetuniverse server

## Change Log

- **2025-11-02:** Initial documentation created
- **2025-11-02:** Added sshuttle VPN tunnel integration
- **2025-11-02:** Added Unbound recursive resolver setup
- **2025-11-02:** Added SUPER+O menu integration
- **2025-11-02:** Added anti-fingerprinting delays
