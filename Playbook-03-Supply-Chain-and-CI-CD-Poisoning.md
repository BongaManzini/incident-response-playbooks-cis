# Incident Response Playbook 03: Supply Chain & CI/CD Pipeline Poisoning

**Scope:** GitHub Actions, GitLab CI, Container Registries, npm/PyPI dependencies  
**Standard:** OpenSSF Scorecard, SLSA (Supply-chain Levels for Software Artifacts) Level 3  

---

## 1. Threat Scenarios Covered

1. **Dependency Confusion / Typosquatting:** Compromised external package uploaded with matching internal namespace.
2. **CI/CD Workflow Injection:** Malicious pull request modifying `.github/workflows/deploy.yml` to extract repository secrets (`AWS_SECRET_ACCESS_KEY`, `NPM_TOKEN`).
3. **Runner Compromise:** Self-hosted runner accessed by untrusted third-party code.

---

## 2. Containment Checklist

### 2.1 Credential Invalidation
- [ ] Rotate all GitHub / GitLab organization deployment tokens and machine users immediately.
- [ ] Revoke cloud IAM keys exposed in runner environment variables.

### 2.2 Pipeline Quarantine
- [ ] Temporarily freeze auto-deployment pipelines.
- [ ] Enforce pinned commit SHAs for all third-party GitHub Actions instead of mutable tags:
  ```yaml
  # Vulnerable: Mutable tag can be rewritten by adversary
  - uses: actions/checkout@v4

  # Secure: Cryptographically pinned SHA
  - uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
  ```

### 2.3 Software Bill of Materials (SBOM) & Attestation
Generate an SBOM for the affected image using `Syft` and verify signatures using `Cosign`:
```bash
# Generate SBOM
syft packages docker:registry.corp.internal/app:latest -o json > sbom.json

# Verify cryptographic signature
cosign verify --key cosign.pub registry.corp.internal/app:latest
```
