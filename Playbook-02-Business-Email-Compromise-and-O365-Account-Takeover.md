# Incident Response Playbook 02: Business Email Compromise (BEC) & M365 Takeover

**Target Environment:** Microsoft 365, Azure Active Directory, Exchange Online  
**Threat Vector:** Phishing, AiTM (Adversary-in-the-Middle) Session Hijacking, Malicious Mailbox Forwarding Rules

---

## 1. Triage & Detection Indicators

- **Impossible Travel Alert:** User logs in from Johannesburg and Frankfurt within 15 minutes.
- **MFA Fatigue / Number Matching Bypass:** Multiple denied push notifications followed by single approval.
- **Anomalous Mailbox Rule Creation:** Inbox rules configured to automatically delete incoming emails containing keywords: `invoice`, `wire`, `banking`, `payment`, `statement`, or forwarding emails to external addresses.

---

## 2. Immediate Containment Workflow (PowerShell)

### Step 1: Revoke All Active OAuth Refresh Tokens
```powershell
# Invalidate all active sessions across web, mobile, and desktop
Revoke-AzureADUserAllRefreshToken -ObjectId "user@corp.internal"
```

### Step 2: Disable User Account
```powershell
Set-AzureADUser -ObjectId "user@corp.internal" -AccountEnabled $false
```

### Step 3: Audit & Delete Malicious Inbox Rules
```powershell
# Connect to Exchange Online
Connect-ExchangeOnline

# Enumerate all inbox rules
Get-InboxRule -Mailbox "user@corp.internal" | Format-Table Name, Description, ForwardTo, RedirectTo, MoveToFolder

# Delete malicious rule
Remove-InboxRule -Mailbox "user@corp.internal" -Identity "AutoArchiveInvoice" -Confirm:$false
```

### Step 4: Audit OAuth Consent Applications (Enterprise Apps)
Adversaries often grant permissions to malicious multi-tenant Azure applications (e.g., `Mail.ReadWrite`, `Mail.Send`) allowing persistent access even after password reset:
```powershell
# Enumerate app permissions granted on behalf of user
Get-AzureADUserOAuth2PermissionGrant -ObjectId "user@corp.internal"
```

---

## 3. Post-Incident Remediation

1. Enforce **FIDO2 / WebAuthn Hardware Security Keys** for all finance and executive staff to eliminate AiTM proxy phishing.
2. Disable external email forwarding tenant-wide via **Anti-Spam Outbound Policy** in Microsoft Defender for Office 365.
