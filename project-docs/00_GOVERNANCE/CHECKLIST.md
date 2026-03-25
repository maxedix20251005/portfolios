# GOVERNANCE CHECKLIST / ガバナンス・チェックリスト

## Purpose / 目的
- Keep the recurring governance rules in one place so the same mistakes are less likely to reoccur.
- 繰り返し使うガバナンス規約を一か所にまとめ、同じミスの再発を防ぎやすくする。
- This checklist is the operational review aid for document updates and UI/doc changes.
- このチェックリストは、文書更新と UI/文書変更の運用確認用補助資料である。

## 1. Before Editing / 編集前
- Confirm the target file is in the correct folder.
- 対象ファイルが正しいフォルダにあることを確認する。
- Confirm whether the file is governed by `docs/` or `project-docs/`.
- そのファイルが `docs/` 管轄か `project-docs/` 管轄かを確認する。
- Check whether the file must remain bilingual.
- そのファイルが bilingual 維持対象かを確認する。
- Check whether inline CSS or inline scripting is prohibited.
- inline CSS または inline スクリプトが禁止かを確認する。

## 2. During Editing / 編集中
- Keep the content meaning unchanged unless a change request explicitly requires it.
- 変更要求が明示されていない限り、内容の意味を変えない。
- Keep file and folder names aligned with the actual structure.
- ファイル名とフォルダ名を実体構成と一致させる。
- Use shared styles and shared references instead of ad hoc local duplication.
- 個別のローカル複製ではなく、共通スタイルと共通参照を使う。
- Keep cross-links and reference paths updated in the same task.
- 相互参照と参照パスは同じタスクで更新する。

## 3. After Editing / 編集後
- Confirm the document still opens and the structure is valid.
- 文書が開けること、構造が壊れていないことを確認する。
- Confirm UTF-8 and no mojibake when Japanese text is present.
- 日本語がある場合は UTF-8 と文字化けなしを確認する。
- Confirm bilingual sections still read naturally.
- bilingual 部分が自然に読めることを確認する。
- Confirm the change log or related governance record is updated when required.
- 必要な場合は更新履歴または関連ガバナンス記録を更新する。

## 4. Change-Type Rules / 変更種別ルール
- Document add, delete, move, and rename require catalog updates in the same task.
- 文書の追加・削除・移動・リネームは同一タスクで目録を更新する。
- Test scope or result changes require `TEST_PLAN.md` updates.
- テスト範囲や結果の変更は `TEST_PLAN.md` の更新を要する。
- Issue status changes require `ISSUE_LIST.md` updates.
- 課題状態の変更は `ISSUE_LIST.md` の更新を要する。
- High-risk changes require pre-approval and rollback steps.
- 高リスク変更は事前承認とロールバック手順を要する。

## 5. Current References / 現在の参照先
- `project-docs/00_GOVERNANCE/PROJECT_GOVERNANCE_AND_RULE.md`
- `project-docs/00_GOVERNANCE/PROJECT_GOVERNANCE_GUIDELINE_FORMAL.md`
- `project-docs/00_GOVERNANCE/DOCUMENT_CATALOG.md`
- `project-docs/00_GOVERNANCE/INSTRUCTIONS_COVERAGE.md`
- `project-docs/60_TEST/TEST_PLAN.md`
- `project-docs/10_PROJECT/ISSUE_LIST.md`
- `project-docs/20_PRODUCT/DESIGN_GUIDELINE.md`
- `project-docs/30_TECH/TECH_SPEC.md`
- `project-docs/90_WIP/WIP.md`
