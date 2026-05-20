# Install Drew's dev crew into %USERPROFILE%\.claude\
# Copies agent files (symlinks require Developer Mode on Windows).
# Skill directories use junctions, which work without admin or Developer Mode.
# Re-run this script after pulling updates to pick up changes.
#
# Usage: .\install.ps1
# Requires: PowerShell 5.1+ (built into Windows 10/11)

$ErrorActionPreference = "Stop"

$CrewDir = $PSScriptRoot
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "Installing crew from: $CrewDir"
Write-Host "Installing to:        $ClaudeDir"
Write-Host ""

# Ensure target directories exist
$null = New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir "agents")
$null = New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir "skills")

# --- CLAUDE.md ---
$claudeMdSrc = Join-Path $CrewDir "CLAUDE.md"
$claudeMdDst = Join-Path $ClaudeDir "CLAUDE.md"

if (Test-Path $claudeMdDst) {
    $existing = Get-Item $claudeMdDst
    # Check if it was placed by a previous run of this script (marker comment at top)
    $content = Get-Content $claudeMdDst -First 1 -ErrorAction SilentlyContinue
    if (-not ($content -match "Drew's Dev Crew")) {
        $backup = "$claudeMdDst.bak"
        Write-Host "WARNING: $claudeMdDst exists and looks custom. Backing up to CLAUDE.md.bak"
        Copy-Item $claudeMdDst $backup -Force
    }
}
Copy-Item $claudeMdSrc $claudeMdDst -Force
Write-Host "✓ CLAUDE.md"

# --- Agents (copied, not symlinked) ---
$agentSrc = Join-Path $CrewDir "agents"
$agentDst = Join-Path $ClaudeDir "agents"
$count = 0

Get-ChildItem -Path $agentSrc -Filter "*.md" | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $agentDst $_.Name) -Force
    $count++
}
Write-Host "✓ $count agents (copied)"

# --- Skills (directory junctions — no admin required) ---
$skillSrc = Join-Path $CrewDir "skills"
$skillDst = Join-Path $ClaudeDir "skills"
$count = 0

Get-ChildItem -Path $skillSrc -Directory | ForEach-Object {
    $name = $_.Name
    $target = Join-Path $skillDst $name
    $source = $_.FullName

    # Remove existing junction or directory before recreating
    if (Test-Path $target) {
        $item = Get-Item $target -Force
        # Junctions report as ReparsePoint
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            $item.Delete()
        } else {
            Write-Host "WARNING: $target is a real directory, skipping"
            return
        }
    }

    # Create junction (works without admin on Windows)
    $null = cmd /c "mklink /J `"$target`" `"$source`"" 2>&1
    $count++
}
Write-Host "✓ $count skills (junctions)"

Write-Host ""
Write-Host "Crew installed. Open a new Claude Code session to pick up the changes."
Write-Host ""
Write-Host "NOTE: Agent files were copied, not linked. Re-run install.ps1 after"
Write-Host "      pulling updates from the repo to pick up any changes."
