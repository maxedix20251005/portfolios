# PROJECT STATUS / プロジェクト状況

## 1. Purpose / 目的
- Track the current state, priorities, and confirmed decisions.
- 現在の状態、優先事項、確定方針を記録する。

## 2. Current Focus / 現在の主対象
- The admin UI HTML/JS work is ready to move from preparation into implementation.
- 管理画面 HTML/JS 実装は開始準備が整っており、実装フェーズへ移行する。
- The public landing page has been synchronized with the latest website structure and documented in bilingual form.
- 公開ランディングページは最新のサイト構成に合わせて文書へ反映済みである。
- The planning/design documents `docs/04` through `docs/06` have been aligned with the current `inim-dx` sitemap, wireframes, and theme palette.
- planning/design 文書 `docs/04` から `docs/06` は、現在の `inim-dx` のサイトマップ、ワイヤーフレーム、テーマ配色に整合した。

## 3. Confirmed Policies / 確定方針
- Adopt `GitHub Pages + HTML/CSS/JavaScript + Supabase`.
- 採用構成は `GitHub Pages + HTML/CSS/JavaScript + Supabase` とする。
- Use only the `anon key` on the frontend; do not use `service_role`.
- フロントでは `anon key` のみを使用し、`service_role` は使用しない。
- Manage permissions with `roles` and `user_role_assignments`, and implement on the premise of RLS.
- 権限は `roles` / `user_role_assignments` で管理し、RLS 前提で実装する。
- Anonymous inquiry submission is allowed; `customer_profile_id` may be `NULL`.
- 問い合わせは匿名受付を許容し、`customer_profile_id` は `NULL` を許容する。

## 4. Completed / 実施済み
- Specification, DB design, and admin mockup organization completed.
- 仕様・DB 設計・管理画面モックの整理を完了した。
  - `docs/07-specification.html`
  - `docs/08-db-design.html`
  - `docs/11-admin-mockup.html`
- Public homepage structure reflected in the planning/design documents.
- 公開ホームページの構成を planning/design 文書へ反映した。
  - Hero / booking shortcut / experience banner / journey / pickup / new arrivals
- Current sitemap, wireframe references, and design-guide palette samples synchronized with the local `inim-dx` source.
- 現在のサイトマップ、ワイヤーフレーム参照、デザインガイドの配色サンプルをローカル `inim-dx` ソースと同期した。
  - `docs/04-sitemap.html`
  - `docs/05-wireframe.html`
  - `docs/06-design-guide.html`
  - `references/05-wireframe/*.svg`
  - `references/06-design-guide/colour-comparison-40.html`
- Supabase SQL execution and verification completed.
- Supabase SQL の実行と検証を完了した。
  - `00-1_create_app_schema.sql`
  - `00-2_promote_existing_user_to_admin.sql`
  - `01a_register_sample_members.sql`
  - `01_seed_core_data.sql`
  - `02_verify_seed_data.sql`
  - `03_rls_policies.sql`
- Rename migration from `reservations/inquiries` to `bookings/enquiries` completed.
- `reservations/inquiries` 系から `bookings/enquiries` 系への rename migration を完了した。

## 5. Next Priorities / 次の優先事項
1. Implement the admin authentication and session foundation, including Supabase connection, login detection, and role retrieval.
1. 管理画面の認証/セッション基盤を実装する（Supabase 接続、ログイン判定、ロール取得）。
2. Implement CRUD for `top_hero_items` and `journey_steps`.
2. `top_hero_items` と `journey_steps` の CRUD を実装する。
3. Implement list and update operations for `bookings` and `enquiries`.
3. `bookings` / `enquiries` の一覧・更新を実装する。

## 6. Risks / リスク
- RLS assumptions and page implementation conditions may diverge.
- RLS の想定と画面実装の参照条件が一致しないリスクがある。
- Supabase environment drift, such as missing reapplication of users, seeds, or RLS, may reduce reproducibility.
- Supabase 環境差分（ユーザー/seed/RLS 再適用漏れ）により再現性が低下するリスクがある。
- Japanese document updates may introduce encoding corruption.
- 日本語文書更新時のエンコーディング破損リスクがある。

## 7. Update Log / 更新履歴
- 2026-04-05: Updated `docs/04` to `docs/06` and related reference assets to match the current sitemap, cleaned wireframes, and `P44 / Apricot Mist` theme palette; verified UTF-8/no mojibake.
- 2026-04-05: `docs/04` から `docs/06` と関連参照アセットを、現行サイトマップ、整理済みワイヤーフレーム、`P44 / Apricot Mist` 配色に合わせて更新し、UTF-8/文字化けなしを確認した。
- 2026-04-05: Synchronized the public homepage structure and corrected the site path reference in governance docs.
- 2026-04-05: 公開ホームページ構成を同期し、ガバナンス文書のサイト参照を実地に合わせて修正した。
- 2026-03-25: Integrated the `instructions` set into the new governance-aligned format.
- 2026-03-22: Verified the SQL rename migration results successfully.
- 2026-03-13: Updated the mojibake inspection procedure and confirmed no issues.

## Quality Note / 品質注意
- When Japanese text is included in updates, verify UTF-8 and the absence of mojibake.
- 日本語を含む更新では UTF-8 と文字化け有無を確認する。
