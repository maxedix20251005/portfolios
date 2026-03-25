# DESIGN GUIDELINE / デザイン基準

## Purpose / 目的
- Normalize the policy for `docs/01` through `docs/06` and `css/style.css`, and keep the same tone available for additional pages.
- `docs/01`〜`docs/06` と `css/style.css` の方針を共通化し、追加ページでも同トーンで実装できる状態を維持する。

## Core Style / コアスタイル
- Font: `Noto Sans JP` for Japanese, `Inter` for English.
- フォント: 日本語は `Noto Sans JP`、英語は `Inter` を使う。
- Base size: 16px with line-height 1.8.
- 基本サイズは 16px、line-height は 1.8 とする。
- Color variables:
- 色変数:
  - `--bg` = #fff, `--bg-gray` = #f5f5f5
  - `--text` = #111111, `--text-light` = #555555
  - `--border` = #e5e5e5
- Icons: Material Symbols Outlined.
- アイコンは Material Symbols Outlined を使用する。

## Layout / レイアウト
- Shared structure: `.page-wrapper` + `.sidebar` + `.main-content`.
- 共通構造は `.page-wrapper` + `.sidebar` + `.main-content` とする。
- Sections: `.section` + `.section-title`.
- セクションは `.section` + `.section-title` を使う。
- Cards: `.proposal-card`.
- カードは `.proposal-card` を使う。
- Allow horizontal scrolling with `.table-wrap`.
- 横スクロールは `.table-wrap` で許容する。

## Table Rules / テーブル規約
- Use `.table` as the standard and set `border-collapse: collapse`.
- `.table` を標準利用し、`border-collapse: collapse` とする。
- Header background: `--gray-100`.
- ヘッダー背景は `--gray-100` とする。
- Cell padding: 10px 12px.
- セル余白は 10px 12px とする。
- When a width definition is needed, use `<colgroup>` with a dedicated class such as `.spec-purpose-table`.
- 幅指定が必要な場合は `<colgroup>` と専用クラス（例: `.spec-purpose-table`）を使う。

## Component Reuse / 主要コンポーネント再利用
- Left-line headings: `.section__title--bar`.
- 左ライン見出しは `.section__title--bar` を使う。
- Formula cards: `.formula-*`.
- 数式カードは `.formula-*` を使う。
- Funnel diagrams: `.funnel-*`.
- ファネル図は `.funnel-*` を使う。
- Two-branch diagrams: `.branch-*`.
- 2分岐図は `.branch-*` を使う。
- Scope emphasis: `.scope-*`.
- Scope 強調は `.scope-*` を使う。
- Observation design cards: `.observation-*`.
- 観測設計カードは `.observation-*` を使う。
- Phase emphasis: `.phase1-row`.
- フェーズ強調は `.phase1-row` を使う。

## Navigation / ナビゲーション
- `.sidebar` switches relative paths by `nav-level`.
- `.sidebar` は `nav-level` ごとに相対パスを切り替える。
- Active links use `.active`.
- アクティブリンクは `.active` を使う。
- On mobile, toggle `.sidebar.open` and close it when clicking outside.
- モバイルでは `.sidebar.open` を切り替え、外側クリックで閉じる。

## Operational Rules / 運用ルール
- Inline CSS is prohibited; consolidate styles in `css/style.css`.
- インライン CSS は禁止し、`css/style.css` に集約する。
- Prefer combinations of existing classes and keep additions minimal.
- 既存クラスの組み合わせを優先し、追加は最小限にする。
- Tune colors via CSS variables instead of individual values.
- 配色調整は個別値ではなく CSS 変数で行う。
- Keep heading hierarchy as `h2 (chapter) -> h3 (section)`.
- 見出し階層は `h2(章) -> h3(節)` を維持する。

## Source / 参照元
- `instructions/design-guideline.md`
- `instructions/site-cheatsheet.md`
- `instructions/work-done-by-codex.md`

## Project-side Mirror Links / project側ミラー
- `archives/instructions/design-guideline.md`
- `archives/instructions/site-cheatsheet.md`
- `archives/instructions/work-done-by-codex.md`
