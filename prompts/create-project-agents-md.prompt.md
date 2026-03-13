---
description: 'Generate an optimized AGENTS.md for a target project based on its tech stack and installed skills. Uses retrieval-led reasoning pattern from Vercel eval findings.'
---

# Generate Project AGENTS.md

Goal: Create an AGENTS.md file optimized for AI agent performance using the retrieval-led reasoning pattern (passive context > on-demand skill invocation).

## Why this matters
Vercel's eval research shows AGENTS.md with a compressed knowledge index achieves 100% pass rate vs. 53% for skills alone. The key: agents always have context available without needing to decide to load it.

## Steps

1) **Analyze the target project:**
   - Detect language/framework from build files (pom.xml, build.gradle, package.json, requirements.txt)
   - Detect test framework from dependencies (JUnit, Playwright, pytest, Selenium)
   - Detect CI/CD from pipeline files (ADO YAML, GitHub Actions)
   - List installed skills in `.github/skills/`
   - List installed prompts in `.github/prompts/`
   - List installed instructions in `.github/instructions/`

2) **Generate AGENTS.md using the template pattern:**
   - Start with: `IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning`
   - Include a compressed skill index (table format) pointing to each installed SKILL.md
   - Include a prompt index pointing to each installed prompt
   - Include a decision tree for common tasks
   - Include cross-cutting rules (provenance, redaction, evidence, security)
   - Include project-specific setup commands
   - Include model tier recommendations

3) **Optimize for context size:**
   - Target under 10KB for the AGENTS.md file
   - Use pipe-delimited tables, not verbose markdown
   - Include paths to SKILL.md files for deep reads, not full skill content
   - Compress the decision tree to essential branches only

4) **Include only relevant content:**
   - If project is Java-only, omit Playwright/Python references
   - If project has no Swing, omit Swing skill references
   - Tailor setup commands to the actual build tool

## Required output
- `AGENTS.md` in the project root
- File size under 10KB
- Contains: retrieval instruction, skill index, prompt index, decision tree, cross-cutting rules, setup commands

## Validation
- AGENTS.md exists and is under 10KB
- All installed skills are referenced with correct paths
- Retrieval instruction is present at the top
- No customer-specific secrets or internal URLs
