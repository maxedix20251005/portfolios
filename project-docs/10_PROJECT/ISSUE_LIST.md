# ISSUE LIST / 課題台帳

## Purpose / 目的
- Manage issues, defects, and resolution history.
- 課題・不具合・対処履歴を管理する。

## Issue Table / 課題一覧
| ID | Date | Environment | Summary | Detail | Status | Solution | Closed Date | Owner |
|---|---|---|---|---|---|---|---|---|
| `ISSUE-001` | `2026-03-13` | `Windows + PowerShell` | Potential Japanese mojibake | The terminal display looked corrupted, so the actual file integrity needed verification. | `Closed` | Defined UTF-8 verification steps (`ReadAllText(UTF8)` / `Select-String -Encoding UTF8`) and confirmed no issues in the target files. | `2026-03-13` | `Doc Owner` |
| `ISSUE-002` | `2026-03-22` | `Supabase` | Migration from old to new table names | `reservations/inquiries` needed to be migrated to `bookings/enquiries`, including RLS, indexes, and policies. | `Closed` | Executed precheck -> rename migration -> RLS reapply -> postcheck -> verify, and confirmed consistency of counts, indexes, and policies. | `2026-03-22` | `DB Owner` |
| `ISSUE-003` | `2026-03-25` | `Documentation` | Governance documents were still template-like | The `project-docs` side still looked like templates and did not yet have an operational source of truth. | `Closed` | Renamed the templates into operational names and normalized the `instructions` content into the new governance format. | `2026-03-25` | `Project Owner` |

## Status Flow / ステータス遷移
- `Open -> Investigating -> Fixing -> Monitoring -> Closed`

## Rules / ルール
- Keep history append-only; do not overwrite records.
- 履歴は上書きせず、追記で管理する。
- Reflect major updates in `PROJECT_STATUS.md` as well.
- 主要更新は `PROJECT_STATUS.md` にも反映する。
- Verify UTF-8 and mojibake whenever Japanese text is included.
- 日本語を含む場合は UTF-8 と文字化けを確認する。
