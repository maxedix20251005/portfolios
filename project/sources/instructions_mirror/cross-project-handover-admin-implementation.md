# 別GitHub向け引継ぎ文（inim-dx 管理画面実装）

## 目的

この引継ぎ文は、**別GitHub / 別VS Codeプロジェクトで inim-dx の管理画面実装を開始するための単独資料**です。  
新しいリポジトリ側では、この文書と関連成果物を参照しながら、Supabase 接続済みの管理画面フロントエンド実装へ移行してください。

## プロジェクトの前提

- 公開構成: `GitHub Pages + HTML/CSS/JavaScript + Supabase`
- バックエンド方針:
  - Spring Boot は現時点では未採用
  - Supabase を DB / Auth / Storage / RLS の中心に使う
- 目的:
  - 予約数増加を主軸とした Web サイト運用
  - 管理画面からトップ表示、導線、問い合わせ、予約、素材を管理する

## ここまでに完了していること

### 1. 仕様整理

- `docs/07-specification.html`
  - 採用構成
  - 画面一覧
  - 画面遷移
  - Must 機能詳細
  - 非機能要件

### 2. DB 設計

- `docs/08-db-design.html`
  - ER 図
  - テーブル定義
  - インデックス設計
  - 初期データ投入順

### 3. 管理画面モック

- `docs/11-admin-mockup.html`
  - 全体導線
  - 主要画面モック
  - 補助系画面モック
  - 各画面の「誰が / 目的 / 操作手順 / 期待効果」

### 4. Supabase 初期化

以下の SQL は実行・確認済みです。

1. `sql/00-1_create_app_schema.sql`
2. `sql/00-2_promote_existing_user_to_admin.sql`
3. `sql/01a_register_sample_members.sql`
4. `sql/01_seed_core_data.sql`
5. `sql/02_verify_seed_data.sql`
6. `sql/03_rls_policies.sql`

### 5. 確認済み件数

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

### 6. RLS 状態

- 対象テーブルはすべて `rowsecurity = true`
- 主な policy:
  - `top_hero_items_public_read`
  - `journey_steps_public_read`
  - `stores_public_read`
  - `bookings_select_own_or_management`
  - `enquiries_insert_anon_or_own`
  - `user_profiles_select_own_or_admin`

## ユーザー / 権限の考え方

- `auth.users`
  - ログイン可能ユーザーの母集団
  - 管理者 / 編集者 / 受付担当 / 一般会員 / 将来の Workshop 参加者を含む
- `roles`
  - `admin`
  - `editor`
  - `operator`
- `user_role_assignments`
  - 上記ロールをアプリ側で紐付ける

補足:
- 問い合わせだけの外部ユーザーは、現行設計では匿名受付を許容
- したがって、外部ユーザーが必ず `auth.users` に存在するわけではない

## 次に実装すべきこと

### 優先順

1. Supabase クライアント初期化
2. ログイン / セッション確認
3. `user_profiles` とロール取得
4. ロール別メニュー表示
5. `top_hero_items` CRUD
6. `journey_steps` CRUD
7. `bookings` / `enquiries` 一覧と更新

### 最初の実装対象

最初は次の2画面を実装すると自然です。

- トップ編集
  - 対象テーブル: `top_hero_items`
- 導線設定
  - 対象テーブル: `journey_steps`

理由:
- 仕様とモックが揃っている
- 公開サイト側の反映対象として価値が高い
- RLS の影響も比較的読みやすい

## 新しいリポジトリで最初に読むべき資料

### 必須

- `07-specification.html`
- `08-db-design.html`
- この引継ぎ文

### 強く推奨

- 管理画面モックの自己完結版 HTML
  - [11-admin-mockup-standalone.html](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\references\11-admin-mockup-standalone.html)

## モック共有の推奨方法

`11-admin-mockup.html` は `css/style.css` 依存があるため、**そのまま単体で別プロジェクトへ持っていくと表示崩れの可能性があります**。  
そのため、別GitHubへ渡す資料としては、**CSS を内包した自己完結版 HTML を正本として参照する** のが最も安全です。

### 推奨成果物

- モック参照用の自己完結版 HTML
  - [11-admin-mockup-standalone.html](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\references\11-admin-mockup-standalone.html)

### 元ファイル

- 元HTML
  - [11-admin-mockup.html](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\docs\11-admin-mockup.html)
- 元CSS
  - [style.css](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\css\style.css)

### この方式を選んだ理由

- PDF は画面サイズや改ページの影響を受けやすい
- SVG は画面数が多い今回のモックには不向き
- 自己完結 HTML なら、1ファイルで見た目を維持したまま共有できる
- 別GitHub側で必要なら、そのままデザイン参照資料として開ける

## 新しいリポジトリでの実装方針

### 技術方針

- 素の `HTML / CSS / JavaScript` で開始して問題ない
- フロントからは `anon key` のみ使用
- `service_role` は絶対に置かない
- 認証後に `user_profiles` とロールを取得して、UI 表示と操作可否を切り替える

### 実装イメージ

1. `supabase.js`
   - Supabase client 初期化
2. `auth.js`
   - ログイン / ログアウト / セッション確認
3. `session.js`
   - 現在ユーザーの `user_profiles` / ロール取得
4. `pages/top-hero.js`
   - `top_hero_items` 一覧取得 / 保存
5. `pages/journey-steps.js`
   - `journey_steps` 一覧取得 / 保存

## 新しいリポジトリで最初に Codex へ渡す依頼文

以下をそのまま使えます。

```txt
別リポジトリに切り替えました。
inim-dx の管理画面実装を開始してください。

前提:
- GitHub Pages + HTML/CSS/JavaScript + Supabase
- DB / seed / RLS は既に別環境で整備済み
- 仕様は 07-specification.html
- DB設計は 08-db-design.html
- 画面イメージは 11-admin-mockup-standalone.html を参照

まずは instructions と既存構成を確認し、
1. Supabase 接続
2. ログイン判定
3. user_profiles / ロール取得
4. トップ編集（top_hero_items）
5. 導線設定（journey_steps）
の順で実装してください。
```

## 補足

- DB 再構築が必要な場合は、現在の正本は `sql/` 配下です
- `docs/08-db-design.html` は First Draft 扱いで、現行 SQL とは整合済み
- 仕様の源泉は `07-specification.html`
- UI の源泉は `11-admin-mockup-standalone.html`
