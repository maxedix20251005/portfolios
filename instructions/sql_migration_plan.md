# SQL Migration Plan

## 目的

この資料は、既存 Supabase 環境で旧テーブル名を新テーブル名へ移行するための手順書です。  
対象は以下の 4 テーブルと関連カラムです。

- `reservations` → `bookings`
- `reservation_status_logs` → `booking_status_logs`
- `inquiries` → `enquiries`
- `inquiry_status_logs` → `enquiry_status_logs`

あわせて、次のカラム名も変更します。

- `reservation_type` → `booking_type`
- `reserved_at` → `booked_at`
- `reservation_id` → `booking_id`
- `inquiry_id` → `enquiry_id`

## 前提

- 既存 DB には **旧テーブル名がそのまま存在している**
- データは保持したまま移行したい
- 再構築ではなく rename ベースで移行する
- RLS は旧テーブル名向け policy が既に入っている可能性がある

## 使用する SQL

1. [sql/00-2b_precheck_rename_reservation_inquiry_tables.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-2b_precheck_rename_reservation_inquiry_tables.sql)
2. [sql/00-3_rename_reservation_inquiry_tables.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-3_rename_reservation_inquiry_tables.sql)
3. [sql/03_rls_policies.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\03_rls_policies.sql)
4. [sql/00-4_postcheck_rename_reservation_inquiry_tables.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-4_postcheck_rename_reservation_inquiry_tables.sql)
5. [sql/02_verify_seed_data.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\02_verify_seed_data.sql)

## 実行前の注意

1. Supabase でバックアップまたはスナップショットを取得する
2. 本番ではメンテナンス時間帯に実施する
3. 先にアプリ側 SQL やフロント実装が新名称に追随していることを確認する
4. 旧名と新名が混在している中途半端な状態で `seed.sql` を再投入しない

## 手順

### Step 1. 事前確認

[sql/00-2b_precheck_rename_reservation_inquiry_tables.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-2b_precheck_rename_reservation_inquiry_tables.sql) を実行します。

確認ポイント:

- 旧テーブル
  - `reservations`
  - `reservation_status_logs`
  - `inquiries`
  - `inquiry_status_logs`
  が `exists`
- 新テーブル
  - `bookings`
  - `booking_status_logs`
  - `enquiries`
  - `enquiry_status_logs`
  が `missing`
- 旧カラム `reservation_type` / `reserved_at` / `reservation_id` / `inquiry_id` が存在する
- 旧インデックス名と旧 policy 名が存在する

この時点の件数は控えておきます。移行後に一致確認します。

### Step 2. rename migration 実行

[sql/00-3_rename_reservation_inquiry_tables.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-3_rename_reservation_inquiry_tables.sql) を実行します。

この SQL が行うこと:

- 旧 RLS policy の削除
- 旧テーブル名の rename
- 旧カラム名の rename
- 主要 FK 制約名の rename
- 主要インデックス名の rename
- 新テーブル名側で RLS を有効状態に維持

### Step 3. RLS 再適用

[sql/03_rls_policies.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\03_rls_policies.sql) を再実行します。

理由:

- rename 前の旧 policy は削除済み
- 新テーブル名に対して policy を再作成する必要がある

### Step 4. 移行後確認

[sql/00-4_postcheck_rename_reservation_inquiry_tables.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\00-4_postcheck_rename_reservation_inquiry_tables.sql) を実行します。

確認ポイント:

- 旧テーブル名が `missing`
- 新テーブル名が `exists`
- 新カラム `booking_type` / `booked_at` / `booking_id` / `enquiry_id` が存在する
- 新インデックス名が存在する
- 新 policy 名が存在する
- 件数が事前確認と一致する

### Step 5. 最終確認

[sql/02_verify_seed_data.sql](c:\Users\maxsh\OneDrive\Documents\EDIX\src\portfolio\sql\02_verify_seed_data.sql) を実行します。

期待する確認内容:

- `bookings`
- `enquiries`
- `booking_status_logs`
- `enquiry_status_logs`

の件数が既存データと一致していること。

## 想定結果

移行完了後は、設計書・SQL・RLS・検証 SQL の正本が以下に揃います。

- `bookings`
- `booking_status_logs`
- `enquiries`
- `enquiry_status_logs`
- `booked_at`
- `booking_type`
- `booking_id`
- `enquiry_id`

## 実行結果
#00-2b precheck result
| tablename               | policyname                                |
| ----------------------- | ----------------------------------------- |
| inquiries               | inquiries_insert_anon_or_own              |
| inquiries               | inquiries_select_own_or_management        |
| inquiries               | inquiries_update_management               |
| inquiry_status_logs     | inquiry_status_logs_insert_management     |
| inquiry_status_logs     | inquiry_status_logs_select_management     |
| reservation_status_logs | reservation_status_logs_insert_management |
| reservation_status_logs | reservation_status_logs_select_management |
| reservations            | reservations_insert_own_or_management     |
| reservations            | reservations_select_own_or_management     |
| reservations            | reservations_update_own_or_management     |

#00-3 rename result
Success. No rows returned

#03 rls policies result
Success. No rows returned

#00-4 postcheck result
| id                                   | category    | status      | created_at                  |
| ------------------------------------ | ----------- | ----------- | --------------------------- |
| bbbb0001-0000-4000-8000-000000000001 | general     | completed   | 2026-03-20 08:43:59.8951+00 |
| bbbb0003-0000-4000-8000-000000000003 | pricing     | in_progress | 2026-03-20 08:43:59.8951+00 |
| bbbb0004-0000-4000-8000-000000000004 | partnership | pending     | 2026-03-20 08:43:59.8951+00 |
| bbbb0005-0000-4000-8000-000000000005 | media       | completed   | 2026-03-20 08:43:59.8951+00 |
| bbbb0002-0000-4000-8000-000000000002 | booking     | pending     | 2026-03-20 08:43:59.8951+00 |

