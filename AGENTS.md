---
created: 2026-03-15 03:27:29
---
# Repository Guidelines

## Project Structure & Module Organization
This repository is an Obsidian vault for personal knowledge management.

- `README.md`: repository overview document.
- `VAULT_RULES.md`: detailed vault policy document.
- Root folders: `00 Inbox`, `01 Permanent`, `02 MOCs`, `10 Projects`, `11 Areas`, `12 Resources`, `13 Archive`.
- `14 Templates`: note templates used by Obsidian and AI-assisted work.
- `attachments/`: binary assets organized under `diagrams/`, `screenshots/`, and `files/`.
- `.obsidian/`: local Obsidian settings (not tracked).

Use numbered folder names to preserve sort order and intent.

## Build, Test, and Development Commands
There is no software build or CI pipeline. Use lightweight checks before committing:

- `git status --short`: confirm only intended files changed.
- `git diff -- README.md VAULT_RULES.md AGENTS.md AGENT_KOR.md '14 Templates'`: review rule and template changes.
- `find . -maxdepth 1 -type d | sort`: verify the root vault structure.
- `find '00 Inbox' '01 Permanent' '02 MOCs' '10 Projects' '11 Areas' '12 Resources' '13 Archive' -type f -name '*.md' | sed 's#.*/##' | sort | uniq -d`: detect duplicate note filenames.
- `rg "TODO|FIXME" README.md VAULT_RULES.md AGENTS.md AGENT_KOR.md '14 Templates'`: catch unfinished placeholders.

If you use Obsidian locally, validate internal links and graph readability before opening a PR.

## Execution Rules
Follow `VAULT_RULES.md` for vault policy. This file only adds execution-specific guardrails.

- Do not move note files unless the user explicitly requests it.
- The user decides note location. AI may recommend a better location.
- Attachments such as screenshots and files may be moved into `attachments/` when needed.
- Do not rewrite the user's text except fatal typo fixes.
- Do not move content across existing `##` sections.
- Keep Markdown edits limited to readability improvements.
- Put code, commands, config, and logs in fenced code blocks.
- Use a single `related notes` section for note links.
- Keep the Obsidian graph readable and avoid tangled cross-links.
- Keep only minimal required frontmatter in templates such as `created` and a note-type tag, and remove obsolete metadata when updating templates.

## Testing Guidelines
Testing is content validation:

- Ensure internal links resolve in Obsidian.
- Ensure related-note links are coherent and do not create obvious graph tangles.
- Ensure duplicate files or duplicate note names are surfaced.
- Ensure misplaced notes are recommended, not moved, unless the user asked for the move.
- Ensure attachments point to files under `attachments/`.
- Ensure templates keep required minimal metadata and do not reintroduce unnecessary metadata.

For large edits, manually inspect a few notes across `Permanent`, `Projects`, `Resources`, and `MOCs`.

## Commit & Pull Request Guidelines
Use `notes: sync` for every commit message.

- Commit message: `notes: sync`
- Do not vary the scope or summary.
- In PRs, include purpose, changed paths, migration notes, and screenshots only when Obsidian UI behavior matters.

Call out any backlink or graph-structure risk explicitly.

## Bilingual Guide Sync Rule
Keep contributor guides synchronized at the repository root:

- When `AGENTS.md` is updated, update `AGENT_KOR.md` in the same change.
- When `AGENT_KOR.md` is updated, reflect the same policy changes in `AGENTS.md`.
- For pull requests touching either file, include both files unless the change is explicitly translation-only.
