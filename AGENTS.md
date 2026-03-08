# Repository Guidelines

## Project Structure & Module Organization
This repository is an Obsidian knowledge vault organized for **Zettelkasten + PARA** workflows.

- `00 Inbox` to `04 MOCs`: knowledge capture, refinement, permanent notes, and maps of content.
- `10 Projects`, `11 Areas`, `12 Resources`, `13 Archive`: PARA execution and lifecycle management.
- `14 Templates`: canonical note templates (Inbox, Literature, Permanent, Project, ADR, Debug).
- `15 Attachments/inbox`: default attachment drop location.
- `.obsidian/`: workspace and plugin configuration. Edit carefully and keep changes minimal.

## Operational Workflow (Current)
- Capture first in `00 Inbox`, then triage to one target: Fleeting/Literature/Permanent/Project/Resource.
- Keep Inbox notes lightweight; a single concrete next action is enough.
- When triaged, mark `status` clearly (for example: `triage` -> `routed`) and leave a link to the promoted note.
- For projects, default to **one note file in** `10 Projects/Active`.
- Create a per-project folder only when the project accumulates many related files (meeting notes, attachments, references).

## Build, Test, and Development Commands
There is no build/test runtime for this repository (Markdown content only).
Use lightweight checks before submitting changes:

- `rg --files` — quick file inventory.
- `find . -maxdepth 2 -type d | sort` — verify folder layout.
- `sed -n '1,120p' README.md` — spot-check rendered structure.

If `markdownlint` is available locally, run it on changed docs.

## Coding Style & Naming Conventions
- Write content in Markdown with clear headings and short sections.
- Prefer concise, actionable language over long prose.
- File/folder naming patterns:
  - Zettelkasten folders keep numeric prefixes (`00`-`04`).
  - PARA folders keep numeric prefixes (`10`-`13`).
  - Templates use ordered names like `03 Permanent Note Template.md`.
- For note files, use either descriptive Korean/English titles or timestamp-prefixed titles when chronological ordering is needed.
- Preserve the language style of each document (English for operations docs like `AGENTS.md`, Korean-first for user-facing vault guide in `README.md`).

## Testing Guidelines
- Verify internal links (`[[...]]`) for changed notes.
- Ensure template fields and frontmatter keys stay consistent across related templates.
- For structural changes, confirm all expected directories still exist and attachment/template paths in `.obsidian/app.json` and `.obsidian/templates.json` remain valid.
- If you update guidance docs, verify examples still match existing template filenames under `14 Templates/`.

## Commit & Pull Request Guidelines
No reliable Git history is available in this workspace, so use this standard:

- Commit format: `type(scope): summary` (e.g., `docs(templates): refine permanent note template`).
- Keep commits focused (structure, templates, or docs; avoid mixing).
- PRs should include:
  - What changed and why
  - Affected paths (e.g., `14 Templates/`, `README.md`)
  - Screenshots only if Obsidian UI behavior is relevant
