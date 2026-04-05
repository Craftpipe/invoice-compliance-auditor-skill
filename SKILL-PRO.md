---
name: invoice-compliance-auditor-pro
description: "Use this skill when scanning invoices or financial documents for compliance violations, missing required fields, data exposure risks, or VAT/tax errors before submission to customers or tax authorities. PRO version adds structured compliance reports, custom rule enforcement, and deep scan mode for batch and code-level auditing."
# Built with AI by Craftpipe
---

# Invoice Compliance Auditor PRO

## When to use
- User uploads invoice PDFs, CSVs, or raw invoice data for review
- Code processes financial documents, payment records, or billing exports
- User asks to audit invoices for compliance issues
- User is building invoice automation or accounting integrations
- User needs to validate invoice data before sending to customers or tax authorities
- Code handles fields containing payment card numbers, tax IDs, or personal identifiers
- User provides a batch of invoices for bulk compliance review
- User defines custom compliance rules to enforce across all documents
- User requests a formal exportable compliance report

## Instructions
1. Parse the invoice input — accept PDF text extraction, CSV rows, JSON objects, or raw pasted text.
2. Identify the jurisdiction by detecting currency symbols, VAT numbers, country codes, or explicit user input. Default to flagging for multiple jurisdictions if ambiguous.
3. Check for GDPR violations: scan for full names combined with addresses or email addresses stored without necessity, unmasked national ID numbers, or excessive personal data fields not required for invoicing.
4. Check for PCI-DSS violations: detect any 13–19 digit sequences matching card number patterns (Luhn algorithm check), CVV/CVC fields, or full magnetic stripe data present in the document.
5. Check for tax ID mishandling: verify tax IDs match the expected format for the detected jurisdiction (e.g., EU VAT format `XX123456789`, US EIN format `XX-XXXXXXX`). Flag malformed or missing tax IDs.
6. Check for VAT/currency errors: confirm VAT rate matches the jurisdiction's current standard rate, verify net + VAT = gross arithmetic, and flag mismatched currency codes on line items vs. totals.
7. Check for missing required fields: validate presence of invoice number, issue date, due date, seller legal name, seller address, buyer legal name, line item descriptions, unit prices, totals, and applicable tax identifiers.
8. Detect suspicious patterns: flag duplicate invoice numbers, dates set more than 90 days in the past or future without explanation, round-number totals on every line item, and mismatched buyer/seller currency regions.
9. Assign a severity level to each finding: `CRITICAL` (data exposure, card data present), `HIGH` (missing tax ID, VAT miscalculation), `MEDIUM` (missing optional required fields, format errors), `LOW` (formatting inconsistencies, minor date anomalies).
10. If the user provides code that processes invoices, audit the code for hardcoded sensitive values, unencrypted storage of payment fields, and missing input sanitization on invoice fields.
11. Do not auto-correct violations — report findings only and state the specific remediation action required for each.

## PRO: Structured Compliance Report
12. After completing all checks, generate a full compliance report using this exact structure:

```
INVOICE COMPLIANCE REPORT
=========================
Document ID:        [invoice number or filename]
Audit Date:         [today's date]
Jurisdiction:       [detected or user-specified]
Overall Status:     PASS | FAIL | REVIEW REQUIRED

FINDINGS SUMMARY
----------------
CRITICAL:  [count]
HIGH:      [count]
MEDIUM:    [count]
LOW:       [count]

DETAILED FINDINGS
-----------------
[ID] | [Severity] | [Field/Section] | [Description] | [Remediation Action]

CUSTOM RULE RESULTS
-------------------
[Rule Name] | [Status: PASS/FAIL] | [Detail]

DEEP SCAN RESULTS
-----------------
[Finding Type] | [Location] | [Detail]

AUDITOR NOTES
-------------
[Any jurisdiction-specific guidance, edge cases, or follow-up actions required]
```

13. Set Overall Status to `FAIL` if any CRITICAL or HIGH findings exist. Set to `REVIEW REQUIRED` if only MEDIUM findings exist with no CRITICAL or HIGH. Set to `PASS` only when zero findings of any severity are present.
14. Number each finding sequentially as F-001, F-002, etc. across all severity levels.
15. When auditing a batch of multiple invoices, produce one individual report per invoice followed by a Batch Summary Report listing each document ID, its Overall Status, and total finding counts per severity level in a single consolidated table.

## PRO: Custom Rules
16. Before beginning any audit, check whether the user has provided custom rules. Accept custom rules in any of these formats: plain English statements, key-value pairs, or JSON rule objects.
17. Parse each custom rule and extract: the field or condition being checked, the expected value or pattern, and the action on failure (flag as CRITICAL, HIGH, MEDIUM, or LOW).
18. Apply every custom rule to every invoice in the audit scope. Report each custom rule result in the CUSTOM RULE RESULTS section of the compliance report, including the rule name, PASS or FAIL status, and the specific field value that caused a failure.
19. If a custom rule conflicts with a built-in compliance check, apply both independently and report both findings separately. Do not suppress either result.
20. If a custom rule is ambiguous or cannot be evaluated against the provided data, report it as `INDETERMINATE` with an explanation of what additional data is required to evaluate it.

## PRO: Deep Scan
21. When the user requests deep scan or when any CRITICAL finding is present, activate deep scan mode automatically.
22. Deep scan performs the following additional checks beyond the standard audit:
    - **Metadata extraction**: identify and report any document metadata fields (author, creation tool, modification timestamps) that contain personal identifiers or internal system paths.
    - **Cross-field consistency**: verify that seller tax ID, seller name, and seller address are internally consistent across all line items and header fields. Flag any discrepancy between header and footer values.
    - **Line-item anomaly detection**: calculate the statistical mean and standard deviation of all line-item amounts. Flag any line item whose amount exceeds three standard deviations from the mean as a potential anomaly requiring manual review.
    - **Duplicate detection across batch**: when multiple invoices are provided, compare invoice numbers, amounts, dates, and buyer-seller pairs across all documents. Flag any pair of invoices sharing two or more identical fields as a probable duplicate.
    - **Code-level deep scan**: when source code is provided, trace all invoice field values from input to storage and output. Flag any path where a sensitive field (card number, tax ID, national ID) is logged, serialized to plaintext, or passed to a third-party endpoint without explicit masking.
    - **Encoding and injection scan**: detect base64-encoded strings, URL-encoded sequences, or script injection patterns embedded in any invoice text field.
23. Report all deep scan findings in the DEEP SCAN RESULTS section with the finding type, the exact location (field name, line number, or document section), and a description of the risk.
24. Deep scan findings are assigned severity using the same scale as standard findings and are included in the FINDINGS SUMMARY counts.

## Rules
- Never output unmasked card numbers, CVV values, or national ID numbers in any report section — always mask to show only the last four digits with the format `****-****-****-XXXX`.
- Never auto-correct any violation — state the exact remediation action required for each finding.
- Apply all built-in checks before applying custom rules so that custom rule evaluation has access to the full parsed document structure.
- When jurisdiction cannot be determined, apply the strictest applicable standard across EU (GDPR, EU VAT Directive), US (IRS, PCI-DSS), and UK (HMRC Making Tax Digital) simultaneously and note the ambiguity in AUDITOR NOTES.
- Batch reports must process each invoice independently before generating the consolidated Batch Summary Report — do not merge findings across invoices during individual analysis.