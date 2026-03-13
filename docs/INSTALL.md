# Installation Guide

## Prerequisites

- Git access to this repository
- PowerShell 7+ (for install script) or manual file copy
- VS Code with GitHub Copilot (for skills/agents/prompts/instructions)

## Installation Methods

### Method 1: Full install via script (recommended)

Copies all resources into your project's `.github/` directory:

```powershell
# Clone the skills repo
git clone <repo-url> --depth 1 /tmp/skills-repo

# Install into your project
pwsh /tmp/skills-repo/scripts/install.ps1 -TargetProject /path/to/your/project

# Clean up
rm -rf /tmp/skills-repo
```

The install script supports selective installation:

```powershell
# Skills only (no agents/prompts/instructions)
pwsh scripts/install.ps1 -TargetProject /path/to/project -SkillsOnly

# Everything except schemas
pwsh scripts/install.ps1 -TargetProject /path/to/project -NoSchemas

# Skip instructions (you have your own)
pwsh scripts/install.ps1 -TargetProject /path/to/project -NoInstructions
```

### Method 2: npx skills (skills only)

```bash
# Project-level install
npx skills add <repo-url>

# Global install (all projects on this machine)
npx skills add <repo-url> -g -a github-copilot
```

> **Limitation:** `npx skills` only installs SKILL.md files. Agents, prompts, and instructions require Method 1 or manual copy.

### Method 3: Git submodule (version-controlled)

```bash
cd your-project
git submodule add <repo-url> .github/shared-skills
```

Then reference skills from your project's configuration. This approach lets you pin a specific version and update centrally.

### Method 4: Manual copy

```bash
git clone <repo-url> --depth 1 /tmp/skills-repo

# Copy what you need
cp -r /tmp/skills-repo/skills       your-project/.github/skills/
cp -r /tmp/skills-repo/agents       your-project/.github/agents/
cp -r /tmp/skills-repo/prompts      your-project/.github/prompts/
cp -r /tmp/skills-repo/instructions your-project/.github/instructions/
cp -r /tmp/skills-repo/schemas      your-project/schemas/

rm -rf /tmp/skills-repo
```

## Installation Levels

### Global (developer machine)

Install universal guardrails once — they apply to every project:

| Resource | Install globally? | Rationale |
|----------|:-:|-----------|
| `owasp-security` skill | Yes | Security applies everywhere |
| `code-review.instructions.md` | Yes | Org-wide review standards |
| `security-owasp.instructions.md` | Yes | Security baseline |
| `docker.instructions.md` | Yes | Container best practices |

```bash
npx skills add <repo-url> --skill owasp-security -g -a github-copilot
```

### Project (per repo)

Install domain-specific resources into each project:

| Resource | Install per-project? | Rationale |
|----------|:-:|-----------|
| All generation skills | Yes | Bound to project's tech stack |
| All prompts | Yes | Task workflows are project-specific |
| Language-specific instructions | Yes | Match project's language |
| `orchestration-cli` | Yes | Pipeline config varies per project |

```powershell
pwsh scripts/install.ps1 -TargetProject /path/to/your/project
```

## Post-Installation

### 1. Remove irrelevant instructions

If your project is Java-only, remove:
- `playwright-typescript.instructions.md`
- `python.instructions.md`

If your project doesn't use Swing:
- `java-swing.instructions.md`

### 2. Onboard your first target

```
# In VS Code Copilot Chat, use the context-ingestion prompt:
@workspace /context-ingestion Target: my-api-name
```

### 3. Verify skills are loaded

In VS Code, open Copilot Chat and check that skills appear in the skill picker. If using `npx skills`, run:

```bash
npx skills list        # Project-level
npx skills list -g     # Global
```

## Updating

### From git

```bash
cd .github/shared-skills   # If using submodule
git pull origin main
```

### From npx

```bash
npx skills check    # Check for updates
npx skills update   # Apply updates
```

### From install script

Re-run the install script — it overwrites existing files:

```powershell
pwsh /path/to/skills-repo/scripts/install.ps1 -TargetProject .
```

## Troubleshooting

### Skills not appearing in Copilot

1. Ensure skills are in `.github/skills/` (project) or `~/.copilot/skills/` (global)
2. Reload VS Code window
3. Verify SKILL.md has valid `name` and `description` in frontmatter

### Instructions not applying

1. Check the `applyTo` glob pattern matches your file paths
2. Instruction files must end with `.instructions.md`
3. Files must be in `.github/instructions/`

### Prompts not available

1. Enable `"chat.promptFiles": true` in VS Code settings
2. Prompt files must be in `.github/prompts/`
3. Files must end with `.prompt.md`
