# Productivity Applications

Productivity and office applications pre-installed in omarchy for document creation, note-taking, and communication.

## Table of Contents
- [Overview](#overview)
- [Note-Taking](#note-taking)
- [Document Editing](#document-editing)
- [PDF Annotation](#pdf-annotation)
- [Communication](#communication)
- [File Sharing](#file-sharing)
- [Virtualization](#virtualization)
- [Examples](#examples)
- [Related Documentation](#related-documentation)

## Overview

Omarchy includes professional productivity applications for knowledge management, document creation, and collaboration. All applications are optimized for Wayland and integrate with the omarchy theme system.

**Key Productivity Apps:**
- **Obsidian** - Powerful knowledge base and note-taking
- **Typora** - Beautiful Markdown editor
- **LibreOffice** - Full office suite
- **Xournalpp** - PDF annotation and handwriting
- **Signal Desktop** - Secure messaging
- **LocalSend** - Cross-platform file sharing
- **Windows VM** - Virtualized Windows environment

All applications are installed via `omarchy-base.packages`.

## Note-Taking

### Obsidian

**Package:** `obsidian`

**Description:** Knowledge base and note-taking app with bidirectional linking and graph view.

**Launch:**
```bash
obsidian
# Or via Walker: Super key -> "Obsidian"
```

**Features:**
- Markdown-based notes
- Bidirectional links [[like this]]
- Graph view of connections
- Canvas for visual thinking
- Plugin ecosystem
- Templates
- Daily notes
- Sync across devices (paid)
- Themes and customization

**Theme Integration:**

Obsidian automatically adopts omarchy themes via `omarchy-theme-set-obsidian`.

**Vault Setup:**
1. Launch Obsidian
2. Create new vault or open existing
3. Choose vault location (e.g., `~/Documents/Notes`)
4. Theme automatically applied

**Vault Registry:**

Omarchy tracks Obsidian vaults in `~/.local/state/omarchy/obsidian-vaults`. The theme system automatically:
- Scans `~/Documents` and `~/Dropbox` for vaults
- Installs Omarchy theme in each vault
- Updates theme when changing omarchy theme

**Manual Vault Registration:**
```bash
# Add vault to registry
echo "$HOME/Documents/MyVault" >> ~/.local/state/omarchy/obsidian-vaults

# Apply theme to all registered vaults
omarchy-theme-set-obsidian
```

**Useful Plugins:**
- **Dataview** - Query and display notes
- **Templater** - Advanced templates
- **Calendar** - Daily note calendar
- **Excalidraw** - Drawings in notes
- **Git** - Version control integration

### Typora

**Package:** `typora`

**Description:** Clean, distraction-free Markdown editor with live preview.

**Launch:**
```bash
typora document.md
# Or via Walker
```

**Features:**
- Live Markdown preview (WYSIWYG-style)
- Clean, minimal interface
- Tables, code blocks, math
- Diagram support (Mermaid, sequence)
- Export to PDF, HTML, Word
- Focus mode
- File tree sidebar
- Custom themes

**Usage:**
```bash
# Open file
typora document.md

# Create new file
typora

# Open directory
typora ~/Documents/Notes/
```

**Export:**
- File > Export > Choose format (PDF, HTML, Word, etc.)

**Best For:**
- Single-document editing
- Writing blog posts
- Documentation
- Academic writing
- Quick Markdown editing

## Document Editing

### LibreOffice

**Package:** `libreoffice`

**Description:** Full-featured office suite compatible with Microsoft Office formats.

**Launch:**
```bash
# Launch suite
libreoffice

# Specific applications
libreoffice --writer    # Word processor
libreoffice --calc      # Spreadsheet
libreoffice --impress   # Presentations
libreoffice --draw      # Diagrams
```

**Applications:**

**Writer** - Word processor
- DOCX, ODT, RTF formats
- Styles and formatting
- Tables and images
- Track changes
- Mail merge
- PDF export

**Calc** - Spreadsheet
- XLSX, ODS formats
- Formulas and functions
- Charts and graphs
- Pivot tables
- Data analysis
- Macros

**Impress** - Presentations
- PPTX, ODP formats
- Slide templates
- Animations
- Presenter view
- PDF export
- Embedded media

**Draw** - Vector graphics
- Diagrams and flowcharts
- Technical drawings
- Org charts
- PDF editing (limited)

**Usage:**
```bash
# Open document
libreoffice document.docx

# Create new document
libreoffice --writer

# Convert to PDF
libreoffice --headless --convert-to pdf document.docx

# Batch convert
libreoffice --headless --convert-to pdf *.docx
```

**Format Compatibility:**
- Microsoft Office (DOCX, XLSX, PPTX)
- OpenDocument (ODT, ODS, ODP)
- PDF (read and export)
- Legacy formats (DOC, XLS, PPT)

## PDF Annotation

### Xournalpp

**Package:** `xournalpp`

**Description:** PDF annotation and digital handwriting application with stylus support.

**Launch:**
```bash
xournalpp
# Or via Walker
```

**Features:**
- PDF annotation
- Handwriting recognition
- Pen and highlighter tools
- Shape tools
- Text tool
- Eraser
- Layers
- Stylus pressure support
- Export to PDF with annotations

**Usage:**
```bash
# Open PDF for annotation
xournalpp document.pdf

# Create new notebook
xournalpp

# Open existing Xournal++ file
xournalpp notes.xopp
```

**Workflow:**
1. Open PDF or create notebook
2. Select pen/highlighter/text tool
3. Annotate document
4. Export as annotated PDF: File > Export as PDF

**Best For:**
- Annotating PDFs
- Digital note-taking
- Tablet/stylus input
- Lecture notes
- Form filling
- Signing documents

**Keyboard Shortcuts:**
- `Ctrl+N` - New page
- `Ctrl+S` - Save
- `P` - Pen tool
- `H` - Highlighter
- `T` - Text tool
- `E` - Eraser
- `Ctrl+Z` - Undo

## Communication

### Signal Desktop

**Package:** `signal-desktop`

**Description:** Secure, encrypted messaging application.

**Launch:**
```bash
signal-desktop
# Or via Walker: Super key -> "Signal"
```

**Features:**
- End-to-end encryption
- Voice and video calls
- Group chats
- File sharing
- Disappearing messages
- Desktop notifications
- Screen sharing
- Sync with mobile

**Setup:**
1. Launch Signal Desktop
2. Open Signal on phone
3. Settings > Linked Devices > Link New Device
4. Scan QR code on desktop

**Usage:**
- Send messages with encryption
- Make voice/video calls
- Share files and media
- Create group chats
- Set message timers

**Privacy Features:**
- No message metadata stored
- Open-source protocol
- Screen security (disable screenshots)
- Note-to-self for sync
- Relay calls to hide IP

## File Sharing

### LocalSend

**Package:** `localsend`

**Description:** Cross-platform local file sharing (AirDrop alternative).

**Launch:**
```bash
localsend
# Or via Walker: Super key -> "LocalSend"
```

**Features:**
- Wi-Fi-based sharing
- No internet required
- Cross-platform (Linux, Windows, macOS, iOS, Android)
- No setup required
- Fast transfers
- Encrypted connections
- Discover devices automatically

**Usage:**
1. Launch LocalSend on both devices
2. Ensure devices on same network
3. Select files to send
4. Choose recipient device
5. Accept on receiving device

**Sending Files:**
```bash
# GUI method
1. Open LocalSend
2. Click "Send" or drag files
3. Select recipient
4. Wait for acceptance

# Devices appear automatically on local network
```

**Receiving Files:**
```bash
# LocalSend runs in background
# Notification appears when files incoming
# Click to accept or decline
# Files saved to ~/Downloads by default
```

**Best For:**
- Quick file transfers between devices
- Sharing photos from phone to computer
- Transferring files without cloud services
- Local network file sharing
- Privacy-focused transfers

## Virtualization

### Windows VM

**Command:** `omarchy-windows-vm [install|launch|status|stop|remove]`

**Description:** Automated Windows virtual machine setup using Docker and freerdp.

**Installation:**
```bash
# Install Windows VM
omarchy-windows-vm install

# Follow prompts:
# 1. Select RAM allocation (e.g., 4G)
# 2. Select CPU cores (e.g., 2)
# 3. Select disk size (e.g., 64GB)
# 4. Wait for Windows installation (~20 minutes)
```

**System Requirements:**
- KVM virtualization support (check: `ls /dev/kvm`)
- Sufficient disk space (disk size + 10GB)
- Sufficient RAM (allocated amount available)
- Fast storage (SSD recommended)

**Usage:**
```bash
# Launch Windows VM
omarchy-windows-vm launch

# Check status
omarchy-windows-vm status

# Stop VM
omarchy-windows-vm stop

# Remove VM (delete all data)
omarchy-windows-vm remove
```

**Features:**
- Automated Windows installation
- RDP connection (freerdp)
- Clipboard sharing
- File sharing support
- GPU acceleration (if available)
- Configurable resources
- Auto-start option

**Accessing Windows:**

After launching, connection opens automatically via freerdp. If disconnected:

```bash
# Reconnect manually
freerdp /v:localhost:8006 /u:User /p: /dynamic-resolution /audio-mode:1
```

**Desktop Entry:**

A desktop launcher is created at `~/.local/share/applications/windows-vm.desktop`:

```bash
# Launch via Walker
Super key -> "Windows"
```

**File Sharing:**

Files can be shared between host and VM:
```bash
# Mount host directory in freerdp
freerdp /v:localhost:8006 /drive:shared,/home/$USER/Shared
```

**Use Cases:**
- Running Windows-only software
- Testing Windows applications
- Microsoft Office (Windows version)
- Windows development
- Gaming (limited performance)

## Examples

### Example 1: Obsidian Knowledge Base Setup

```bash
# 1. Create vault directory
mkdir -p ~/Documents/Knowledge

# 2. Launch Obsidian
obsidian

# 3. Create new vault
# File > Open Vault > Create new vault
# Location: ~/Documents/Knowledge

# 4. Configure vault
# Settings > Files & Links
# Default location for new notes: In the folder specified below
# Folder: Notes/

# 5. Install plugins
# Settings > Community Plugins > Browse
# Install: Dataview, Templater, Calendar

# 6. Create daily note template
mkdir -p ~/Documents/Knowledge/Templates
cat > ~/Documents/Knowledge/Templates/Daily.md << 'EOF'
# {{date:YYYY-MM-DD}}

## Tasks
- [ ]

## Notes

## Log
EOF

# 7. Configure daily notes
# Settings > Daily Notes
# Template: Templates/Daily
# Open daily note on startup: enabled

# Theme automatically applied via omarchy-theme-set-obsidian
```

### Example 2: Document Workflow with LibreOffice

```bash
# 1. Create document
libreoffice --writer

# 2. Write content
# Use styles: Heading 1, Heading 2, Body Text
# Insert images, tables, etc.

# 3. Save as DOCX for compatibility
# File > Save As > Microsoft Word 2007-365 (.docx)

# 4. Export to PDF
# File > Export as PDF
# Or via command line:
libreoffice --headless --convert-to pdf document.docx

# 5. Create presentation
libreoffice --impress

# 6. Import slides from template
# File > New > Templates > Presentations

# 7. Export presentation
# File > Export as PDF
# Or: File > Export as PDF (with notes)
```

### Example 3: PDF Annotation Workflow

```bash
# 1. Open PDF in Xournalpp
xournalpp research-paper.pdf

# 2. Select highlighter tool (H)
# Highlight important text

# 3. Select pen tool (P)
# Add handwritten notes in margins

# 4. Add text tool (T)
# Type comments and annotations

# 5. Add shapes
# Tools > Rectangle/Circle/Arrow
# Draw attention to key points

# 6. Add layers (optional)
# Layer > New Layer
# Keep annotations separate from original

# 7. Export annotated PDF
# File > Export as PDF
# Save as: research-paper-annotated.pdf

# 8. Share annotated version
localsend
# Send annotated PDF to mobile device
```

### Example 4: Cross-Platform File Sharing

```bash
# Scenario: Share photos from phone to computer

# On computer:
# 1. Launch LocalSend
localsend

# 2. LocalSend runs in background

# On phone:
# 3. Open LocalSend app
# 4. Select photos
# 5. Tap computer name
# 6. Send

# On computer:
# 7. Notification appears
# 8. Click "Accept"
# 9. Files saved to ~/Downloads

# Scenario: Share document to multiple devices
# 1. Open LocalSend
# 2. Drag document.pdf to LocalSend
# 3. Select multiple recipients
# 4. Send to all simultaneously
```

### Example 5: Windows VM Setup and Usage

```bash
# 1. Check virtualization support
ls /dev/kvm
# If exists, virtualization is available

# 2. Install Windows VM
omarchy-windows-vm install

# Follow prompts:
# - RAM: 4G (for general use)
# - CPU: 2 cores
# - Disk: 64GB

# Wait for installation (~20 minutes)

# 3. Launch Windows
omarchy-windows-vm launch

# Windows boots and RDP connects automatically

# 4. In Windows:
# - Complete Windows setup
# - Install software
# - Configure as needed

# 5. Stop VM when done
omarchy-windows-vm stop

# 6. Launch again later
omarchy-windows-vm launch

# 7. Check status
omarchy-windows-vm status
# Output: Container running, RDP port active

# 8. Quick launch via desktop
# Super key -> "Windows"
```

### Example 6: Markdown Workflow with Typora

```bash
# 1. Create blog post
typora ~/Documents/Blog/new-post.md

# 2. Write in Markdown with live preview
# # Title
# ## Introduction
# Content with **bold** and *italic*

# 3. Add images
# ![Alt text](image.png)
# Or: Format > Image > Insert Image

# 4. Add code blocks
# ```python
# def hello():
#     print("Hello, World!")
# ```

# 5. Add table
# | Column 1 | Column 2 |
# |----------|----------|
# | Data 1   | Data 2   |

# 6. Export to PDF
# File > Export > PDF

# 7. Export to HTML for blog
# File > Export > HTML

# 8. View in browser
firefox new-post.html
```

## Package List

Productivity apps from `omarchy-base.packages`:

```
# Note-Taking
obsidian               # Knowledge base
typora                 # Markdown editor

# Office Suite
libreoffice            # Full office suite

# PDF & Annotation
xournalpp              # PDF annotation
evince                 # PDF viewer

# Communication
signal-desktop         # Secure messaging

# File Sharing
localsend              # Local file sharing

# Supporting Tools
gnome-calculator       # Calculator
```

## Troubleshooting

### Obsidian Theme Not Applied

**Problem:** Obsidian doesn't use omarchy theme

**Solution:**
```bash
# Manually apply theme to all vaults
omarchy-theme-set-obsidian

# Register vault if not detected
echo "$HOME/Documents/MyVault" >> ~/.local/state/omarchy/obsidian-vaults
omarchy-theme-set-obsidian

# In Obsidian:
# Settings > Appearance > Themes > Omarchy
```

### LibreOffice Opens with Wrong Language

**Problem:** LibreOffice interface in unexpected language

**Solution:**
```bash
# Check system locale
echo $LANG

# Set LibreOffice language
# Tools > Options > Language Settings > Languages
# User interface: English (USA)

# Or reinstall with language pack
omarchy-pkg-add libreoffice-fresh-en-us
```

### Signal Desktop Won't Link

**Problem:** Can't link Signal Desktop to phone

**Solution:**
```bash
# Ensure Signal on phone is updated
# In phone: Settings > Linked Devices > Link New Device

# On desktop:
signal-desktop

# If QR code doesn't appear:
# File > Restart and Link

# Check camera permissions on phone

# Ensure devices on same network (for faster sync)
```

### Windows VM Installation Fails

**Problem:** Windows VM installation fails with KVM error

**Solution:**
```bash
# Check KVM support
ls -l /dev/kvm

# Enable KVM module
# For Intel:
sudo modprobe kvm-intel

# For AMD:
sudo modprobe kvm-amd

# Check virtualization in BIOS
# Ensure Intel VT-x or AMD-V is enabled

# Verify permissions
sudo chown $USER:kvm /dev/kvm
```

### LocalSend Can't Find Devices

**Problem:** LocalSend doesn't discover other devices

**Solution:**
```bash
# Ensure devices on same network
ip addr show

# Check firewall
sudo ufw status

# Allow LocalSend port (53317)
sudo ufw allow 53317

# Restart LocalSend
pkill localsend
localsend

# Check network discovery
# Router settings: ensure client isolation disabled
```

### Xournalpp Export Not Working

**Problem:** Can't export PDF with annotations

**Solution:**
```bash
# Ensure PDF export support
pacman -Q poppler

# File > Export as PDF (not Export)
# Export as PDF includes annotations
# Export saves .xopp format only

# If still issues, save as .xopp first:
# File > Save
# Then: File > Export as PDF
```

## Best Practices

### Note-Taking
- **Obsidian**: Use daily notes for consistency
- Create templates for common note types
- Use tags and links for organization
- Regular vault backups
- Keep vault in synced directory (Dropbox, etc.)

### Document Editing
- Use styles instead of manual formatting
- Save in native format (.odt) for full features
- Export to .docx/.pdf for sharing
- Regular saves during editing
- Use templates for consistent documents

### PDF Annotation
- Layer annotations separately from original
- Use highlighter for text emphasis
- Use pen for handwriting notes
- Export as new file, keep original
- Regular saves during annotation

### Communication
- Enable disappearing messages for sensitive topics
- Use note-to-self for private notes
- Regular backup of Signal data
- Screen security on for privacy
- Voice/video for important conversations

### File Sharing
- Keep LocalSend running in background
- Check network before sharing
- Verify recipient before sending
- Use for local transfers only
- Prefer LocalSend over cloud for privacy

### Virtualization
- Allocate appropriate resources (not too much)
- Stop VM when not in use
- Regular Windows updates inside VM
- Backup important VM data
- Use snapshots before major changes

## Related Documentation

- [Core Applications](./core-applications.md) - Essential applications
- [Media Tools](./media-tools.md) - Media creation tools
- [Development Tools](./development-tools.md) - Developer applications
- [Desktop Environment](../04-desktop-environment/hyprland-integration.md) - Window management
- [Theming](../03-theming/theme-system.md) - Application theming

---

*Last Updated: 2025-10-21*
*Source: omarchy-base.packages, omarchy-windows-vm, omarchy-theme-set-obsidian*
