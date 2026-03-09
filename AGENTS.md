# Repository Guidelines

## Project Structure & Module Organization
This repository is an Obsidian vault focused on personal knowledge management.

- `README.md`: source of truth for vault architecture (Zettelkasten + PARA), linking flow, and note-writing process.
- `OBSIDIAN_STYLE_GUIDE.md`: writing/style standard for naming, frontmatter, links, tags, and attachments.
- Root folders: `00 Inbox`, `01 Permanent`, `02 MOCs`, `10 Projects`, `11 Areas`, `12 Resources`, `13 Archive`.
- `attachments/`: binary assets organized under `diagrams/`, `screenshots/`, and `files/`.
- `.obsidian/`: local Obsidian app settings (not tracked).

Use numbered folder names to preserve sort order and intent (for example `00 Inbox`, `01 Permanent`, `10 Projects`).

## Build, Test, and Development Commands
There is no software build or CI test pipeline in this repository. Use lightweight checks before committing:

- `git status --short`: confirm only intended files changed.
- `git diff -- README.md OBSIDIAN_STYLE_GUIDE.md AGENTS.md AGENT_KOR.md`: review guideline and architecture edits.
- `find . -maxdepth 1 -type d | sort`: verify root vault structure.
- `rg "TODO|FIXME" README.md OBSIDIAN_STYLE_GUIDE.md AGENTS.md AGENT_KOR.md`: catch unfinished placeholders.

If you use Obsidian locally, validate links and navigation (especially MOCs and backlinks) before opening a PR.

## Coding Style & Naming Conventions
Write documentation in Markdown with short sections and clear headings.

- Use `#`, `##`, `###` hierarchies consistently.
- Prefer concise paragraphs and bullet lists over long prose.
- Keep vault folder names prefixed with two-digit ordering (`00`, `01`, ...).
- Keep note and folder names descriptive and stable; avoid frequent renames that break links.
- Follow `OBSIDIAN_STYLE_GUIDE.md` for note-level style (frontmatter, links, tag policy, and attachment handling).

## Testing Guidelines
Testing is content validation:

- Ensure internal links resolve in Obsidian graph/view.
- Ensure note structure follows the flow in `README.md`: `Inbox -> classify -> link -> reflect in MOC`.
- Ensure asset references point to files under `attachments/` and are linkable from notes.

For large edits, do a manual pass on sample notes across `Permanent`, `Projects`, and `Resources`.

## Commit & Pull Request Guidelines
Current history uses concise, scoped commit subjects (example: `init: second-brain`). Follow this style:

- Commit format: `<scope>: <summary>` (e.g., `structure: add attachments subfolders`).
- Keep commits focused on one conceptual change.
- In PRs, include: purpose, changed paths, migration/rename notes, and screenshots only when Obsidian UI behavior matters.

Link related issues/tasks when available and call out any backlink-breaking changes explicitly.

## Bilingual Guide Sync Rule
Keep contributor guides synchronized at the repository root:

- When `AGENTS.md` is updated, update `AGENT_KOR.md` in the same change.
- When `AGENT_KOR.md` is updated, reflect the same policy/content changes in `AGENTS.md`.
- For pull requests touching either file, include both files in the diff unless the change is explicitly marked as translation-only.
