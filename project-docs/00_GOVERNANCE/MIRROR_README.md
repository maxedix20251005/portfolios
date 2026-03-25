# MIRROR README / ミラー運用手順

## Purpose / 目的
- Keep archived instruction backups in sync with the current root instruction set.
- アーカイブ済み instruction バックアップを最新の root instruction 群と同期する。

## Rules / ルール
- The source of truth for the archived copies is `archives/instructions/`.
- アーカイブコピーの参照先は `archives/instructions/` とする。
- Do not edit archived files directly unless the source set is being regenerated in the same task.
- 同一タスクで再生成する場合を除き、アーカイブファイルを直接編集しない。
- Update the coverage record after any source refresh.
- ソース更新後は coverage 記録を更新する。

## Notes / 補足
- This file is kept in `project-docs` because it is operational guidance, not a mirrored source artifact.
- このファイルはミラー元そのものではなく運用手順のため、`project-docs` に保持する。
