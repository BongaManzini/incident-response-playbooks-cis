# Enterprise Incident Response Playbooks & CIS Hardening

Standard Operating Procedures (SOPs) and automated hardening frameworks aligned with **NIST SP 800-61 Rev 2** and **CIS Benchmarks**.

---

## Directory Index

```
Incident-Response-Playbooks/
├── Playbook-01-Enterprise-Ransomware-Containment.md              # Double-extortion ransomware response
├── Playbook-02-Business-Email-Compromise-and-O365-Account-Takeover.md # AiTM phishing & M365 session kill
├── Playbook-03-Supply-Chain-and-CI-CD-Poisoning.md               # GitHub Actions & dependency poisoning
├── CIS-Hardening-Automation/                                     # Automated Level-2 Linux compliance
│   ├── cis_level2_auditor.sh                                     # Host inspection script
│   ├── cis_benchmark_reporter.py                                 # Scorecard generator
│   └── README.md
└── README.md                                                     # This index
```

---

## Response Metrics Tracked

- **Mean Time to Detect (MTTD):** Monitored through automated Sigma and SIEM alerting rules.
- **Mean Time to Acknowledge (MTTA):** Enforced via automated SOAR alert queuing.
- **Mean Time to Contain (MTTC):** Accelerated using pre-scripted PowerShell/Bash quarantine commands.
