# WIP / 作業中メモ

## In Progress / 現在作業
- `project-docs` ドキュメントを新ガバナンス形式へ統一し、運用の正本を確立する。
- Unify the `project-docs` documents into the new governance format and establish the operational source of truth.

## Next Actions / 次アクション
1. 管理画面のフロントエンド構成（ファイル分割と責務）を確定する。
1. Finalize the admin UI frontend structure, including file splitting and responsibilities.
2. Supabase クライアント初期化とログイン判定を実装する。
2. Implement Supabase client initialization and login/session detection.
3. `user_profiles` / ロール取得とメニュー制御を実装する。
3. Implement `user_profiles` / role retrieval and menu control.
4. `top_hero_items` / `journey_steps` CRUD から機能実装を開始する。
4. Start implementation with `top_hero_items` / `journey_steps` CRUD.

## On Hold / 保留事項
- なし（旧提案資料の校正系タスクは完了判定済み）。
- None; proofreading tasks for the old proposal materials are already complete.

## Restart Steps / 再開手順
1. `project-docs/10_PROJECT/PROJECT_STATUS.md` を確認する。
1. Check `project-docs/10_PROJECT/PROJECT_STATUS.md`.
2. `project-docs/30_TECH/TECH_SPEC.md` の DB/RLS 方針を確認する。
2. Review the DB/RLS policy in `project-docs/30_TECH/TECH_SPEC.md`.
3. `project-docs/60_TEST/TEST_PLAN.md` の確認手順を使って環境健全性をチェックする。
3. Check environment health using the verification steps in `project-docs/60_TEST/TEST_PLAN.md`.
4. 最優先未完了タスク（認証/ロール基盤）を再開する。
4. Resume the highest-priority unfinished task: the authentication/role foundation.

## Notes / 補足
- 実装タスクでは `PROJECT_STATUS.md` と関連文書を同時更新する。
- During implementation tasks, update `PROJECT_STATUS.md` and related documents together.
- 文字化け確認は `TEST_PLAN.md` の UTF-8 手順を利用する。
- Use the UTF-8 procedure in `TEST_PLAN.md` to check for mojibake.
- SQL 再実行順は以下を維持する。
- Keep the SQL rerun order below.
  1. `00-1_create_app_schema.sql`
  2. `00-2_promote_existing_user_to_admin.sql`
  3. `01a_register_sample_members.sql`（必要時）
  4. `01_seed_core_data.sql`
  5. `02_verify_seed_data.sql`
  6. `03_rls_policies.sql`
  6. `03_rls_policies.sql`
