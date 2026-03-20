# デプロイ構成比較メモ

更新日: 2026-03-20

## 目的
- `inim-dx` の公開サイトと管理画面モックを、できるだけ低コストで実装・公開するための比較メモ。
- 比較対象は、現在検討中の `HTML/CSS/JS + Supabase` 構成と、添付メモ `デプロイ_DB最適化手順.txt` で言及されていた `Render + Neon` / `Render + Supabase` 構成。
- 今後の判断材料として残し、必要に応じて更新する。

## 前提整理
- 今回の管理画面モックは、`ログイン / ダッシュボード / トップ編集 / 導線設定 / カード管理 / 商品管理 / 店舗管理 / 記事管理 / ユーザー管理 / 予約・問い合わせ管理 / アセット管理` を含む。
- これらの多くは、`静的フロント + JavaScript + Supabase` でも成立する。
- ただし、権限昇格を伴う処理、重い集計、外部連携、厳格な監査ログなどは、サーバー側の実装があると有利。

## 比較対象
### 案A: GitHub Pages + Supabase
- フロント: GitHub Pages
- データ/認証/Storage: Supabase
- バックエンド: なし

### 案B: Render Static Site + Supabase
- フロント: Render Static Site
- データ/認証/Storage: Supabase
- バックエンド: なし

### 案C: Render Web Service + Neon + Spring Boot
- フロント/バックエンド: Spring Boot を Render にデプロイ
- DB: Neon(PostgreSQL)

### 案D: Render Web Service + Supabase + Spring Boot
- フロント/バックエンド: Spring Boot を Render にデプロイ
- DB/Auth/Storage: Supabase

## 結論
### 現時点の第一候補
- **案A: GitHub Pages + Supabase**

### 理由
- 今回のモック範囲は、静的フロントでも十分実装可能。
- 初期費用を最も抑えやすい。
- 既に GitHub Pages 運用との親和性が高い。
- Java/Spring Boot を先に入れなくても、設計と実装を前に進められる。

### 例外的に案C/案Dを選ぶ条件
- 複雑な承認フローや権限管理を最初から強く入れたい。
- APIを自前で定義してフロントと疎結合にしたい。
- 将来的に外部連携やバッチ処理をかなり増やす前提が固い。

## プロコン比較
| 項目 | 案A GitHub Pages + Supabase | 案B Render Static + Supabase | 案C Render + Neon + Spring Boot | 案D Render + Supabase + Spring Boot |
| --- | --- | --- | --- | --- |
| 初期コスト | 最小 | 小 | 小〜中 | 小〜中 |
| 実装速度 | 速い | 速い | やや遅い | やや遅い |
| 構成の単純さ | 高い | 高い | 中 | 中 |
| Java不要 | はい | はい | いいえ | いいえ |
| 管理画面CRUD | 十分可能 | 十分可能 | 可能 | 可能 |
| 認証/権限制御 | Supabase Auth + RLS | Supabase Auth + RLS | Spring Securityで柔軟 | Spring Security + Supabaseで柔軟 |
| 画像/音源管理 | Supabase Storageで可能 | Supabase Storageで可能 | 別途実装またはSupabase併用 | Supabase Storageで可能 |
| 複雑な業務ロジック | やや弱い | やや弱い | 強い | 強い |
| 運用保守 | 比較的軽い | 比較的軽い | アプリ保守が増える | アプリ保守が増える |
| 学習コスト | 低い | 低い | 中〜高 | 中〜高 |
| 将来拡張 | 中 | 中 | 高 | 高 |

## 各案の評価
### 案A: GitHub Pages + Supabase
#### 向いているケース
- ポートフォリオ用途
- 低コスト優先
- フロント中心で素早く形にしたい
- 管理画面の大半が CRUD と基本集計で済む

#### メリット
- GitHub Pages は HTML/CSS/JavaScript の静的ホスティングにそのまま使える。
- 既存の GitHub リポジトリ中心運用と相性が良い。
- サーバー保守が不要。
- Supabase 側で Auth / DB / Storage / Realtime をまとめて持てる。

#### デメリット
- Spring Boot のような自由なサーバー処理は置けない。
- 強い権限操作や集計処理は、Supabase Edge Functions などを併用したくなる。
- Supabase Free Plan は低活動状態が7日続くと pause されうる。

#### この案で十分できること
- ログイン
- ダッシュボード表示
- トップ編集
- 導線設定
- カード管理
- 商品管理
- 店舗管理
- 記事管理
- 予約・問い合わせ管理
- アセット管理

#### 注意
- フロント公開鍵はブラウザで使えるが、secret/service_role は絶対に置かない。
- RLS 設計が品質の中核になる。

### 案B: Render Static Site + Supabase
#### 向いているケース
- 案A とほぼ同じだが、GitHub Pages より Render の運用機能を使いたい
- PR Preview、ヘッダー設定、リライトルールを使いたい

