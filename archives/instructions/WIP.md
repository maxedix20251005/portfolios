# WIP

## 現在のフェーズ
- フェーズ: Supabase 初期構築・権限制御整備 完了
- 次フェーズ: 管理画面 HTML / JS 実装 開始前

## 完了済み

### ドキュメント整備
- `docs/07-specification.html`
  - 採用構成を `GitHub Pages + HTML/CSS/JavaScript + Supabase` に確定
  - 画面一覧、画面遷移、Must 機能詳細、非機能要件を整理
- `docs/08-db-design.html`
  - ER 図、テーブル定義、インデックス設計、初期データ方針を整理
- `docs/11-admin-mockup.html`
  - 管理画面モックを作成
  - 画面ごとの操作手順と期待効果を追記

### SQL / DB
- `sql/00-1_create_app_schema.sql`
  - アプリ側テーブル・インデックス作成
- `sql/00-2_promote_existing_user_to_admin.sql`
  - 既存 Auth ユーザーを初期管理者へ昇格
- `sql/01a_register_sample_members.sql`
  - `member01` / `member02` をアプリ側へ紐付け
- `sql/01_seed_core_data.sql`
  - マスタ・サンプルデータ投入
- `sql/02_verify_seed_data.sql`
  - 件数と主要データ確認用 SQL
- `sql/03_rls_policies.sql`
  - RLS / policy 適用

### 確認済み
- 初期データ件数は期待どおり
- RLS は対象テーブルすべて `true`
- policy 一覧は期待どおり
- 管理者 / 編集者 / operator / 匿名問い合わせの権限制御方針は整理済み

## 現在の状態
- DB は実装開始可能な状態
- Auth / ロール / seed / RLS まで完了
- フロントエンドの実アプリは未着手
- モックと仕様はあるので、次は画面を実装する段階

## 次アクション
1. 管理画面用のフロントエンド構成を決める
2. Supabase クライアント初期化コードを追加する
3. ログイン画面を実装する
4. `user_profiles` とロール取得を実装する
5. `top_hero_items` と `journey_steps` の CRUD 画面を実装する

## 実装優先順
1. 認証 / セッション確認
2. ロール判定
3. トップ編集
4. 導線設定
5. 予約 / 問い合わせ管理
6. アセット管理

## 注意事項
- フロントには `service_role` を置かない
- `anon key` のみを利用する
- RLS を前提にデータ取得する
- 公開サイト用データと管理画面用データを混同しない
- SQL の再実行順は以下を守る
  - `00-1_create_app_schema.sql`
  - `00-2_promote_existing_user_to_admin.sql`
  - `01a_register_sample_members.sql`（必要時）
  - `01_seed_core_data.sql`
  - `02_verify_seed_data.sql`
  - `03_rls_policies.sql`

## 再開時の一言メモ
- 次は SQL ではなく管理画面実装に進む
- 既存モック `docs/11-admin-mockup.html` を UI 参考にする
- DB 実体は `top_hero_items` / `journey_steps` / `bookings` / `enquiries` を使う
