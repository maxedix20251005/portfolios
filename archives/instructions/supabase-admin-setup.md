# Supabase 初期管理者セットアップ手順

## 目的

`inim-dx` では、**Supabase のプロジェクト管理者** と **アプリ内の管理者ユーザー** は別物です。

- Supabase のプロジェクト管理者
  - Supabase ダッシュボードに入って、DB や Authentication を操作できる人
- アプリ内の管理者ユーザー
  - `inim-dx` の管理画面で、トップ編集・導線設定・予約確認などを行う人

この手順書は、**既存の `auth.users` ユーザーをアプリ管理者に昇格する方法** と、**必要なら新しい管理者ユーザーを作る方法** を初心者向けに整理したものです。

## 結論

最初の 1 人目の管理者は、**すでに `Authentication > Users` に存在している自分のユーザーを昇格させる** 進め方を推奨します。

新しく admin 用ユーザーを追加した方がいいのは、次のような場合です。

- 本番運用で、普段使いの検証アカウントと分けたい
- 運用担当を複数人に増やしたい
- 誰が管理操作をしたかを分けて追跡したい

## 参考にした公式情報

- Supabase Auth Users: https://supabase.com/docs/guides/auth/users
- Supabase Admin createUser: https://supabase.com/docs/reference/dart/v1/auth-admin-createuser
- Supabase RBAC / Custom Claims: https://supabase.com/docs/guides/database/postgres/custom-claims-and-role-based-access-control-rbac
- Supabase Seeding: https://supabase.com/docs/guides/local-development/seeding-your-database
- Supabase Platform Access Control: https://supabase.com/docs/guides/platform/access-control

## 先に理解しておくこと

### 1. `auth.users` は Supabase が管理する

`auth.users` はログイン情報を持つ Supabase 側のテーブルです。  
通常は、**ダッシュボードの Users 画面** か **Admin API** でユーザーを作成します。  
日常運用では、`auth.users` に直接 `INSERT` しない方が安全です。

### 2. アプリの権限は `public` スキーマ側で持つ

今回の設計では、アプリ内の役割は次のテーブルで管理します。

- `public.user_profiles`
- `public.roles`
- `public.user_role_assignments`

つまり、

1. Supabase Auth にユーザーを作る
2. そのユーザーに対して `user_profiles` を作る
3. `roles` の `admin` を割り当てる

この 3 段階で「アプリ管理者」になります。

### 3. 今回のユーザー運用方針

今の設計方針は次のとおりです。

- `auth.users`
  - ログインできるユーザーを保持する
  - 管理者、編集者、受付担当、会員ユーザー、将来の Workshop 参加者を含む
- `public.roles` / `public.user_role_assignments`
  - そのユーザーがアプリ内で何をできるかを決める
- `public.enquiries.customer_profile_id`
  - `NULL` を許容しているため、問い合わせだけの外部ユーザーは未ログインのまま扱える

つまり、**認証の母集団は `auth.users` に集約し、権限の棲み分けはアプリ側ロールで行う**、という理解で問題ありません。  
ただし、現時点では問い合わせの匿名受付を残しているため、**全外部ユーザーが必ず `auth.users` にいる設計ではありません**。

整理するとこうです。

- 管理者 / 編集者 / 受付担当
  - `auth.users` に登録する
  - アプリロールを付与する
- 会員ユーザー / 将来の Workshop 参加者
  - ログイン機能を持たせるなら `auth.users` に登録する
  - 一般会員ロールや顧客区分で管理する
- 問い合わせだけの外部ユーザー
  - 現行設計では `auth.users` 未登録でも扱える

## 推奨手順

### パターンA: 既存ユーザーを初期管理者にする

最も簡単で安全です。  
現在 `Authentication > Users` にすでに自分のログインユーザーがあるなら、この方法で十分です。

#### 手順

1. Supabase ダッシュボードを開く
2. 左メニューから `Authentication`
3. `Users` を開く
4. 管理者にしたいメールアドレスを確認する
5. 先に [sql/00-1_create_app_schema.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-1_create_app_schema.sql) を `SQL Editor` で実行する
6. 次に [sql/00-2_promote_existing_user_to_admin.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-2_promote_existing_user_to_admin.sql) を開く
7. 先頭付近の `target_email` を、自分の実在メールアドレスに書き換える
8. Supabase の `SQL Editor` を開く
9. SQL を貼り付けて実行する
10. `public.user_profiles` と `public.user_role_assignments` にデータが入ったことを確認する

#### 実行後に確認すること

- `public.roles` に `admin` がある
- `public.user_profiles` に対象ユーザーのプロフィールがある
- `public.user_role_assignments` に `admin` ロールが紐づいている

### パターンB: 新しい管理者ユーザーを作る

