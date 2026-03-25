# PROJECT GOVERNANCE GUIDELINE (FORMAL) / 正式版ガイドライン

## Scope / 適用範囲
- Applies to design, implementation, testing, release, and operations.
- デザイン、実装、テスト、リリース、運用に適用する。
- Covers `docs`, `css`, `js`, and `sql` related delivery and documentation.
- `docs`、`css`、`js`、`sql` 関連の成果物と文書を対象にする。

## Basic Information / 基本情報
- Site URL / 開発対象サイト: `C:\academia\src\inim-dx`
- Design document references / デザイン文書参照先: `C:\academia\src\portfolio\docs`
- Governance document references / ガバナンス文書参照先: `C:\academia\src\portfolio\project-docs`
- Test plan source of truth / テスト計画の正本: `project-docs/60_TEST/inim-dx_test_plan_refined.xlsx`
- Test report source document / テスト報告書の元文書: `docs/09-test-report.html`

## Governance Baseline / ガバナンス基準
- Canonical project governance document: `project-docs/00_GOVERNANCE/PROJECT_GOVERNANCE_AND_RULE.md`
- 正本となるプロジェクトガバナンス文書: `project-docs/00_GOVERNANCE/PROJECT_GOVERNANCE_AND_RULE.md`
- Canonical technical baseline: `project-docs/30_TECH/TECH_SPEC.md`
- 正本となる技術基準: `project-docs/30_TECH/TECH_SPEC.md`
- Canonical status baseline: `project-docs/10_PROJECT/PROJECT_STATUS.md`
- 正本となるステータス基準: `project-docs/10_PROJECT/PROJECT_STATUS.md`
- Canonical restart baseline: `project-docs/90_WIP/WIP.md`
- 正本となる再開基準: `project-docs/90_WIP/WIP.md`

## Documentation Baseline / 文書基準
- Documentation is updated in the same task as implementation.
- 文書は実装と同じタスクで更新する。
- UTF-8 is mandatory.
- UTF-8 を必須とする。
- All project documents must remain bilingual in English and Japanese.
- すべての project 文書は英語と日本語の bilingual を維持する。
- For Japanese content, no mojibake must be confirmed at final review.
- 日本語を含む場合は、最終確認で文字化けなしを必ず確認する。

## Mandatory Update Rules / 必須更新ルール
- Implementation changes: update `PROJECT_STATUS.md` and at least one related document.
- 実装変更: `PROJECT_STATUS.md` と少なくとも1件の関連文書を更新する。
- Testing scope/results changed: update `TEST_PLAN.md`.
- テスト範囲や結果が変わった場合: `TEST_PLAN.md` を更新する。
- Issue progress changed: update `ISSUE_LIST.md`.
- 課題進捗が変わった場合: `ISSUE_LIST.md` を更新する。
- Document add/delete/move/rename: update `DOCUMENT_CATALOG.md`.
- 文書の追加・削除・移動・リネーム: `DOCUMENT_CATALOG.md` を更新する。

## Review Checklist / レビューチェック
- UTF-8 and no encoding corruption.
- UTF-8 であり、エンコーディング破損がないこと。
- Cross-links and filenames are valid.
- 相互参照とファイル名が正しいこと。
- Decision rationale is documented.
- 判断理由が文書化されていること。
- Status, issue, and test records are updated.
- ステータス・課題・テスト記録が更新されていること。
- High-risk changes include pre-approval and rollback steps.
- 高リスク変更には事前承認とロールバック手順を含めること。
- Governance checklist is consulted before sign-off.
- 確認完了の前にガバナンス・チェックリストを参照すること。

## Operational Notes / 運用補足
- Supabase auth/role model, seed, and RLS policies are managed as recorded in `TECH_SPEC.md`.
- Supabase の認証/ロールモデル、seed、RLS ポリシーは `TECH_SPEC.md` の記載どおり管理する。
- SQL migration (reservation/inquiry rename to booking/enquiry naming) is tracked in `TECH_SPEC.md` and validated in `TEST_PLAN.md`.
- SQL migration（reservation/inquiry から booking/enquiry への命名変更）は `TECH_SPEC.md` で管理し、`TEST_PLAN.md` で検証する。
- Full source traceability for migrated instructions is maintained in:
- 移行した instructions の完全な参照追跡は以下で維持する。
  - `INSTRUCTIONS_COVERAGE.md`
  - `archives/instructions/`

## Update Log / 更新履歴
- 2026-03-25: Formal guideline normalized for this project.
- 2026-03-25: Added source-mirror + coverage-audit requirement.
- 2026-03-25: Added basic information references and bilingual document rule.