##02 verify seed date result
| id                                   | customer_name | category    | subject      | status      | created_at                  |
| ------------------------------------ | ------------- | ----------- | ------------ | ----------- | --------------------------- |
| bbbb0001-0000-4000-8000-000000000001 | テストユーザーA      | general     | 初回体験の流れを知りたい | completed   | 2026-03-20 08:43:59.8951+00 |
| bbbb0003-0000-4000-8000-000000000003 | anonymous     | pricing     | 法人向け料金の相談    | in_progress | 2026-03-20 08:43:59.8951+00 |
| bbbb0004-0000-4000-8000-000000000004 | anonymous     | partnership | コラボイベントのご相談  | pending     | 2026-03-20 08:43:59.8951+00 |
| bbbb0005-0000-4000-8000-000000000005 | anonymous     | media       | 取材依頼         | completed   | 2026-03-20 08:43:59.8951+00 |
| bbbb0002-0000-4000-8000-000000000002 | anonymous     | booking     | 予約変更は可能ですか   | pending     | 2026-03-20 08:43:59.8951+00 |


## やってはいけないこと

- `sql/00-1_create_app_schema.sql` をそのまま再実行して rename の代わりにしようとする
- 旧テーブルを残したまま新テーブルだけ別作成する
- `sql/03_rls_policies.sql` を migration 前に新旧混在状態で何度も実行する

## 補足

- 既存データを保持したまま移行する場合、正攻法は rename migration です
- もしまだどの環境にも旧テーブルしかなく、今後新規構築だけを行うなら、更新済みの `sql/00-1_create_app_schema.sql` から新名称で作る方が簡単です

## 確認結果

2026-03-22 時点で、rename migration 実行後の確認結果は以下のとおり。  
結論として、**テーブル名・カラム名・インデックス名・RLS policy 名の移行は想定どおり完了している** と判断してよい。

### 1. `00-4` / `02_verify_seed_data.sql` 件数確認

| table_name | count |
| --- | --- |
| `user_profiles` | 3 |
| `roles` | 3 |
| `user_role_assignments` | 3 |
| `stores` | 3 |
| `content_assets` | 5 |
| `top_hero_items` | 3 |
| `journey_steps` | 5 |
| `bookings` | 5 |
| `enquiries` | 5 |
| `booking_status_logs` | 4 |
| `enquiry_status_logs` | 3 |

評価:
- 旧 `reservations / inquiries` 系の件数が、新 `bookings / enquiries` 系へ引き継がれている
- 事前件数と一致しており、移行によるデータ欠損は見えていない

### 2. 管理ユーザー・ロール割当確認

| email | display_name | role_code | role_name | account_status |
| --- | --- | --- | --- | --- |
| `chukai.namba@gmail.com` | 運営管理者 | `admin` | 管理者 | `active` |
| `member01@inim-dx.example` | テストユーザーA | `editor` | 編集者 | `active` |
| `member02@inim-dx.example` | テストユーザーB | `operator` | 受付担当 | `active` |

評価:
- ロール割当は移行後も維持されている
- RLS の前提となる運用ユーザー構成は問題なし

### 3. 主要公開データ確認

| step_no | step_name | link_url | is_visible |
| --- | --- | --- | --- |
| 1 | ブランドを知る | `/inim-dx/about.html` | `true` |
| 2 | メニューを選ぶ | `/inim-dx/menu.html` | `true` |
| 3 | 店舗を確認する | `/inim-dx/stores.html` | `true` |
| 4 | 日程を予約する | `/inim-dx/reserve.html` | `true` |
| 5 | 事前相談をする | `/inim-dx/contact.html` | `false` |

評価:
- `journey_steps` のデータ自体は正常
- `step_no = 5` が `false` なのは migration の問題ではなく、現行データ状態の問題

### 4. 新インデックス確認

確認済みインデックス:

- `idx_bookings_booked_at`
- `idx_bookings_customer_profile_id`
- `idx_bookings_status_booked_at`
- `idx_bookings_store_id`
- `idx_enquiries_assigned_to`
- `idx_enquiries_customer_profile_id`
- `idx_enquiries_status_created_at`
- `idx_booking_status_logs_booking_id`
- `idx_booking_status_logs_changed_by`
- `idx_booking_status_logs_created_at`
- `idx_enquiry_status_logs_enquiry_id`
- `idx_enquiry_status_logs_changed_by`
- `idx_enquiry_status_logs_created_at`

評価:
- 旧 `idx_reservations_* / idx_inquiries_*` 系から新命名へ移行できている
- `booked_at` ベースの索引も作成済み

### 5. 新 RLS policy 確認

確認済み policy:

- `bookings_insert_own_or_management`
- `bookings_select_own_or_management`
- `bookings_update_own_or_management`
- `enquiries_insert_anon_or_own`
- `enquiries_select_own_or_management`
- `enquiries_update_management`
- `booking_status_logs_insert_management`
- `booking_status_logs_select_management`
- `enquiry_status_logs_insert_management`
- `enquiry_status_logs_select_management`

評価:
- 新テーブル名向け policy が再作成されている
- rename 後に `sql/03_rls_policies.sql` を再適用した効果が確認できる

### 総合判定

- `bookings / enquiries / booking_status_logs / enquiry_status_logs` への名称移行は完了
- `booked_at / booking_type / booking_id / enquiry_id` への名称移行も完了
- 件数・ロール・インデックス・policy は想定どおり
- 現時点で migration は **成功** と判断してよい
