$ErrorActionPreference = "Stop"

$inputText = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputText)) {
  exit 0
}

try {
  $payload = $inputText | ConvertFrom-Json
} catch {
  Write-Output '{"systemMessage":"Secret scan skipped: hook input was not valid JSON."}'
  exit 0
}

function Get-Strings($value) {
  if ($null -eq $value) { return }
  if ($value -is [string]) { $value; return }
  if ($value -is [System.Collections.IEnumerable] -and $value -isnot [string]) {
    foreach ($item in $value) { Get-Strings $item }
    return
  }
  foreach ($property in $value.PSObject.Properties) { Get-Strings $property.Value }
}

$text = (Get-Strings $payload) -join "`n"
$patterns = @(
  '(?i)-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----',
  '(?i)\bAKIA[0-9A-Z]{16}\b',
  '(?i)\bgh[pousr]_[A-Za-z0-9_]{20,}\b',
  '(?i)\bsk-[A-Za-z0-9]{20,}\b',
  '(?i)\b(?:xox[baprs])-[A-Za-z0-9-]{20,}\b',
  '(?i)\b(?:password|passwd|secret|api[_-]?key|access[_-]?token|auth[_-]?token|private[_-]?key)\s*[:=]\s*["'']?[A-Za-z0-9_\-/+=.]{12,}',
  '(?i)\bBearer\s+[A-Za-z0-9._\-]{20,}'
)

foreach ($pattern in $patterns) {
  if ($text -match $pattern) {
    $reason = "Potential secret detected in tool input (pattern: $pattern). Review the change and remove credentials before continuing."
    $result = @{ hookSpecificOutput = @{ hookEventName = "PreToolUse"; permissionDecision = "deny"; permissionDecisionReason = $reason } } | ConvertTo-Json -Compress
    Write-Output $result
    exit 0
  }
}

exit 0