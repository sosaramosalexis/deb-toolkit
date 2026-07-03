#!/usr/bin/env bash
set -u

log()  { echo "[+] $1"; }
info() { echo "[*] $1"; }
err()  { echo "[-] $1" >&2; }

MANIFEST_URL="https://raw.githubusercontent.com/sosaramosalexis/deb-toolkit/master/tools.json"

usage() {
    cat <<EOF
Usage: bash install.sh [options]

Options:
  --list          List available tools and exit
  <number>        Run a specific tool by number (non-interactive)
  --help          Show this help
EOF
    exit 0
}

[[ $# -ge 1 && "$1" == "--help" ]] && usage

# Fetch toolbox manifest
TOOLS=()
while IFS='|' read -r name desc url; do
    TOOLS+=("$name|$desc|$url")
done < <(curl -fsSL "$MANIFEST_URL" 2>/dev/null | python3 -c "
import sys, json
for t in json.load(sys.stdin):
    print(t['name'] + '|' + t['desc'] + '|' + t['url'])
" 2>/dev/null)

if [[ ${#TOOLS[@]} -eq 0 ]]; then
    err "Failed to fetch toolbox manifest."
    err "Try again or manually run a tool:"
    echo "  curl -fsSL https://raw.githubusercontent.com/sosaramosalexis/deb-autoset/main/install.sh | bash"
    exit 1
fi

[[ $# -ge 1 && "$1" == "--list" ]] && {
    info "Available tools:"
    for i in "${!TOOLS[@]}"; do
        IFS='|' read -r name desc _ <<< "${TOOLS[$i]}"
        [[ "${#desc}" -gt 50 ]] && desc="${desc:0:47}..."
        echo "  $((i+1))) $name — $desc"
    done
    exit 0
}

run_tool() {
    local idx=$1
    IFS='|' read -r name desc url <<< "${TOOLS[$idx]}"
    local full_url="https://raw.githubusercontent.com/sosaramosalexis/$url"

    echo ""
    echo "Tool:  $name"
    echo "Desc:  $desc"
    echo "Source: $full_url"
    read -rp "Download and run? [y/N]: " confirm
    if [[ "$confirm" =~ ^[yY] ]]; then
        bash <(curl -fsSL "$full_url") < /dev/tty
    fi
}

# --- Main ---
if [[ $# -ge 1 ]]; then
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        idx=$(( $1 - 1 ))
        if [[ $idx -ge 0 && $idx -lt ${#TOOLS[@]} ]]; then
            run_tool $idx
            exit 0
        fi
    fi
    err "Invalid option: $1"
    usage
fi

while true; do
    echo ""
    echo "Debian Tool Kit"
    echo "Select a tool to run:"
    echo ""
    for i in "${!TOOLS[@]}"; do
        IFS='|' read -r name desc _ <<< "${TOOLS[$i]}"
        [[ "${#desc}" -gt 50 ]] && desc="${desc:0:47}..."
        printf "  %d) %s — %s\n" "$((i+1))" "$name" "$desc"
    done
    echo "  q) Quit"
    read -rp "Choice: " choice
    [[ "$choice" == "q" || "$choice" == "Q" ]] && { log "Goodbye."; exit 0; }
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
        idx=$(( choice - 1 ))
        if [[ $idx -ge 0 && $idx -lt ${#TOOLS[@]} ]]; then
            run_tool $idx
        fi
    fi
    if [[ -t 0 ]]; then
        read -rp "  Press Enter to continue..."
    fi
done
