# DOCUMENT CATALOG / ドキュメント目録

## Purpose / 目的
- List document locations, purposes, and owners.
- ドキュメントの所在、用途、責任者を一覧化する。

## Catalog / 目録
| File | Path | Summary | Purpose | Owner |
|---|---|---|---|---|
| `PROJECT_GOVERNANCE_AND_RULE.md` | `project-docs/00_GOVERNANCE/` | プロジェクト運用ガバナンス正本 | 運用ルール・統制の基準 | `Project Owner` |
| `PROJECT_GOVERNANCE_GUIDELINE_FORMAL.md` | `project-docs/00_GOVERNANCE/` | 正式版ガイドライン | 監査/レビュー用の形式基準 | `Project Owner` |
| `PROJECT_STATUS.md` | `project-docs/10_PROJECT/` | 現在地と優先事項 | 進捗の正本 | `PM` |
| `WIP.md` | `project-docs/90_WIP/` | 直近作業メモ | 再開性の確保 | `Implementer` |
| `ISSUE_LIST.md` | `project-docs/10_PROJECT/` | 課題台帳 | 課題履歴と状態管理 | `PM` |
| `TEST_PLAN.md` | `project-docs/60_TEST/` | テスト計画と実績 | 品質確認と検証履歴 | `QA/Implementer` |
| `TECH_SPEC.md` | `project-docs/30_TECH/` | 技術仕様正本 | DB/RLS/実装方針の正本 | `Tech Lead` |
| `DESIGN_GUIDELINE.md` | `project-docs/20_PRODUCT/` | デザイン規約 | UI/UX一貫性の維持 | `Design Owner` |
| `TEMPLATE_USAGE_GUIDE.md` | `project-docs/00_GOVERNANCE/` | テンプレート利用手順 | 横展開時の適用手順 | `Project Owner` |
| `INSTRUCTIONS_COVERAGE.md` | `project-docs/00_GOVERNANCE/` | instructions 反映突合の監査記録 | 未反映ゼロ確認の証跡 | `Project Owner` |
| `MIRROR_README.md` | `project-docs/00_GOVERNANCE/` | instructions ミラー運用ルール | 保守時の更新手順 | `Project Owner` |
| `CHECKLIST.md` | `project-docs/00_GOVERNANCE/` | ガバナンス・チェックリスト | 再発防止の確認基準 | `Project Owner` |
| `archives/instructions/` | `archives/` | instructions アーカイブ一式 | 原文追跡・全文参照 | `Project Owner` |

## Source Mapping / 参照元マッピング
- 統一フォーマット化時のソース:
  - `instructions/INDEX.md`
  - `instructions/handover-notes.md`
  - `instructions/windows-restart-10line-summary.md`
  - `instructions/pre-revision-proposals.md`
  - `instructions/site-cheatsheet.md`
  - `instructions/encoding-check.md`
  - `instructions/sql_migration_plan.md`
  - `instructions/supabase-admin-setup.md`
  - `instructions/supabase-rls-setup.md`
  - `instructions/design-guideline.md`
  - `instructions/WIP.md`
  - `instructions/work-done-by-codex.md`
  - `instructions/cross-project-handover-admin-implementation.md`

## Related Links / 関連リンク
- 反映突合表: `project-docs/00_GOVERNANCE/INSTRUCTIONS_COVERAGE.md`
- ミラー運用: `project-docs/00_GOVERNANCE/MIRROR_README.md`
- チェックリスト: `project-docs/00_GOVERNANCE/CHECKLIST.md`
- アーカイブ原文: `archives/instructions/`

## Rules / ルール
- 追加・削除・移動・リネーム時は同一タスクで更新する。
- Update the catalog in the same task when adding, deleting, moving, or renaming documents.
- パスとファイル名を実体と一致させる。
- Keep paths and filenames aligned with the actual files.
- UTF-8 を使用し、日本語がある場合は文字化けを確認する。
- Use UTF-8 and verify mojibake when Japanese text exists.

## Update Log / 更新履歴
- 2026-03-25: テンプレート名を実運用名にリネームし、`instructions` 内容を統一フォーマットへ移送。
- 2026-03-25: `project-docs` への再配置と `archives/instructions` 参照へ更新。

