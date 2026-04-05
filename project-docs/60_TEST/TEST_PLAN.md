# TEST PLAN / テスト計画

## Purpose / 目的
- Define the test scope, methods, exit criteria, and verification history.
- テスト範囲、方式、完了条件、確認履歴を定義する。

## Scope / 対象範囲
- Validate the correctness of the initial DB setup and seed/RLS application.
- DB 初期構築と seed/RLS 適用結果の妥当性を確認する。
- Check consistency of the rename migration from old names to new names.
- 旧命名から新命名への rename migration の整合を確認する。
- Verify UTF-8 and mojibake handling in Japanese files.
- 日本語ファイルの UTF-8 文字化けを検査する。
- Verify that planning/design documents stay aligned with the current local `inim-dx` sitemap, wireframes, and theme palette.
- planning/design 文書が現在のローカル `inim-dx` のサイトマップ、ワイヤーフレーム、テーマ配色と整合していることを確認する。
- Keep the test-report case inventory aligned with the actually implemented public/admin site flows.
- テスト報告書のケース一覧が、実装済みの public/admin サイト導線に整合していることを確認する。

## Entry Criteria / 開始条件
- SQL files are present under `sql/`.
- SQL ファイルが `sql/` 配下に揃っている。
- The target Supabase project is reachable.
- Supabase 対象プロジェクトに接続できる。
- The documents to be verified are up to date.
- 検証対象ドキュメントが更新済みである。

## Exit Criteria / 完了条件
- Expected row counts match and major RLS policies are confirmed.
- 期待件数が一致し、主要 RLS policy が確認できる。
- No old names remain after the rename.
- rename 後に旧名が残っていない。
- No mojibake is detected in Japanese documents.
- 日本語文書で文字化けが未検出である。

## Test Types / テスト種別
- Unit: `N`
- Integration: `Y` (SQL + RLS)
- E2E: `N`
- Manual: `Y`

## Test Cases / テストケース
| ID | Feature | Preconditions | Steps | Expected | Result | Date | Owner |
|---|---|---|---|---|---|---|---|
| `TC-001` | UTF-8破損検知 | `docs/css/js` が存在 | `ReadAllText(UTF8)` で `0xFFFD` を検査 | 置換文字が未検出 | `Pass` | `2026-03-13` | `Doc Owner` |
| `TC-002` | 日本語実データ確認 | 日本語見出しを含む対象ファイルが存在 | `Select-String -Encoding UTF8` で主要語句を検索 | 日本語文字列が正しく一致 | `Pass` | `2026-03-13` | `Doc Owner` |
| `TC-003` | rename migration precheck | 旧テーブルが存在 | `00-2b_precheck_rename_reservation_inquiry_tables.sql` 実行 | 旧名 exists / 新名 missing | `Pass` | `2026-03-22` | `DB Owner` |
| `TC-004` | rename + RLS再適用 | `TC-003` pass | `00-3` -> `03_rls_policies` 実行 | rename 成功、policy 再作成可能 | `Pass` | `2026-03-22` | `DB Owner` |
| `TC-005` | postcheck + seed verify | `TC-004` pass | `00-4_postcheck` と `02_verify_seed_data` 実行 | 件数・索引・policy・新命名が一致 | `Pass` | `2026-03-22` | `DB Owner` |
| `TC-006` | planning/design sync check | `docs/04`〜`docs/06` と参照 assets が更新済み | ローカル `inim-dx` と `docs/04-sitemap.html`、`docs/05-wireframe.html`、`docs/06-design-guide.html`、参照 SVG/preview を見比べる | サイト構成、ワイヤーフレーム参照、配色プレビューが現行サイトと一致 | `Pass` | `2026-04-05` | `Doc Owner` |
| `TC-007` | updated document UTF-8 check | 日本語を含む対象文書が更新済み | `ReadAllText(UTF8)` / `Select-String -Encoding UTF8` で更新ファイルを確認 | 置換文字なし、日本語文字列が正しく一致 | `Pass` | `2026-04-05` | `Doc Owner` |
| `TC-008` | test-report case coverage review | `docs/09-test-report.html` sec2 の見直し対象が存在 | 実装済み `inim-dx` の public/admin ページと `docs/09-test-report.html` sec2 を比較する | 追加が必要なケースが整理され、`TC-073`〜`TC-102` が反映されている | `Pass` | `2026-04-05` | `Doc Owner` |
| `TC-009` | test workbook sync and completion status update | `docs/09-test-report.html` sec2 が最新化済み | `test_cases_inim-dx.xlsx` と `inim-dx_test_plan_refined.xlsx` を sec2 正本へ同期する | `TC-001`〜`TC-100` が `完了` で一致し、`不具合ID` が反映される | `Pass` | `2026-04-05` | `Doc Owner` |
| `TC-010` | test-report summary/bug/device section update | `docs/09-test-report.html` sec2 が更新済み | sec3 指標、sec4 Issue要約、sec5 対応環境を更新し、不具合ID整合を確認する | sec3〜sec5 が最新状態で一致し、`2026-03-27-24` 修正と iPadOS 検証結果が反映される | `Pass` | `2026-04-05` | `Doc Owner` |

## Defect Linkage / 不具合連携
- `TC-001`, `TC-002` -> `ISSUE-001`
- `TC-003`, `TC-004`, `TC-005` -> `ISSUE-002`
- `TC-006`, `TC-007` -> `N/A` (governance sync record)
- `TC-006`, `TC-007` -> `N/A`（ガバナンス同期記録）
- `TC-008` -> `N/A` (test inventory alignment)
- `TC-008` -> `N/A`（テストケース棚卸し整合）
- `TC-009` -> `N/A` (artifact synchronization and status update)
- `TC-009` -> `N/A`（成果物同期とステータス更新）
- `TC-010` -> `N/A` (report section maintenance and environment matrix update)
- `TC-010` -> `N/A`（報告書セクション保守と対応環境更新）

## Quality Note / 品質注意
- Verify UTF-8 and mojibake whenever Japanese text is included.
- 日本語を含む場合は UTF-8 と文字化け有無を確認する。
