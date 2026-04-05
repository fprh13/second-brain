---
name: obsidian-save
description: Commit and push all current changes in this Obsidian vault using the repository's required commit message and the currently checked out branch. Use when the user asks to save, sync, commit, or push the vault's latest work in this project, especially after note or vault-policy edits that should be preserved in git.
---

# Obsidian Save

이 스킬은 현재 Obsidian 볼트 저장소의 변경사항을 한 번에 저장합니다.

커밋 메시지는 항상 `notes: sync`를 사용하고, 현재 체크아웃된 브랜치를 기준으로 `origin`에 푸시합니다.

## Workflow

1. `git status --short`로 변경사항이 있는지 확인합니다.
2. Git 저장소와 현재 브랜치가 유효한지 확인합니다.
3. 변경사항이 있으면 `git add -A`로 스테이징합니다.
4. `git commit -m "notes: sync"`로 커밋합니다.
5. `git push origin <current-branch>`로 현재 브랜치를 푸시합니다.

## Rules

- 이 저장소에서는 커밋 메시지를 절대 바꾸지 말고 항상 `notes: sync`를 사용합니다.
- 푸시 대상 브랜치는 사용자가 따로 지정하지 않으면 현재 브랜치를 그대로 사용합니다.
- 저장소 전체 변경사항을 대상으로 처리합니다.
- 변경사항이 없으면 커밋이나 푸시를 시도하지 않고 종료합니다.
- Git 오류가 발생하면 무시하지 말고 실패 원인을 그대로 사용자에게 전달합니다.

## Execution

이 스킬을 사용할 때는 아래 스크립트를 실행합니다.

```bash
bash .codex/skills/obsidian-save/scripts/obsidian_save.sh
```

## Expected Result

- 변경사항이 있으면 `notes: sync` 커밋이 생성됩니다.
- 푸시가 성공하면 현재 브랜치의 최신 상태가 `origin`에 반영됩니다.
- 변경사항이 없으면 아무 것도 변경하지 않고 종료합니다.
