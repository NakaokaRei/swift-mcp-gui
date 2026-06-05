# AGENTS.md

This repository keeps its shared agent guidance in `CLAUDE.md`.

Codex agents should read and follow `CLAUDE.md` for build commands,
architecture notes, dependencies, and development workflow.

Project skills are authored once for both agent runtimes:

- Shared skills: `.claude/skills/`

Codex command entrypoints live in `.agents/skills/`, but each `SKILL.md` should
only point to the matching shared skill under `.claude/skills/`. Do not duplicate
the full skill workflow in `.agents/skills/`.
