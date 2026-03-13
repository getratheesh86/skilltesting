<#
.SYNOPSIS
    Install AI Testing Framework skills, agents, prompts, and instructions into a target project.
.DESCRIPTION
    Copies all resources from this repo into the target project's .github/ directory.
    Supports selective installation by resource type.
.PARAMETER TargetProject
    Path to the target project root directory.
.PARAMETER Skills
    Install skills (default: true)
.PARAMETER Agents
    Install agents (default: true)
.PARAMETER Prompts
    Install prompts (default: true)
.PARAMETER Instructions
    Install instructions (default: true)
.PARAMETER Schemas
    Install schemas (default: true)
.EXAMPLE
    .\install.ps1 -TargetProject C:\myproject
    .\install.ps1 -TargetProject C:\myproject -Skills -Prompts  # Skills + prompts only
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetProject,

    [switch]$SkillsOnly,
    [switch]$NoSkills,
    [switch]$NoAgents,
    [switch]$NoPrompts,
    [switch]$NoInstructions,
    [switch]$NoSchemas
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$targetGithub = Join-Path $TargetProject ".github"

if (-not (Test-Path $TargetProject)) {
    Write-Error "Target project not found: $TargetProject"
    exit 1
}

Write-Host "Installing AI Testing Framework resources" -ForegroundColor Cyan
Write-Host "  Source: $repoRoot" -ForegroundColor Gray
Write-Host "  Target: $TargetProject" -ForegroundColor Gray
Write-Host ""

$installed = 0

# Skills
if (-not $NoSkills) {
    $skillsTarget = Join-Path $targetGithub "skills"
    $skillsSource = Join-Path $repoRoot "skills"
    if (Test-Path $skillsSource) {
        New-Item -ItemType Directory -Path $skillsTarget -Force | Out-Null
        Get-ChildItem $skillsSource -Directory | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $skillsTarget $_.Name) -Recurse -Force
            $installed++
        }
        $count = (Get-ChildItem $skillsSource -Directory).Count
        Write-Host "  Skills: $count installed" -ForegroundColor Green
    }
}

if ($SkillsOnly) {
    Write-Host "`nInstalled $installed resources (skills only)" -ForegroundColor Cyan
    exit 0
}

# Agents
if (-not $NoAgents) {
    $agentsTarget = Join-Path $targetGithub "agents"
    $agentsSource = Join-Path $repoRoot "agents"
    if (Test-Path $agentsSource) {
        New-Item -ItemType Directory -Path $agentsTarget -Force | Out-Null
        Copy-Item "$agentsSource\*" $agentsTarget -Force
        $count = (Get-ChildItem $agentsSource -File).Count
        $installed += $count
        Write-Host "  Agents: $count installed" -ForegroundColor Green
    }
}

# Prompts
if (-not $NoPrompts) {
    $promptsTarget = Join-Path $targetGithub "prompts"
    $promptsSource = Join-Path $repoRoot "prompts"
    if (Test-Path $promptsSource) {
        New-Item -ItemType Directory -Path $promptsTarget -Force | Out-Null
        Copy-Item "$promptsSource\*" $promptsTarget -Force
        $count = (Get-ChildItem $promptsSource -File).Count
        $installed += $count
        Write-Host "  Prompts: $count installed" -ForegroundColor Green
    }
}

# Instructions
if (-not $NoInstructions) {
    $instrTarget = Join-Path $targetGithub "instructions"
    $instrSource = Join-Path $repoRoot "instructions"
    if (Test-Path $instrSource) {
        New-Item -ItemType Directory -Path $instrTarget -Force | Out-Null
        Copy-Item "$instrSource\*" $instrTarget -Force
        $count = (Get-ChildItem $instrSource -File).Count
        $installed += $count
        Write-Host "  Instructions: $count installed" -ForegroundColor Green
    }
}

# Schemas
if (-not $NoSchemas) {
    $schemasTarget = Join-Path $TargetProject "schemas"
    $schemasSource = Join-Path $repoRoot "schemas"
    if (Test-Path $schemasSource) {
        New-Item -ItemType Directory -Path $schemasTarget -Force | Out-Null
        Copy-Item "$schemasSource\*" $schemasTarget -Force
        $count = (Get-ChildItem $schemasSource -File).Count
        $installed += $count
        Write-Host "  Schemas: $count installed" -ForegroundColor Green
    }
}

Write-Host "`nInstalled $installed resources total" -ForegroundColor Cyan

# Generate project AGENTS.md from template
$templatePath = Join-Path $repoRoot "scripts\AGENTS.md.template"
$agentsMdTarget = Join-Path $TargetProject "AGENTS.md"
if ((Test-Path $templatePath) -and -not (Test-Path $agentsMdTarget)) {
    Copy-Item $templatePath $agentsMdTarget -Force
    Write-Host "  AGENTS.md: generated from template" -ForegroundColor Green
    Write-Host "    Edit $agentsMdTarget to fill in project-specific details" -ForegroundColor Gray
} elseif (Test-Path $agentsMdTarget) {
    Write-Host "  AGENTS.md: already exists (not overwritten)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Edit AGENTS.md — replace {{PLACEHOLDERS}} with project details" -ForegroundColor Gray
Write-Host "  2. Remove instructions that don't match your tech stack" -ForegroundColor Gray
Write-Host "  3. Run the context-ingestion prompt to onboard your first target" -ForegroundColor Gray
Write-Host "  4. Use create-project-agents-md prompt for an AI-optimized AGENTS.md" -ForegroundColor Gray
