# 引継ぎメモ（inim-dx / Supabase初期構築・RLS導入後）

## 現在の作業対象
- `docs/07-specification.html`
- `docs/08-db-design.html`
- `docs/11-admin-mockup.html`
- `css/style.css`
- `sql/`
- `instructions/`

## 現在の到達点
- 採用構成は `GitHub Pages + HTML/CSS/JavaScript + Supabase` で確定。
- `docs/07-specification.html`
  - `sec1`: 採用構成、構成図、運用フロー、コスト観点、将来の Spring Boot / Java 移行余地を反映済み。
  - `sec2`: 画面/機能一覧を採用構成に合わせて整理済み。
  - `sec3`: 画面遷移図をテキストベースで整理済み。
  - `sec4`: Must 機能の詳細仕様を記載済み。
  - `sec5`: 非機能要件を優先度つき表形式で整理済み。Spring Boot 補足セキュリティ要件も追記済み。
- `docs/08-db-design.html`
  - `sec1`: テキストベース ER 図を記載済み。
  - `sec2`: テーブル定義書を主要テーブル分記載済み。
  - `sec3`: インデックス設計を記載済み。
  - `sec4`: SQL 草案への参照を含む初期データ方針を記載済み。
- `docs/11-admin-mockup.html`
  - 管理画面モックを作成済み。
  - 各画面に「誰が / 目的 / 操作手順 / 期待効果」を追記済み。
- `css/style.css`
  - `07-specification` 用の構成図/フロー表示スタイルを追加済み。
  - 管理画面モック用スタイルを追加済み。
  - 表はみ出し対策として `fill-block` の横スクロールと `doc-table` の折返しを追加済み。
  - `docs/08-db-design.html` の SQL 表示用 `.doc-db .code` を追加済み。

## SQL / Supabase でここまでに実施したこと

### 1. スキーマ作成
- [sql/00-1_create_app_schema.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-1_create_app_schema.sql)
- 主要テーブル作成済み:
  - `user_profiles`
  - `roles`
  - `user_role_assignments`
  - `content_assets`
  - `top_hero_items`
  - `journey_steps`
  - `stores`
  - `bookings`
  - `enquiries`
  - `booking_status_logs`
  - `enquiry_status_logs`
- 主要インデックスも同ファイルで作成済み。

### 2. 管理者昇格
- [sql/00-2_promote_existing_user_to_admin.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-2_promote_existing_user_to_admin.sql)
- 既存 `auth.users` ユーザーを初期管理者へ昇格済み。
- `user_profiles = 1`、`user_role_assignments = 1` の状態を経由し、その後サンプル会員追加まで完了。

### 3. サンプル会員登録
- [sql/01a_register_sample_members.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01a_register_sample_members.sql)
- `member01@inim-dx.example`
- `member02@inim-dx.example`
- 上記2ユーザーを `user_profiles` と `user_role_assignments` に紐付け済み。
- ロール割当:
  - `member01` → `editor`
  - `member02` → `operator`

### 4. 初期データ投入
- [sql/01_seed_core_data.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01_seed_core_data.sql)
- 投入対象:
  - `roles`
  - `stores`
  - `content_assets`
  - `top_hero_items`
  - `journey_steps`
  - `bookings`
  - `enquiries`
  - `booking_status_logs`
  - `enquiry_status_logs`
- サンプルユーザー未存在時でも落ちないように、親データ存在チェックを入れて修正済み。

### 5. seed 検証
- [sql/02_verify_seed_data.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\02_verify_seed_data.sql)
- 最新確認結果:
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
- この件数は期待どおりで、DB 初期化は完了と判断してよい。

### 6. RLS / 権限制御
- [sql/03_rls_policies.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\03_rls_policies.sql)
- 補助関数:
  - `public.current_user_profile_id()`
  - `public.has_role(text)`
  - `public.has_any_role(text[])`
- 全対象テーブルで `rowsecurity = true` を確認済み。
- `pg_policies` 確認結果も意図どおり。
- 主な policy:
  - `top_hero_items_public_read`
  - `journey_steps_public_read`
  - `stores_public_read`
  - `bookings_select_own_or_management`
  - `enquiries_insert_anon_or_own`
  - `user_profiles_select_own_or_admin`

## 運用方針として確定していること
- `auth.users` はログイン可能ユーザーの母集団。
- 管理者 / 編集者 / 受付担当 / 一般会員 / 将来の Workshop 参加者は、必要に応じて `auth.users` に登録する。
- 権限の棲み分けは `roles` と `user_role_assignments` で管理する。
- 問い合わせだけの外部ユーザーは、現時点では匿名受付を許容しているため、必ずしも `auth.users` に登録しない。
- 公開サイトから見えるデータは RLS で公開分のみに制限する。

## 参照すべき手順書
- [instructions/supabase-admin-setup.md](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\instructions\supabase-admin-setup.md)
  - 管理者昇格、サンプル会員追加、初期データ投入の手順
- [instructions/supabase-rls-setup.md](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\instructions\supabase-rls-setup.md)
  - RLS の考え方、権限マトリクス、適用順

## 次にやること
1. 管理画面の HTML / JS 実装に着手する。
2. まずは共通基盤を作る。
   - Supabase 接続設定
   - ログイン判定
   - 現在ユーザーの `user_profiles` / ロール取得
   - ロールに応じたメニュー表示切替
3. 最初の実装対象は `トップ編集` と `導線設定` が自然。
   - `top_hero_items`
   - `journey_steps`
4. その後に `予約 / 問い合わせ管理` へ進む。

## 実装再開時の依頼テンプレ
以下をそのまま貼り付けて再開できる。

```txt
handover-notes.md を前提に、inim-dx の管理画面実装を開始してください。
まずは Supabase 接続、ログイン判定、ロール取得、トップ編集 / 導線設定の CRUD から進めてください。
既存の docs/11-admin-mockup.html を見た目の参考にしつつ、実データは top_hero_items と journey_steps を使用してください。
```

## 補足
- `docs/08-db-design.html` の `sec4` には SQL 草案の説明が残っているが、実行は `sql/` 配下ファイルを正とする。
- `customer_preferences` や `profiles` の policy は Supabase 既存/別系統であり、今回追加した `inim-dx` 用 RLS の確認対象外。