既存ユーザーを管理者にしたくない場合に使います。

#### 手順

1. Supabase ダッシュボードを開く
2. 左メニューから `Authentication`
3. `Users` を開く
4. 右上の `Add user` を押す
5. 管理者用のメールアドレスとパスワードを入力する
6. メール確認が必要な設定なら、確認フローも完了する
7. 先に [sql/00-1_create_app_schema.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-1_create_app_schema.sql) を実行する
8. 作成したメールアドレスを [sql/00-2_promote_existing_user_to_admin.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-2_promote_existing_user_to_admin.sql) の `target_email` に設定する
9. `SQL Editor` でその SQL を実行する

#### 補足

- 1 人運用なら、無理に専用 admin を別で作らなくても構いません
- 本番に近づいたら、専用の管理者アカウントを用意した方が管理しやすくなります

## 初期データ投入の順番

SQL は次の順で実行してください。

1. [sql/00-1_create_app_schema.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-1_create_app_schema.sql)
2. [sql/00-2_promote_existing_user_to_admin.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-2_promote_existing_user_to_admin.sql)
3. 必要なら `Authentication > Users > Add user` で `member01@inim-dx.example` と `member02@inim-dx.example` を作る
4. 必要なら [sql/01a_register_sample_members.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01a_register_sample_members.sql) を実行する
5. [sql/01_seed_core_data.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01_seed_core_data.sql) を実行する

## `01_seed_core_data.sql` で入るもの

- ロール定義
  - `admin`
  - `editor`
  - `operator`
- 店舗サンプル
- 画像/音源アセットのメタデータ
- トップヒーロー表示データ
- 体験導線データ
- テスト用予約データ
- テスト用問い合わせデータ
- 各ステータス履歴

## テストユーザー 2 件について

`member01` と `member02` の作成は、**Auth 本体は Dashboard で作成し、アプリ側の紐付けは SQL で行う** のが安全です。  
公式には、Auth ユーザー作成は `Authentication > Users > Add user` または Admin API の `createUser()` が推奨です。  
Source: https://supabase.com/docs/reference/javascript/auth-admin-createuser

作成するメールアドレスは次の 2 件です。

- `member01@inim-dx.example`
- `member02@inim-dx.example`

### 具体的な手順

1. `Authentication > Users > Add user` を開く
2. `member01@inim-dx.example` を作る
3. `member02@inim-dx.example` を作る
4. 必要に応じて `email_confirm` 相当の確認を済ませる
5. [sql/01a_register_sample_members.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01a_register_sample_members.sql) を実行する
6. [sql/01_seed_core_data.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\01_seed_core_data.sql) を実行する

### `01a_register_sample_members.sql` の役割

- `member01@inim-dx.example` を `テストユーザーA` として `user_profiles` に登録
- `member02@inim-dx.example` を `テストユーザーB` として `user_profiles` に登録
- `member01` に `editor` ロールを付与
- `member02` に `operator` ロールを付与

なお、`01_seed_core_data.sql` 側にも同様の補完処理は残していますが、手順を分かりやすくするためにサンプル会員登録を分離しました。

## よくある疑問

### Q1. すでに `auth.users` にデータがあるなら、admin を新規登録すべきですか？

必須ではありません。  
**最初は既存ユーザーを管理者に昇格するだけで十分**です。

新規 admin を作るのは、次のどちらかになってからで問題ありません。

- 運用と検証を分けたい
- 複数人運用を始めたい

### Q2. Supabase の Project Admin と、アプリの admin は同じですか？

同じではありません。

- Supabase Project Admin
  - Supabase プロジェクトの設定変更ができる
- アプリ admin
  - `inim-dx` 管理画面の機能を使える

この 2 つは分けて考えてください。

### Q3. 将来はもっと厳密な権限制御にできますか？

できます。  
公式の RBAC / Custom Claims の仕組みを使えば、JWT にロール情報を含めて RLS と連携できます。現時点では、まず `roles` と `user_role_assignments` でアプリ権限を管理し、必要になった段階で拡張する方が現実的です。

## 初回セットアップのおすすめ

迷ったら、次の順で進めてください。

1. `Authentication > Users` にある自分のユーザーを確認する
2. `sql/00-1_create_app_schema.sql` を実行する
3. `sql/00-2_promote_existing_user_to_admin.sql` のメールアドレスを自分のものに変える
4. SQL Editor で実行する
5. 必要なら `member01` / `member02` を Dashboard で作る
6. 必要なら `sql/01a_register_sample_members.sql` を実行する
7. `sql/01_seed_core_data.sql` を実行する
8. `sql/02_verify_seed_data.sql` で確認する

この順なら、余分な admin アカウントを増やさずに始められます。
