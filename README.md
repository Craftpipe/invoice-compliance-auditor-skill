# Invoice Compliance Auditor

Scans invoices and financial documents for compliance violations and generates detailed audit reports.

## Installation

### Claude Code
```bash
# Option 1: Manual installation
cp -r invoice-compliance-auditor ~/.claude/skills/

# Option 2: Plugin installation
claude plugin install https://github.com/craftpipe/invoice-compliance-auditor
```

### Cursor
```bash
# Option 1: Manual installation
cp -r invoice-compliance-auditor ~/.cursor/skills/

# Option 2: Via Cursor marketplace
# Search for "Invoice Compliance Auditor" in Cursor's plugin marketplace
```

### ClawHub/OpenClaw
```bash
# Option 1: Via marketplace
# Visit ClawHub marketplace and search for "Invoice Compliance Auditor"

# Option 2: Manual installation
git clone https://github.com/craftpipe/invoice-compliance-auditor
cp -r invoice-compliance-auditor ~/.claude/skills/
```

### Codex CLI
```bash
cp invoice-compliance-auditor/SKILL.md ~/.codex/skills/invoice-compliance-auditor/SKILL.md
```

## Usage

The skill automatically activates when you:
- Upload or paste invoice documents for analysis
- Request compliance checks on financial records
- Ask for audit reports on payment documentation

**What it does:**
- Detects data exposure risks (personally identifiable information, payment card details)
- Identifies missing required fields based on jurisdiction
- Validates currency formatting and VAT calculations
- Flags suspicious patterns and anomalies
- Generates comprehensive compliance reports with remediation guidance

## Examples

**Example 1: GDPR Violation Detection**
```
Input: Invoice containing customer SSN and full address
Output: ⚠️ GDPR Risk - Unnecessary PII exposure detected. Recommendation: Remove SSN, use customer ID instead.
```

**Example 2: Tax Compliance Check**
```
Input: EU invoice without VAT number
Output: ⚠️ Missing VAT ID for jurisdiction (Germany). Required field not found. Add tax registration number to comply with local regulations.
```

## Features

- ✅ Multi-jurisdiction compliance validation
- ✅ Real-time risk detection
- ✅ Automated field verification
- ✅ Pattern anomaly flagging
- ✅ Detailed audit trail generation

---

**Built with AI by Craftpipe**

Support: support@heijnesdigital.com
## ⭐ Pro Features

The Pro version includes:
- **compliance report**
- **custom rules**
- **deep scan**

**Get Pro** → [craftpipe.gumroad.com](https://craftpipe.gumroad.com) (€49)
