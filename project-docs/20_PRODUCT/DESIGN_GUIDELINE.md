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

## Current Theme Palette / 現在のテーマ配色
- The design-guide preview and component samples should follow the current `inim-dx/js/site-shell.js` `themeOptions` source.
- デザインガイドのプレビューとコンポーネント見本は、現在の `inim-dx/js/site-shell.js` の `themeOptions` を参照元とする。
- The current default palette is `P44 / Apricot Mist`.
- 現在のデフォルト配色は `P44 / Apricot Mist` とする。
- Core tokens:
- 主要トークン:
  - `main` = `#F4A460`
  - `sub` = `#FAD4B2`
  - `accent` = `#CD853F`
  - `background` = `#FFF5EC`
  - `text` = `#5D4037`
  - `muted` = `#A1887F`
- Keep document-side previews aligned with `references/06-design-guide/colour-comparison-40.html`.
- 文書側プレビューは `references/06-design-guide/colour-comparison-40.html` と整合させる。

## Current Public Landing Page / 現在の公開ランディングページ
- The homepage should feel like a guided fragrance experience, not a generic brochure page.
- ホームページは、一般的な紹介ページではなく、香り体験へ誘導する構成にする。
- Preserve the current section order: hero, booking shortcut, experience banner, journey, pickup, and new arrivals.
- 現在のセクション順である hero、booking shortcut、experience banner、journey、pickup、new arrivals を維持する。
- Hero copy should lead with a strong emotional hook and a clear reservation CTA.
- hero のコピーは、感情に訴える強いフックと明確な予約 CTA を先頭に置く。
- Booking-related actions should remain visually dominant over secondary browsing actions.
- 予約系のアクションは、閲覧系の補助アクションよりも視覚的に優先する。
- Product and feature blocks should use compact cards with strong imagery and short supporting copy.
- 商品・特集ブロックは、強い画像と短い補足文を持つコンパクトなカードで構成する。
- Use bilingual micro-labels where they help orientation, but keep the main page narrative coherent in Japanese.
- 案内に役立つ箇所では bilingual の小見出しを使い、本文の物語性は日本語で一貫させる。

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
- Keep the booking-first hero CTA hierarchy intact when adding or revising content blocks.
- コンテンツ追加や見直し時も、予約優先の hero CTA 階層を維持する。
- When wireframe assets are revised, embed the shared SVG files from `references/05-wireframe/` rather than duplicating inline SVG markup in `docs/05-wireframe.html`.
- ワイヤーフレーム資産を更新する場合は、`docs/05-wireframe.html` に SVG をインライン複製せず、`references/05-wireframe/` の共通 SVG を参照する。

## Source / 参照元
- `instructions/design-guideline.md`
- `instructions/site-cheatsheet.md`
- `instructions/work-done-by-codex.md`

## Project-side Mirror Links / project側ミラー
- `archives/instructions/design-guideline.md`
- `archives/instructions/site-cheatsheet.md`
- `archives/instructions/work-done-by-codex.md`
