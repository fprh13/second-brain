---
created: 2026-03-15 03:27:29
---
# AGENTS.md

## Purpose

This repository is an Obsidian vault for personal knowledge management.

Your role is to assist in creating, refining, and organizing notes while preserving structure, readability, and consistency.

Follow `VAULT_RULES.md` as the primary policy document.

---

## Core Rules

- Do not move note files unless explicitly requested by the user.
    
- The user decides note location. You may recommend better placement.
    
- Do not rewrite user content except for critical typo fixes.
    
- Do not change the meaning or intent of any note.
    
- Keep edits minimal, precise, and reversible.
    

---

## Editing Rules

- Do not move content across existing `##` sections.
    
- Preserve the original structure of notes.
    
- Limit changes to readability improvements only.
    
- Avoid excessive formatting or stylistic rewriting.
    
- Use fenced code blocks for commands, config, logs, and code.
    

---

## Vault Structure Rules

Respect the vault organization:

- `00 Inbox` → temporary notes
    
- `01 Permanent` → evergreen knowledge
    
- `02 MOCs` → map of content
    
- `10 Projects` → active work
    
- `11 Areas` → ongoing responsibilities
    
- `12 Resources` → reference material
    
- `13 Archive` → inactive content
    
- `14 Templates` → reusable templates
    
- Do not rename folders.
    
- Do not reorganize folder structure.
    

---

## Linking Rules

- Use `[[Note Name]]` for internal links.
    
- Maintain a single `related notes` section per note.
    
- Avoid excessive or unnecessary links.
    
- Preserve graph readability and avoid tangled connections.
- Do not create links to or from `11 Areas/취업/TIL`.
    

---

## Attachment Rules

- Store attachments under `attachments/`.
    
- Organize into `diagrams/`, `screenshots/`, and `files/`.
    
- Ensure all attachment references are valid.
    

---

## Template Rules

- Keep minimal required frontmatter (`created`, note-type tag).
    
- Remove obsolete metadata when updating templates.
    
- Do not introduce unnecessary fields.
    

---

## Validation Rules

- Ensure internal links resolve correctly.
    
- Detect duplicate note filenames.
    
- Suggest corrections for misplaced notes (do not move automatically).
    
- Ensure attachments are properly referenced.
    
- Maintain consistency across notes.
    

---

## Commit Rules

- Always use `notes: sync` as the commit message.
    
- Do not generate arbitrary commit messages.
    
- Keep commit messages consistent across all changes.
    

---

## Pull Request Rules

- Include purpose, changed paths, and migration notes.
    
- Include screenshots only when Obsidian UI behavior is affected.
    
- Explicitly mention backlink or graph structure risks if relevant.
    

---

## Language Rules

- Default to Korean unless the note is intentionally written in English.
    

---

## Safety Rules

- Never perform destructive operations.
    
- Never reorganize the vault without explicit instruction.
    
- When uncertain, do not act and ask for clarification.
- Treat `11 Areas/취업/TIL` as a read-only study area written by someone else. Do not edit notes there, do not add links to it, and do not include it in Git tracking.
    

---

## Sync Rules

- Keep `AGENTS.md` and `AGENT_KOR.md` synchronized.
    
- When updating one, update the other unless it is translation-only.
