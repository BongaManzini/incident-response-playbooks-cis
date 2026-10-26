#!/usr/bin/env bash
# ==============================================================================
# CIS Ubuntu / Debian Linux Benchmark Level 2 Automated Auditor
# Author: Bonga Manzini <contact@bongamanzini.dev>
# Domain: Enterprise Linux Hardening & Compliance
# ==============================================================================

set -uo pipefail

RESULTS_FILE="cis_audit_raw.json"
echo "[" > "$RESULTS_FILE"
FIRST_ENTRY=true

log_check() {
    local id="$1"
    local desc="$2"
    local status="$3"
    local details="$4"

    if [ "$FIRST_ENTRY" = true ]; then
        FIRST_ENTRY=false
    else
        echo "," >> "$RESULTS_FILE"
    fi

    cat <<EOF >> "$RESULTS_FILE"
  {
    "check_id": "$id",
    "description": "$desc",
    "status": "$status",
    "details": "$details"
  }
EOF
}

echo "=== Starting CIS Linux Benchmark Level 2 Audit ==="

# Check 1: SSH PermitRootLogin Disabled
if grep -Eq '^\s*PermitRootLogin\s+no' /etc/ssh/sshd_config 2>/dev/null; then
    log_check "CIS-5.2.10" "Ensure SSH PermitRootLogin is disabled" "PASS" "PermitRootLogin set to no"
else
    log_check "CIS-5.2.10" "Ensure SSH PermitRootLogin is disabled" "FAIL" "PermitRootLogin is not set to no"
fi

# Check 2: IP Forwarding Disabled
IP_FWD=$(sysctl -n net.ipv4.ip_forward 2>/dev/null || echo "1")
if [ "$IP_FWD" -eq 0 ]; then
    log_check "CIS-3.1.1" "Ensure IPv4 packet forwarding is disabled" "PASS" "net.ipv4.ip_forward is 0"
else
    log_check "CIS-3.1.1" "Ensure IPv4 packet forwarding is disabled" "FAIL" "net.ipv4.ip_forward is enabled"
fi

# Check 3: ICMP Redirects Ignored
SEND_REDIR=$(sysctl -n net.ipv4.conf.all.send_redirects 2>/dev/null || echo "1")
if [ "$SEND_REDIR" -eq 0 ]; then
    log_check "CIS-3.2.1" "Ensure packet redirect sending is disabled" "PASS" "net.ipv4.conf.all.send_redirects is 0"
else
    log_check "CIS-3.2.1" "Ensure packet redirect sending is disabled" "FAIL" "send_redirects is enabled"
fi

# Check 4: Auditd Service Enabled and Running
if systemctl is-active --quiet auditd 2>/dev/null; then
    log_check "CIS-4.1.1.2" "Ensure auditd service is enabled" "PASS" "auditd is active"
else
    log_check "CIS-4.1.1.2" "Ensure auditd service is enabled" "FAIL" "auditd is inactive or not installed"
fi

# Check 5: /etc/shadow Permissions
SHADOW_PERMS=$(stat -c "%a" /etc/shadow 2>/dev/null || echo "000")
if [ "$SHADOW_PERMS" = "640" ] || [ "$SHADOW_PERMS" = "600" ] || [ "$SHADOW_PERMS" = "000" ]; then
    log_check "CIS-6.1.3" "Ensure permissions on /etc/shadow are configured" "PASS" "/etc/shadow permissions are $SHADOW_PERMS"
else
    log_check "CIS-6.1.3" "Ensure permissions on /etc/shadow are configured" "FAIL" "/etc/shadow permissions are too open: $SHADOW_PERMS"
fi

echo "]" >> "$RESULTS_FILE"
echo "=== Audit Completed! Output written to $RESULTS_FILE ==="
