# Supabase RLS / 権限制御セットアップ手順

## 目的

`inim-dx` では、公開サイトと管理画面でアクセスできるデータを分けます。  
そのために Supabase の **RLS（Row Level Security）** を使い、ユーザーごとに見える行・更新できる行を制御します。

この手順書は、今のテーブル定義とロール設計に合わせて、RLS を安全に有効化するための説明です。

## 参考にした公式情報

- Supabase RLS: https://supabase.com/docs/guides/database/postgres/row-level-security
- Supabase `auth.uid()` / `auth.jwt()`: https://supabase.com/docs/guides/database/postgres/row-level-security#helper-functions
- Supabase RBAC / Custom Claims: https://supabase.com/docs/guides/database/postgres/custom-claims-and-role-based-access-control-rbac

## 今回の考え方

### 公開サイト側

匿名ユーザーでも読めるのは、公開済みデータだけです。

- `content_assets`
  - 論理削除されていないデータだけ
- `top_hero_items`
  - `is_active = true` かつ `deleted_at IS NULL`
- `journey_steps`
  - `is_visible = true`
- `stores`
  - `is_active = true` かつ `deleted_at IS NULL`

### 管理画面側

ログイン済みユーザーでも、ロールごとにできることを分けます。

- `admin`
  - 全管理機能
- `editor`
  - ヒーロー、導線、アセットなどコンテンツ編集
- `operator`
  - 予約・問い合わせの運用

### 一般ユーザー

- 自分の予約だけ見られる
- 自分の問い合わせだけ見られる
- 自分の予約・問い合わせだけ登録できる

### 匿名ユーザー

- 問い合わせの新規登録だけ可能
- その際、`customer_profile_id` は `NULL`
- `status` は `pending` のみ

## 実行ファイル

RLS 適用用 SQL は次です。

- [sql/03_rls_policies.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\03_rls_policies.sql)

## 実行順

1. [sql/00-1_create_app_schema.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-1_create_app_schema.sql)
2. [sql/00-2_promote_existing_user_to_admin.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-2_promote_existing_user_to_admin.sql)
3. [sql/01_seed_core_data.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01_seed_core_data.sql)
4. [sql/03_rls_policies.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\03_rls_policies.sql)

`member01` / `member02` を使う場合は、3 の前に [sql/01a_register_sample_members.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01a_register_sample_members.sql) を実行してください。

## `03_rls_policies.sql` の中身

### 1. 補助関数を作る

次の 3 つを作っています。

- `public.current_user_profile_id()`
  - `auth.uid()` から `user_profiles.id` を取る
- `public.has_role(text)`
  - 現在ユーザーが特定ロールを持つか確認する
- `public.has_any_role(text[])`
  - 現在ユーザーが複数候補のどれかを持つか確認する

### 2. 全テーブルで RLS を有効化する

対象は以下です。

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

### 3. ポリシーを付ける

例:

- 匿名公開データの `SELECT`
- 管理者だけの `UPDATE`
- `editor` / `admin` のコンテンツ編集
- `operator` / `admin` の予約・問い合わせ運用
- 本人データだけ見せるポリシー

## 権限マトリクス

| テーブル | anon | authenticated 一般 | editor | operator | admin |
| --- | --- | --- | --- | --- | --- |
| `content_assets` | 公開分読取 | 公開分読取 | 全件読取・更新 | 全件読取 | 全件読取・更新 |
| `top_hero_items` | 公開分読取 | 公開分読取 | 全件読取・更新 | 全件読取 | 全件読取・更新 |
| `journey_steps` | 公開分読取 | 公開分読取 | 全件読取・更新 | 全件読取 | 全件読取・更新 |
| `stores` | 公開分読取 | 公開分読取 | 全件読取 | 全件読取・更新 | 全件読取・更新 |
| `bookings` | 不可 | 自分のみ | 不可 | 全件読取・更新 | 全件読取・更新 |
| `enquiries` | 登録のみ | 自分のみ読取・登録 | 不可 | 全件読取・更新 | 全件読取・更新 |
| `booking_status_logs` | 不可 | 不可 | 不可 | 読取・登録 | 読取・登録 |
| `enquiry_status_logs` | 不可 | 不可 | 不可 | 読取・登録 | 読取・登録 |
| `user_profiles` | 不可 | 自分のみ読取 | 自分のみ読取 | 自分のみ読取 | 全件読取・更新 |
| `roles` / `user_role_assignments` | 不可 | 不可 | 読取 | 読取 | 読取・更新 |

## 適用後の確認方法

### 1. 管理者でログイン

- `admin` ユーザーでログインできること
- 管理対象テーブルが読めること

### 2. 一般ユーザーでログイン

- `top_hero_items` の公開分は読める
- `bookings` は自分のものだけ見える
- 他人の `bookings` は見えない

### 3. 未ログイン状態

- `top_hero_items` / `journey_steps` / `stores` は公開分のみ読める
- `enquiries` の `INSERT` はできる
- `bookings` は読めない

## 注意点

### 1. これは JWT Custom Claims 未使用の初期版

今の実装は、JWT にロールを埋め込まず、毎回 `user_profiles` と `user_role_assignments` を参照して判定しています。  
初期段階では分かりやすいですが、将来は Custom Claims を使うとより整理しやすくなります。

### 2. サービスロールには RLS は効かない

`service_role` キーは RLS をバイパスします。  
フロントエンドには絶対に置かないでください。

### 3. ロール変更後の挙動

将来 Custom Claims を導入した場合は、トークン更新が必要になります。  
現時点の設計では DB 参照型なので、その影響は比較的小さめです。

## 次の実務ステップ

RLS 適用後は、管理画面の HTML / JS 実装で次を行います。

1. Supabase Auth でログイン
2. ログイン後に `user_profiles` とロールを取得
3. ロールごとにメニュー表示を切り替える
4. `top_hero_items` / `journey_steps` / `bookings` / `enquiries` を API 経由で操作する
