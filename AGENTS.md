# Repository Guidelines

## Project Structure & Module Organization
This repository is an Obsidian vault focused on personal knowledge management.

- `README.md`: source of truth for vault architecture (Zettelkasten + PARA), linking flow, and note-writing process.
- `workflow.md`: multi-agent workflow definition for AI-assisted note processing.
- `skills/`: role-specific skill documents for writing, classification, linking, orchestration, and review.
- Root folders: `00 Inbox`, `01 Permanent`, `02 MOCs`, `10 Projects`, `11 Areas`, `12 Resources`, `13 Archive`.
- `14 Templates`: note templates used by Obsidian and AI-assisted workflows.
- `attachments/`: binary assets organized under `diagrams/`, `screenshots/`, and `files/`.
- `.obsidian/`: local Obsidian app settings (not tracked).

Use numbered folder names to preserve sort order and intent (for example `00 Inbox`, `01 Permanent`, `10 Projects`).

## Build, Test, and Development Commands
There is no software build or CI test pipeline in this repository. Use lightweight checks before committing:

- `git status --short`: confirm only intended files changed.
- `git diff -- README.md AGENTS.md AGENT_KOR.md workflow.md skills`: review guideline and architecture edits.
- `find . -maxdepth 1 -type d | sort`: verify root vault structure.
- `rg "TODO|FIXME" README.md AGENTS.md AGENT_KOR.md workflow.md skills`: catch unfinished placeholders.

If you use Obsidian locally, validate links and navigation (especially MOCs and backlinks) before opening a PR.

## Coding Style & Naming Conventions
Write documentation in Markdown with short sections and clear headings.

- Use `#`, `##`, `###` hierarchies consistently.
- Prefer concise paragraphs and bullet lists over long prose.
- Keep vault folder names prefixed with two-digit ordering (`00`, `01`, ...).
- Keep note and folder names descriptive and stable; avoid frequent renames that break links.
- Follow `skills/writing/SKILL.md` for note-level style (frontmatter, links, tag policy, and attachment handling).

## Multi-Agent Operating Model
This vault uses a lightweight multi-agent workflow for AI-assisted note work.

- `VaultPM`: interprets requests, selects the workflow, and enforces vault rules.
- `InboxClassifier`: classifies note type and recommends the target folder.
- `KnowledgeWriter`: rewrites notes for clarity while preserving meaning.
- `LinkArchitect`: suggests wikilinks, MOCs, and backlink opportunities.
- `Reviewer`: checks structure, omissions, and vault-rule compliance before applying changes.

Use `workflow.md` for orchestration and `skills/` for role-specific capabilities.

Standard team flow:
- classify
- rewrite
- link
- review

Agent outputs must follow the vault flow:
- `00 Inbox` capture
- classify into the correct destination
- add related links
- reflect the result in an MOC when appropriate

Guardrails:
- Show recommendations before bulk moves or renames.
- Preserve note meaning unless the user explicitly requests transformation.
- Prefer wikilinks over tags when a concrete note relationship exists.
- Keep generated metadata aligned with `skills/writing/SKILL.md`.
- When promoting a note to `Project`, create `10 Projects/<project-name>/` and place the main project note inside that folder.
- Do not create new MOCs automatically.
- Consider MOC reflection only when a relevant existing MOC already exists.
- Prefer one best-fit MOC for a note instead of inserting the same note into multiple MOCs.
- If a note is relevant to adjacent topics, connect those via body links or related-note links instead of duplicate MOC insertion.
- If no suitable MOC exists, report the gap but do not create a new MOC automatically.

## Testing Guidelines
Testing is content validation:

- Ensure internal links resolve in Obsidian graph/view.
- Ensure note structure follows the flow in `README.md`: `Inbox -> classify -> link -> reflect in MOC`.
- Ensure MOC reflection uses existing hubs only and avoids duplicate insertion across multiple MOCs.
- Ensure asset references point to files under `attachments/` and are linkable from notes.

For large edits, do a manual pass on sample notes across `Permanent`, `Projects`, and `Resources`.

## Commit & Pull Request Guidelines
Current history uses concise, scoped commit subjects (example: `init: second-brain`). Follow this style:

- Commit format: `<scope>: <summary>`.
- Write `<summary>` primarily in Korean so the change intent is immediately clear to Korean-speaking maintainers.
- English is allowed when it is the clearest name for a technical term, product name, or established concept, but default to Korean phrasing.
- Example: `workflow: AI 오케스트레이션 규칙 추가`, `structure: 첨부파일 폴더 정리`.
- Keep commits focused on one conceptual change.
- In PRs, include: purpose, changed paths, migration/rename notes, and screenshots only when Obsidian UI behavior matters.

Link related issues/tasks when available and call out any backlink-breaking changes explicitly.

## Bilingual Guide Sync Rule
Keep contributor guides synchronized at the repository root:

- When `AGENTS.md` is updated, update `AGENT_KOR.md` in the same change.
- When `AGENT_KOR.md` is updated, reflect the same policy/content changes in `AGENTS.md`.
- For pull requests touching either file, include both files in the diff unless the change is explicitly marked as translation-only.
