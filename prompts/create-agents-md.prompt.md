---
description: 'Generate a comprehensive AGENTS.md file for a target project following the established template pattern'
---

# Create AGENTS.md — Project Documentation for AI Agents

You are generating an AGENTS.md file that helps AI agents understand and work effectively within a target project.

## Inputs to request (if not provided)

- Target project root path
- Project name and brief description
- Primary languages and frameworks
- Key workflows (build, test, deploy)

## Steps

1. Analyze the repository structure — directories, key files, config files.
2. Identify setup commands from package managers, build tools, and scripts.
3. Catalog naming conventions for files, directories, and artifacts.
4. Inventory installed skills, agents, prompts, and instructions.
5. Document terminal rules and common pitfalls for AI agents.

## Required sections

| Section | Content |
|---------|---------|
| **Project Overview** | Brief description of what the project does |
| **Repository Structure** | Directory tree with annotations |
| **Setup Commands** | How to install dependencies and configure the environment |
| **Development Workflow** | How to build, test, run, and deploy |
| **Naming Conventions** | File and directory naming patterns |
| **Skills Reference** | Table of installed skills and their purposes |
| **Terminal Rules** | Critical rules for AI agents using terminals |
| **Code Review Checklist** | Pre-commit verification steps |

## Output

- `AGENTS.md` at the project root

## Rules

- Keep content factual — only document what exists in the repo
- Use tables for structured data (skills, naming conventions)
- Include concrete command examples, not abstract descriptions
- Flag any assumptions made during analysis for human review
