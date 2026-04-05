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
- Test-report coverage for the actual public/admin site was expanded in `docs/09-test-report.html` section 2.
- 実サイト構成に合わせたテスト報告書のケース範囲を `docs/09-test-report.html` の section 2 で拡張した。
  - Added `TC-073` to `TC-102`
  - Covered booking completion, search hubs, account/auth support, admin access mode, and shell regressions
- Test-report sections 3 to 5 were completed with summary metrics, issue table linkage, and verified browser/device matrix.
- テスト報告書の section 3 から 5 は、サマリー指標、Issue連携表、検証済みブラウザ/デバイス一覧で更新完了した。
  - sec3: `件数 102`, `OK率 85.29%`, `NG率 14.71%`, `保留 0`, `再試験 N/A`
  - sec4: sec2 に紐づく Issue のみを `ISSUE_LIST.md` から要約
  - sec5: Win11/Chrome・Win11/Edge・macOS/Safari・macOS/Chrome・Android/Chrome・iPadOS/Chrome・iPadOS/Safari
  - sec2 issue ID correction: `2026-03-26-24` -> `2026-03-27-24`
- Test case artifacts were refreshed and synchronized to the latest authoritative range in section 2.
- テストケース成果物は section 2 の最新正本範囲へ更新・同期した。
  - `project-docs/60_TEST/test_cases_inim-dx.xlsx`
  - `project-docs/60_TEST/inim-dx_test_plan_refined.xlsx`
  - Marked `TC-001` to `TC-100` as complete (`完了`) and reflected linked issue IDs
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
- 2026-04-05: Expanded `docs/09-test-report.html` section 2 with additional cases (`TC-073` to `TC-102`) based on the implemented site flows; verified UTF-8/no mojibake.
- 2026-04-05: 実装済みサイト導線に基づき `docs/09-test-report.html` section 2 の追加ケース（`TC-073`〜`TC-102`）を反映し、UTF-8/文字化けなしを確認した。
- 2026-04-05: Refreshed `test_cases_inim-dx.xlsx` and created/synchronized `inim-dx_test_plan_refined.xlsx` using `docs/09-test-report.html` section 2 as source; set `TC-001` to `TC-100` to `完了` and reflected issue IDs.
- 2026-04-05: `docs/09-test-report.html` section 2 を正本として `test_cases_inim-dx.xlsx` を更新し、`inim-dx_test_plan_refined.xlsx` を作成・同期した。`TC-001` から `TC-100` を `完了` に設定し、不具合 ID を反映した。
- 2026-04-05: Updated `docs/09-test-report.html` sections 3 to 5 with computed summary values, issue summary table linked to `ISSUE_LIST.md`, and verified browser/device matrix (including iPadOS). Corrected sec2 issue ID from `2026-03-26-24` to `2026-03-27-24`.
- 2026-04-05: `docs/09-test-report.html` の section 3 から 5 を、算出済みサマリー値、`ISSUE_LIST.md` 連携のIssue要約表、検証済みブラウザ/デバイス一覧（iPadOS含む）で更新した。あわせて sec2 の不具合IDを `2026-03-26-24` から `2026-03-27-24` へ修正した。
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
