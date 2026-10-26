# CIS Linux Benchmark Hardening & Automated Compliance Audit

Automated Bash & Python verification engine assessing Linux distributions against the **Center for Internet Security (CIS) Benchmark Level 2** controls.

---

## Capabilities & Automated Controls

- **Network Stack Hardening:** IPv4 packet forwarding, ICMP send/accept redirects, SYN cookies enforcement.
- **Service & Daemon Hardening:** SSH `PermitRootLogin`, auditd system monitoring daemon status.
- **Filesystem Permissions:** Sensitive file permissions (`/etc/shadow`, `/etc/passwd`, `/etc/gshadow`).

---

## Execution Instructions

```bash
# 1. Execute live host audit
sudo ./cis_level2_auditor.sh

# 2. Generate structured compliance scorecard
python3 cis_benchmark_reporter.py
```
