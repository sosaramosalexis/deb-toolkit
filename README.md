<p align="center">
  <img src="https://i.imgur.com/UFxVF2L.png">
</p>

[![GitHub](https://img.shields.io/static/v1?label=GitHub&message=sosaramosalexis%2Fdeb-toolkit&color=181717&logo=github)](https://github.com/sosaramosalexis/deb-toolkit)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-blue?logo=gnu-bash)]()
[![Platform](https://img.shields.io/badge/platform-Linux-blue)]()

# Debian Tool Kit

Master launcher for all Debian tools — browse descriptions and run interactively.

## Quick Start

```bash
su -
bash <(curl -fsSL https://raw.githubusercontent.com/sosaramosalexis/deb-toolkit/master/install.sh)
```

## Available Tools

| # | Tool | Description |
|---|------|-------------|
| 1 | deb-autoset    | Debian auto-setup (sudo, SSH, IP login banner) |
| 2 | deb-autosetRR  | Full auto rr stack (install, OMV layout, claim, purge) |
| 3 | deb-crafty     | Minecraft Server (Crafty Controller) — web-based server manager |
| 4 | deb-procman    | Process and service manager — list, start, stop, restart, enable/disable at boot |

## Options

```bash
# Show available tools without running
bash install.sh --list

# Run a specific tool by number
bash install.sh 2

# Interactive menu (default)
bash install.sh
```

## Adding a New Tool

The toolbox is defined by [`tools.json`](tools.json). To add a new tool, edit that file:

```json
{
  "name": "my-tool",
  "desc": "What it does",
  "url": "my-tool/main/install.sh"
}
```

The `url` is relative to `https://raw.githubusercontent.com/sosaramosalexis/`. That's it — `install.sh` reads the manifest dynamically, no script changes needed.
