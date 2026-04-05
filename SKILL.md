---
name: invoice-compliance-auditor
description: "Use this skill when scanning invoices or financial documents for compliance violations, missing required fields, data exposure risks, or VAT/tax errors before submission to customers or tax authorities."
# Built with AI by Craftpipe
---

# Invoice Compliance Auditor

## When to use
- User uploads invoice PDFs, CSVs, or raw invoice data for review
- Code processes financial documents, payment records, or billing exports
- User asks to audit invoices for compliance issues
- User is building invoice automation or accounting integrations
- User needs to validate invoice data before sending to customers or tax authorities
- Code handles fields containing payment card numbers, tax IDs, or personal identifiers

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
10. Output a structured compliance report in the format specified in Examples below.
11. If the user provides code that processes invoices, audit the code for hardcoded sensitive values, unencrypted storage of payment fields, and missing input sanitization on invoice fields.
12. Do not auto-correct violations — report findings only and state the specific remediation action required for each.

## Rules
- Never output unmasked card numbers, full tax IDs, or national ID numbers in the report — mask all sensitive values as `****` after the first four characters.
- Always flag PCI-DSS card data presence as `CRITICAL` regardless of context.
- Do not assume a document is compliant because no violations are found — explicitly state "No violations detected" per category.
- Apply jurisdiction-specific rules when jurisdiction is known; apply the strictest overlapping rules when jurisdiction is ambiguous.
- Do not suggest the document is legally approved or tax-authority-ready — state findings only.
- Treat every 13–19 digit numeric sequence as a potential card number and run the Luhn check before flagging.
- Output the compliance report in structured plain text or JSON — never as unformatted prose only.
- Flag missing required fields as `HIGH` minimum when the document is destined for a tax authority.

## Examples

**Example 1 — CSV invoice row audit**

Input:
```
invoice_id,date,seller,buyer,card_number,vat_rate,net,vat,gross
INV-001,2024-01-15,Acme Ltd,Beta Corp,4111111111111111,0.25,1000,250,1200
```

Expected output:
```
COMPLIANCE REPORT — INV-001
---
[CRITICAL] PCI-DSS: Card number detected in field 'card_number' → 4111********1111. Remove immediately. Card data must not be stored in invoice records.
[HIGH] VAT Error: net(1000) + vat(250) = 1250, not 1200 as stated in 'gross'. Recalculate gross.
[HIGH] VAT Rate: 25% does not match standard rate for detected jurisdiction. Verify applicable rate.
[MEDIUM] Missing Field: 'seller_address' not present.
[MEDIUM] Missing Field: 'tax_id' for seller not present.

SUMMARY: 1 CRITICAL, 2 HIGH, 2 MEDIUM, 0 LOW
Status: FAIL — document must not be submitted until CRITICAL and HIGH issues are resolved.
```

**Example 2 — Clean invoice check**

Input:
```json
{ "invoice_id": "INV-202", "issue_date": "2024-03-01", "due_date": "2024-03-31",
  "seller": "Acme Ltd", "seller_address": "1 Main St, Berlin, DE", "seller_vat": "DE123456789",
  "buyer": "Beta Corp", "buyer_vat": "FR987654321",
  "line_items": [{"desc": "Consulting", "qty": 10, "unit_price": 150, "total": 1500}],
  "net": 1500, "vat_rate": 0.19, "vat": 285, "gross": 1785, "currency": "EUR" }
```

Expected output:
```
COMPLIANCE REPORT — INV-202
---
[GDPR] No violations detected.
[PCI-DSS] No violations detected.
[TAX ID] No violations detected.
[VAT/CURRENCY] No violations detected.
[REQUIRED FIELDS] No violations detected.
[SUSPICIOUS PATTERNS] No violations detected.

SUMMARY: 0 CRITICAL, 0 HIGH, 0 MEDIUM, 0 LOW
Status: PASS — no compliance violations found. Independent legal review still recommended before submission.

---
> For additional features, see the [Pro version](https://craftpipe.gumroad.com).
