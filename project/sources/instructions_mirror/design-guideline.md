# Design Guideline (Project Archive)

目的: 01–06各ドキュメントと `style.css` を基準に、サイト全体のUIを共通化し、追加ページでも同じトーンで実装できるようにする。

## コアスタイル
- フォント: 日本語 `Noto Sans JP`, 英語 `Inter`（いずれも Google Fonts）。本文は16px/line-height 1.8を基準。
- カラー（CSS変数基準）
  - 背景: `--bg` = #fff, `--bg-gray` = #f5f5f5
  - テキスト: `--text` = #111111, サブテキスト: `--text-light` = #555555, ミュート: #999999
  - ボーダー: `--border` = #e5e5e5, ダーク: #cccccc
  - グレー系: #111111 / #1a1a1a / #333333 / #555555 / #777777 / #999999 / #cccccc / #e5e5e5 / #f5f5f5
- アイコン: Material Symbols Outlined（link, open_in_new 等）。

## レイアウト
- 全ページ共通: `.page-wrapper` 内に `.sidebar`（data-nav-levelでパス切替）と `.main-content`。
- セクション: `.section` + `.section-title` (`<span class="section-icon">` + 番号)。
- コンテンツカード: `.proposal-card`（白背景・角丸・ボーダー）。ハイライト用: `.block-chip` 系（analysis/strategy/execution）を先頭に置く。
- 余白: カード内部は 16px 前後を基準。`table-wrap` でテーブルの横スクロールを許容。

## テーブル
- クラス: `.table`（`proposal-v2` 系も同仕様）。`border-collapse: collapse;` ボーダーは `--border`。
- ヘッダー背景: `--gray-100`。セル padding: 10px 12px。
- カラム幅が必要な場合は `<colgroup>` + 専用クラス（例: `spec-purpose-table`）を付与してCSS側で幅指定。

## ブロック別スタイル指針
- リード文: `.section__lead` で1–3行にまとめる。章末の接続は `.note.section__tail` または `.note.block-bridge` を使い、次章の意図を1文で示す。
- ノート/注記: `.note` を使用し、背景色はデフォルト（透明）、文字色は `--text-light`。
- コード/数式: `.formula-card`、`.code` を既存デザインのまま使用。演算子・チップ類は既存クラスを流用。

## ナビゲーション
- `.sidebar` は nav-level に応じて相対パスを切替（root/docs/design/prompts）。リンクの活性状態は `.active` を付与。
- ハンバーガー（モバイル）で `.sidebar.open` をトグル。外クリックでクローズする既存JSを流用。

## フォーム・入力系
- `external-link-box`（詳細ドキュメント入力）を再利用。`input[type=text]`＋`link-btn`＋`open_in_new` アイコンの組合せを保つ。

## 配色と背景の使い分け
- カード/テーブル背景は白、ページ背景は `--bg-gray`。セクションや表のまとまりを強調したい場合は、外側ラッパー（例: `spec-summary`）に白背景＋`--border` ボーダー＋角丸 12px。

## 例: システム目的テーブル（07-specification）
- `fill-content` 内に本文＋`table-wrap` を置き、テーブルクラス `.spec-purpose-table` で `col` 幅を 25%/75% に指定（CSS）。ラッパーは `.spec-summary`（白背景・ボーダー・角丸）を付与。

## 運用ルール
- インラインCSSは禁止。スタイルは `style.css` にクラスとして追加。
- 新規コンポーネントを作る際は既存クラスの組合せで構成し、必要なら最小限のユーティリティクラスを `style.css` に追記する。
- 配色やタイポグラフィを変える場合はまず CSS変数を更新し、個別値のべた書きを避ける。
