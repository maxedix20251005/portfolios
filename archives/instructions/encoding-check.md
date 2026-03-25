# 文字化け確認メモ

## 目的
- 日本語中心のHTML/CSS/JSで、文字化けが混入していないかを早い段階で確認する。
- 表示崩れではなく、ファイル自体の文字コード破損を確認対象とする。

## 確認対象
- `docs`
- `css`
- `js`

## 基本方針
- テキストファイルは UTF-8 前提で確認する。
- macOS 由来の `.DS_Store` はバイナリのため、文字化け検査対象から除外する。
- PowerShell 画面上で文字化けして見えても、ファイル本体が正常な場合があるため、必ず `Select-String -Encoding UTF8` で実データを確認する。

## 最低限の確認コマンド
```powershell
Get-ChildItem -Recurse -File docs,css,js |
  Where-Object { $_.Name -ne '.DS_Store' } |
  ForEach-Object {
    $text = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    if ($text.Contains([string][char]0xFFFD)) {
      $_.FullName
    }
  }
```

用途:
- 置換文字 `�` が入っているファイルを検出する。

## 日本語の実データ確認コマンド
```powershell
Select-String -Path docs/10-retrospective.html -Pattern 'プロジェクト振り返り','企画・設計段階','AIプロンプト例' -Encoding UTF8
```

用途:
- PowerShell の表示ではなく、UTF-8 として保存されている実際の日本語文字列を確認する。

## 2026-03-13 時点の確認結果
- `docs` `css` `js` 配下のテキスト資産で、修正が必要な文字化けは未検出。
- `docs/.DS_Store` は `�` を含むが、バイナリ管理ファイルのため対象外。
- `docs/10-retrospective.html` は日本語見出し・本文とも UTF-8 として正常。
- `docs/01-proposal.html`
- `docs/07-specification.html`
- `docs/09-test-report.html`
  上記3ファイルも日本語タイトル・見出しを正常に保持。

## 運用ルール
- 日本語ページを更新したら、そのファイルだけでも `Select-String -Encoding UTF8` で主要見出しを確認する。
- 大きな編集の前後で、このメモの確認コマンドを再実行する。
