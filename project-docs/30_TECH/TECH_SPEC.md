# TECH SPEC / 技術仕様正本

## 1. Architecture / 採用構成
- Adopt `GitHub Pages + HTML/CSS/JavaScript + Supabase`.
- 採用構成は `GitHub Pages + HTML/CSS/JavaScript + Supabase` とする。
- Spring Boot is not adopted at this stage; future migration remains an option in the specification.
- Spring Boot は現時点では未採用であり、将来の移行余地は仕様書側で言及する。

## 1-1. Current Public Site Surface / 現在の公開サイト構成
- Entry point: `index.html` under the `inim-dx` site root.
- 入口ページは `inim-dx` のサイトルートにある `index.html` とする。
- Current homepage order: hero, booking shortcut, experience banner, journey, pickup, new arrivals.
- 現在のホームページ構成は hero、booking shortcut、experience banner、journey、pickup、new arrivals の順とする。
- The homepage uses a hero slider and CTA hierarchy to prioritize reservation flow first.
- ホームページは hero スライダーと CTA 階層で、予約導線を最優先に設計する。
- Current shell scripts: `js/site-config.js`, Supabase JS CDN, `js/site-shell.js`.
- 現在のシェル構成は `js/site-config.js`、Supabase JS CDN、`js/site-shell.js` とする。
- The homepage keeps the top-level voice in Japanese while using English labels for section cues where helpful.
- ホームページは本文を日本語中心としつつ、セクションキューには必要に応じて英語ラベルを併用する。

## 2. Data & Auth Model / データ・認証モデル
- Auth population: `auth.users`.
- 認証の母集団は `auth.users` とする。
- App permissions: `roles`, `user_role_assignments`.
- アプリ権限は `roles`, `user_role_assignments` で管理する。
- Profiles: `user_profiles`.
- プロファイルは `user_profiles` を使用する。
- Anonymous inquiries allow `NULL` in `enquiries.customer_profile_id`.
- 匿名問い合わせでは `enquiries.customer_profile_id` の `NULL` を許容する。

## 3. Core Tables / 主要テーブル
- `user_profiles`, `roles`, `user_role_assignments`
- `content_assets`, `top_hero_items`, `journey_steps`, `stores`
- `bookings`, `enquiries`
- `booking_status_logs`, `enquiry_status_logs`

## 4. SQL Execution Order / SQL実行順
1. `00-1_create_app_schema.sql`
2. `00-2_promote_existing_user_to_admin.sql`
3. `01a_register_sample_members.sql`（必要時）
4. `01_seed_core_data.sql`
5. `02_verify_seed_data.sql`
6. `03_rls_policies.sql`

## 5. Seed Verification Snapshot / 検証済み件数
- `user_profiles = 3`
- `roles = 3`
- `user_role_assignments = 3`
- `stores = 3`
- `content_assets = 5`
- `top_hero_items = 3`
- `journey_steps = 5`
- `bookings = 5`
- `enquiries = 5`
- `booking_status_logs = 4`
- `enquiry_status_logs = 3`

## 6. RLS Baseline / RLS基準
- Set `rowsecurity = true` on all target tables.
- すべての対象テーブルで `rowsecurity = true` とする。
- Helper functions:
- 補助関数:
  - `public.current_user_profile_id()`
  - `public.has_role(text)`
  - `public.has_any_role(text[])`
- Main policies:
- 主要 policy:
  - `top_hero_items_public_read`
  - `journey_steps_public_read`
  - `stores_public_read`
  - `bookings_select_own_or_management`
  - `enquiries_insert_anon_or_own`
  - `user_profiles_select_own_or_admin`

## 7. Rename Migration Record / 命名移行記録
- Migrated objects:
- 対象移行:
  - `reservations` -> `bookings`
  - `reservation_status_logs` -> `booking_status_logs`
  - `inquiries` -> `enquiries`
  - `inquiry_status_logs` -> `enquiry_status_logs`
- Migrated columns:
- カラム移行:
  - `reservation_type` -> `booking_type`
  - `reserved_at` -> `booked_at`
  - `reservation_id` -> `booking_id`
  - `inquiry_id` -> `enquiry_id`
- Result on 2026-03-22: successful; counts, indexes, and policies were confirmed consistent.
- 実施結果（2026-03-22）: 成功。件数・索引・policy の整合を確認済み。

## 8. Implementation Priority / 実装優先順
1. Supabase client initialization
2. Login/session detection
3. `user_profiles` and role retrieval
4. `top_hero_items` CRUD
5. `journey_steps` CRUD
6. `bookings` / `enquiries` operations

## 9. Security Notes / セキュリティ注意
- Do not place `service_role` in the frontend.
- フロントに `service_role` を置かない。
- Use only `anon key`.
- `anon key` のみを使用する。
- Implement reference/update control on the premise of RLS.
- 参照/更新制御は RLS 前提で実装する。

## 10. Source / 参照元
- `instructions/handover-notes.md`
- `instructions/supabase-admin-setup.md`
- `instructions/supabase-rls-setup.md`
- `instructions/sql_migration_plan.md`
- `instructions/cross-project-handover-admin-implementation.md`

## 11. Public UI Notes / 公開UIメモ
- The public landing page is currently a marketing-oriented entry page, not an admin screen.
- 公開ランディングページは、現時点では管理画面ではなく集客導線を重視した入口ページである。
- Key sections to preserve in future edits: hero, booking shortcut, experience banner, journey, pickup, and new arrivals.
- 今後の編集で維持する主要セクションは hero、booking shortcut、experience banner、journey、pickup、new arrivals である。

## 12. Project-side Mirror Links / project側ミラー
- `archives/instructions/handover-notes.md`
- `archives/instructions/supabase-admin-setup.md`
- `archives/instructions/supabase-rls-setup.md`
- `archives/instructions/sql_migration_plan.md`
- `archives/instructions/cross-project-handover-admin-implementation.md`
