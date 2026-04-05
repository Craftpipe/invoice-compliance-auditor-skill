#!/usr/bin/env bash

set -e

usage() {
    cat << EOF
Usage: invoice-auditor [OPTIONS] <invoice_file>

Invoice Compliance Auditor - Helper Script
Scans invoices for compliance violations and missing required fields.

OPTIONS:
    -h, --help              Show this help message
    -j, --jurisdiction      Set jurisdiction (US, EU, UK, etc.) - default: US
    -o, --output            Output format (text, json) - default: text
    -s, --strict            Enable strict mode (fail on warnings)

EXAMPLES:
    invoice-auditor invoice.pdf
    invoice-auditor -j EU -o json invoice.txt
    invoice-auditor --strict -j UK invoice.pdf

EOF
    exit 0
}

audit_invoice() {
    local file="$1"
    local jurisdiction="${2:-US}"
    local output_format="${3:-text}"
    local strict_mode="${4:-false}"
    
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file" >&2
        exit 1
    fi
    
    local issues=0
    local warnings=0
    
    # Check for required fields
    grep -qi "invoice.*number\|invoice.*id" "$file" || ((warnings++))
    grep -qi "date\|issued" "$file" || ((warnings++))
    grep -qi "amount\|total\|price" "$file" || ((warnings++))
    grep -qi "vendor\|supplier\|from" "$file" || ((warnings++))
    grep -qi "recipient\|bill.*to\|customer" "$file" || ((warnings++))
    
    # Check for PCI-DSS violations (credit card patterns)
    grep -qE '[0-9]{4}[[:space:]]*[0-9]{4}[[:space:]]*[0-9]{4}[[:space:]]*[0-9]{4}' "$file" && ((issues++))
    
    # Check for tax ID exposure
    grep -qiE 'ssn|tax.*id|ein|vat.*number' "$file" && grep -qE '[0-9]{3}-[0-9]{2}-[0-9]{4}|[0-9]{9}' "$file" && ((issues++))
    
    # Check for currency/VAT errors
    grep -qiE 'vat|tax' "$file" || ((warnings++))
    
    # Check for GDPR violations (personal data)
    grep -qiE 'email|phone|address|passport|id.*number' "$file" && ((warnings++))
    
    if [[ "$output_format" == "json" ]]; then
        echo "{\"file\":\"$file\",\"jurisdiction\":\"$jurisdiction\",\"issues\":$issues,\"warnings\":$warnings,\"status\":\"$([ $issues -eq 0 ] && echo 'PASS' || echo 'FAIL')\"}"
    else
        echo "Invoice Audit Report: $file"
        echo "Jurisdiction: $jurisdiction"
        echo "Critical Issues: $issues"
        echo "Warnings: $warnings"
        echo "Status: $([ $issues -eq 0 ] && echo 'PASS' || echo 'FAIL')"
    fi
    
    if [[ "$strict_mode" == "true" && $((issues + warnings)) -gt 0 ]]; then
        exit 1
    fi
    
    [ $issues -eq 0 ] || exit 1
}

[[ $# -eq 0 ]] && usage

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        -j|--jurisdiction) jurisdiction="$2"; shift 2 ;;
        -o|--output) output_format="$2"; shift 2 ;;
        -s|--strict) strict_mode="true"; shift ;;
        *) invoice_file="$1"; shift ;;
    esac
done

[[ -z "$invoice_file" ]] && usage

audit_invoice "$invoice_file" "${jurisdiction:-US}" "${output_format:-text}" "${strict_mode:-false}"