#### メリット
- 静的サイトとしては無料で使いやすい。
- CDN、TLS、PR Preview、リライト設定が便利。

#### デメリット
- 今回のアプリ要件では、GitHub Pages より大きな優位は出にくい。
- 既に GitHub Pages 運用が前提なら、移行価値は限定的。

#### 判断
- 機能的には有力だが、**今回の第一候補にする理由は弱い**。

### 案C: Render + Neon + Spring Boot
#### 向いているケース
- Java/Spring Boot を活かしたい
- 管理ロジックをサーバー側に集中したい
- PostgreSQL をシンプルに持ちたい

#### メリット
- Spring Boot 側で API、認証、業務ロジック、CSV、通知を柔軟に実装しやすい。
- Neon Free は pricing 上、Free で始めやすく、inactive 時は scale to zero がある。

#### デメリット
- Render Free Web Service は 15分 idle で spin down する。
- 静的フロントより構成が重い。
- Java 側の実装・保守コストが増える。
- 今回のモック要件にはややオーバースペック気味。

#### 判断
- **将来の本格業務システム化には強いが、初期フェーズとしては重い**。

### 案D: Render + Supabase + Spring Boot
#### 向いているケース
- Java/Spring Boot も使いたい
- かつ Supabase の Auth / Storage / GUI を活かしたい

#### メリット
- Spring Boot と Supabase の両方の長所を取り込みやすい。
- 将来の拡張余地は大きい。

#### デメリット
- 構成が最も複雑になりやすい。
- Spring Boot と Supabase の責務分担を曖昧にすると設計がぶれる。
- 初期フェーズには過剰になりやすい。

#### 判断
- **拡張前提なら強いが、今の段階では設計負荷が高い**。

## 添付メモとの比較要点
添付 `デプロイ_DB最適化手順.txt` は、主に `Spring Boot + PostgreSQL` の永続デプロイ手順を整理したものだった。  
そのため、比較の前提が「Javaアプリを動かすならどのDBを使うか」に寄っている。

今回こちらで検討しているのは、そもそも
- Javaアプリを最初から持つべきか
- Supabase を BaaS として使って静的フロントで完結できるか

という、**1段上の構成判断**である。

したがって、添付メモの価値は高いが、使いどころは次の通り。

### 補足
- 添付メモは方向性として有用だが、無料枠や停止条件はサービス側で変わりうる。
- 2026-03-20 時点で確認した公式情報では、Render Free Web Service は `15分` アイドルで spin down し、Supabase Free Plan は `7日` 低活動で pause されうる。
- そのため、「完全放置で永続無料」と断定するより、**無料枠の条件付きで成立する構成**として理解するのが安全。

### 今すぐ使う段階
- まだ早い可能性が高い

### 将来使う段階
- `HTML/CSS/JS + Supabase` で運用してみた結果、業務ロジックやサーバー処理が足りないと判明した時
- そのときに `Render + Neon` か `Render + Supabase` の比較材料として再利用する

## 推奨方針
### Phase 1
- **GitHub Pages + Supabase** で開始
- 管理画面と公開サイトを JS + Supabase で構築
- RLS、Auth、Storage の設計を先に固める

### Phase 2
- 足りない部分のみ Supabase Edge Functions を追加
- 対象:
  - 権限昇格処理
  - メール通知
  - 重いCSV生成
  - 監査ログ補助

### Phase 3
- それでも不足が明確なら、Spring Boot 導入を再評価
- その際の第一比較対象:
  - Render + Neon
  - Render + Supabase

## 現時点の実務判断
- **最小コストで早く進めたい**: 案A
- **静的運用だが Render の便利機能も欲しい**: 案B
- **Java で業務ロジックを強く持ちたい**: 案C
- **Java も Supabase も両方使いたい**: 案D

## 現時点の推奨結論
- まずは **案A: GitHub Pages + Supabase** を採用するのが最も合理的。
- 理由は、今回のモック範囲なら技術的に成立し、最小コストで試作から設計確定まで進めやすいから。
- Java/Spring Boot は、必要性が明確になってから導入しても遅くない。

## 参考資料
- 添付ローカル資料: `c:\Users\maxsh\Downloads\デプロイ_DB最適化手順.txt`
- GitHub Pages: https://docs.github.com/pages/getting-started-with-github-pages/what-is-github-pages
- Render Static Sites: https://render.com/docs/static-sites
- Render Free instances: https://render.com/docs/free
- Neon pricing: https://neon.com/pricing
- Supabase billing overview: https://supabase.com/docs/guides/platform/billing-on-supabase
- Supabase inactivity note: https://supabase.com/docs/guides/deployment/going-into-prod
- Supabase API keys: https://supabase.com/docs/guides/api/api-keys
