# PROJECT GOVERNANCE AND RULE / プロジェクト運用ガバナンス

## 0. How To Use / 使い方
- Project: `portfolio` (`inim-dx`)
- Owner: `Project Owner`
- Effective Date: `2026-03-25`
- This document is the project-specific governance baseline.
- Implementation and documentation updates must be completed in the same task.
- 実装と文書更新は同じタスクで完了する。

## 0-1. Basic Information / 基本情報
- Site URL / 開発対象サイト: `C:\academia\src\inim-dx`
- Design document references / デザイン文書参照先: `C:\academia\src\portfolio\docs`
- Governance document references / ガバナンス文書参照先: `C:\academia\src\portfolio\project-docs`
- Test plan source of truth / テスト計画の正本: `project-docs/60_TEST/inim-dx_test_plan_refined.xlsx`
- Test report source document / テスト報告書の元文書: `docs/09-test-report.html`

## 1. Purpose / 目的
- Workflow, management rules, and document quality are standardized.
- ワークフロー、運用ルール、文書品質を標準化する。
- Any contributor can restart work from the document set without hidden context.
- どの担当者でも、文書群だけで隠れた前提なしに作業を再開できる。

## 2. Core Principles / 基本原則
- Keep a clear Single Source of Truth per topic.
- 各論点ごとに明確な Single Source of Truth を維持する。
- Separate facts, decisions, and assumptions.
- 事実、決定事項、仮定を分離する。
- Keep restartability: status, WIP, issues, and tests are always current.
- 再開性を保つため、ステータス・WIP・課題・テストを常に最新化する。

## 3. Encoding And Language Quality / 文字コードと言語品質
- All markdown documents use UTF-8.
- すべての markdown 文書は UTF-8 を使用する。
- All project documents must remain bilingual in English and Japanese.
- すべての project 文書は英語と日本語の bilingual を維持する。
- When Japanese is included, verify no mojibake after updates.
- 日本語を含む場合は、更新後に文字化けがないことを確認する。
- Encoding check method is managed in `project-docs/60_TEST/TEST_PLAN.md` and sourced from `instructions/encoding-check.md`.
- 文字コード確認手順は `project-docs/60_TEST/TEST_PLAN.md` で管理し、`instructions/encoding-check.md` を参照元とする。

## 4. Standard Document Set / 標準ドキュメント
- `project-docs/10_PROJECT/PROJECT_STATUS.md` - current state and priorities
- `project-docs/90_WIP/WIP.md` - immediate next steps
- `project-docs/10_PROJECT/ISSUE_LIST.md` - issue history and status flow
- `project-docs/30_TECH/TECH_SPEC.md` - technical source of truth
- `project-docs/20_PRODUCT/DESIGN_GUIDELINE.md` - UI/UX and style baseline
- `project-docs/60_TEST/TEST_PLAN.md` - test strategy and records
- `project-docs/00_GOVERNANCE/DOCUMENT_CATALOG.md` - document index and ownership
- `project-docs/00_GOVERNANCE/CHECKLIST.md` - operational review checklist
- `project-docs/00_GOVERNANCE/PROJECT_GOVERNANCE_GUIDELINE_FORMAL.md` - formal governance baseline

## 5. Operating Rules / 運用ルール
1. Confirm design and impact scope before implementation.
1. 実装前にデザインと影響範囲を確認する。
2. Validate changes and record results.
2. 変更を検証し、結果を記録する。
3. For each implementation change, update `PROJECT_STATUS.md` and at least one related document.
3. 実装変更ごとに `PROJECT_STATUS.md` と少なくとも1件の関連文書を更新する。
4. On issue status changes, update `ISSUE_LIST.md`.
4. 課題状態が変わったら `ISSUE_LIST.md` を更新する。
5. On test scope/result changes, update `TEST_PLAN.md`.
5. テスト範囲や結果が変わったら `TEST_PLAN.md` を更新する。
6. Keep `DOCUMENT_CATALOG.md` aligned for add/delete/move/rename in the same task.
6. 追加・削除・移動・リネームは同一タスクで `DOCUMENT_CATALOG.md` と整合させる。
7. Check `CHECKLIST.md` before closing the task.
7. タスクを閉じる前に `CHECKLIST.md` を確認する。

## 6. Change Control / 変更統制
- High-risk changes require prior approval: DB schema, auth, billing, public navigation.
- 高リスク変更は事前承認を要する。対象は DB スキーマ、認証、課金、公開導線。
- Define rollback steps before high-impact DB/auth changes.
- 影響の大きい DB / 認証変更の前にロールバック手順を定義する。
- For Supabase-related changes, keep SQL execution order and post-check results recorded.
- Supabase 関連の変更では、SQL 実行順と post-check 結果を記録する。

## 7. Roles (RACI Lite) / 役割
- Responsible: implementer updates code and docs.
- Responsible: 実装担当がコードと文書を更新する。
- Accountable: project owner approves decisions.
- Accountable: Project Owner が判断を承認する。
- Consulted: domain/DB/design reviewers validate content.
- Consulted: ドメイン、DB、デザインのレビュー担当が内容を確認する。
- Informed: stakeholders receive status and issue updates.
- Informed: 関係者に進捗と課題の更新を共有する。

## 8. Source Traceability / 参照元
This governance alignment incorporated and normalized content from:
このガバナンス整備では、以下の内容を取り込み、正規化した。
- `instructions/handover-notes.md`
- `instructions/WIP.md`
- `instructions/pre-revision-proposals.md`
- `instructions/site-cheatsheet.md`
- `instructions/encoding-check.md`
- `instructions/supabase-admin-setup.md`
- `instructions/supabase-rls-setup.md`
- `instructions/sql_migration_plan.md`
- `instructions/design-guideline.md`
- `instructions/work-done-by-codex.md`
- `instructions/windows-restart-10line-summary.md`
- `instructions/cross-project-handover-admin-implementation.md`

Evidence and full-text traceability:
証跡と全文追跡は以下で保持する。
- `project-docs/00_GOVERNANCE/INSTRUCTIONS_COVERAGE.md` (hash-based coverage audit)
- `project-docs/00_GOVERNANCE/INSTRUCTIONS_COVERAGE.md`（ハッシュベースの反映突合）
- `archives/instructions/*.md` (archived source backups)
- `archives/instructions/*.md`（アーカイブ済み原文バックアップ）

## 9. Update Log / 更新履歴
- 2026-03-25: Project governance initialized and normalized from `instructions` set.
- 2026-03-25: Added full source mirrors and coverage audit for no-missing reflection.
- 2026-03-25: Added basic information references and bilingual document rule.



