-- inim-dx / application seed data
-- Prerequisite:
-- - Run sql/00-1_create_app_schema.sql first.
-- - Run sql/00-2_promote_existing_user_to_admin.sql first.
-- - Optional: Run sql/01a_register_sample_members.sql after creating sample auth users.
-- - Sample user data is inserted only when the corresponding auth.users records exist.

BEGIN;

-- =========================================================
-- 1) roles
-- =========================================================
INSERT INTO public.roles (
  role_code,
  role_name,
  description,
  created_at,
  updated_at
) VALUES
(
  'admin',
  '管理者',
  '全機能へアクセスできるシステム管理者ロール',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  'editor',
  '編集者',
  'トップ表示や導線設定を更新する運用担当ロール',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  'operator',
  '受付担当',
  '予約・問い合わせ管理を中心に利用する担当者ロール',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
)
ON CONFLICT (role_code)
DO UPDATE SET
  role_name = EXCLUDED.role_name,
  description = EXCLUDED.description,
  updated_at = CURRENT_TIMESTAMP;

-- =========================================================
-- 2) stores
-- =========================================================
INSERT INTO public.stores (
  id,
  store_name,
  prefecture,
  address,
  business_hours,
  is_active,
  created_at,
  updated_at
) VALUES
(
  '66666661-6666-4666-8666-666666666661',
  'INIM 横浜みなとみらい',
  '神奈川県',
  '横浜市西区みなとみらい1-1-1',
  '10:00-19:00',
  true,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  '66666662-6666-4666-8666-666666666662',
  'INIM 表参道スタジオ',
  '東京都',
  '港区北青山3-3-3',
  '11:00-20:00',
  true,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  '66666663-6666-4666-8666-666666666663',
  'INIM 京都アトリエ',
  '京都府',
  '京都市中京区御池通2-2-2',
  '10:00-18:00',
  true,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
)
ON CONFLICT (id)
DO UPDATE SET
  store_name = EXCLUDED.store_name,
  prefecture = EXCLUDED.prefecture,
  address = EXCLUDED.address,
  business_hours = EXCLUDED.business_hours,
  is_active = EXCLUDED.is_active,
  updated_at = CURRENT_TIMESTAMP;

-- =========================================================
-- 3) content assets
-- =========================================================
WITH admin_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN public.user_role_assignments ura ON ura.user_profile_id = up.id
  JOIN public.roles r ON r.id = ura.role_id
  WHERE r.role_code = 'admin'
  ORDER BY up.created_at
  LIMIT 1
)
INSERT INTO public.content_assets (
  id,
  bucket_name,
  file_path,
  file_type,
  mime_type,
  alt_text,
  uploaded_by,
  created_at,
  updated_at
)
SELECT *
FROM (
  SELECT
    '77777771-7777-4777-8777-777777777771'::uuid AS id,
    'public-assets'::varchar(80) AS bucket_name,
    'hero/hero-01.jpg'::varchar(255) AS file_path,
    'image'::varchar(20) AS file_type,
    'image/jpeg'::varchar(80) AS mime_type,
    'メインビジュアル 1'::varchar(255) AS alt_text,
    ap.id AS uploaded_by,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
  FROM admin_profile ap
  UNION ALL
  SELECT
    '77777772-7777-4777-8777-777777777772'::uuid,
    'public-assets',
    'hero/hero-02.jpg',
    'image',
    'image/jpeg',
    'メインビジュアル 2',
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
  UNION ALL
  SELECT
    '77777773-7777-4777-8777-777777777773'::uuid,
    'public-assets',
    'hero/hero-03.jpg',
    'image',
    'image/jpeg',
    'メインビジュアル 3',
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
  UNION ALL
  SELECT
    '77777774-7777-4777-8777-777777777774'::uuid,
    'public-assets',
    'gallery/workshop-01.jpg',
    'image',
    'image/jpeg',
    'ワークショップ風景',
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
  UNION ALL
  SELECT
    '77777775-7777-4777-8777-777777777775'::uuid,
    'public-assets',
    'audio/brand-loop-01.mp3',
    'audio',
    'audio/mpeg',
    'ブランド紹介BGM',
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
) s
ON CONFLICT (id)
DO UPDATE SET
  bucket_name = EXCLUDED.bucket_name,
  file_path = EXCLUDED.file_path,
  file_type = EXCLUDED.file_type,
  mime_type = EXCLUDED.mime_type,
  alt_text = EXCLUDED.alt_text,
  uploaded_by = EXCLUDED.uploaded_by,
  updated_at = CURRENT_TIMESTAMP;

-- =========================================================
-- 4) top hero items
-- =========================================================
WITH admin_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN public.user_role_assignments ura ON ura.user_profile_id = up.id
  JOIN public.roles r ON r.id = ura.role_id
  WHERE r.role_code = 'admin'
  ORDER BY up.created_at
  LIMIT 1
)
INSERT INTO public.top_hero_items (
  id,
  title,
  lead_text,
  cta_label,
  cta_url,
  asset_id,
  display_order,
  is_active,
  updated_by,
  created_at,
  updated_at
)
SELECT *
FROM (
  SELECT
    '88888881-8888-4888-8888-888888888881'::uuid AS id,
    '香りから始まる体験を、もっと身近に。'::varchar(60) AS title,
    '初めての方でも気軽に参加できるワークショップ予約を促進する。'::varchar(160) AS lead_text,
    '体験を予約する'::varchar(20) AS cta_label,
    '/inim-dx/reserve.html'::varchar(255) AS cta_url,
    '77777771-7777-4777-8777-777777777771'::uuid AS asset_id,
    1::integer AS display_order,
    true AS is_active,
    ap.id AS updated_by,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
  FROM admin_profile ap
  UNION ALL
  SELECT
    '88888882-8888-4888-8888-888888888882'::uuid,
    'ギフト需要を高める季節の特集。',
    'ギフト提案と予約導線を一体化し、CV向上を狙う。',
    '特集を見る',
    '/inim-dx/gifts.html',
    '77777772-7777-4777-8777-777777777772'::uuid,
    2,
    true,
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
  UNION ALL
  SELECT
    '88888883-8888-4888-8888-888888888883'::uuid,
    '法人向けワークショップ相談受付中。',
    '問い合わせ導線を前面化し、B2B案件の獲得につなげる。',
    '相談する',
    '/inim-dx/contact.html',
    '77777773-7777-4777-8777-777777777773'::uuid,
    3,
    true,
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
) s
ON CONFLICT (id)
DO UPDATE SET
  title = EXCLUDED.title,
  lead_text = EXCLUDED.lead_text,
  cta_label = EXCLUDED.cta_label,
  cta_url = EXCLUDED.cta_url,
  asset_id = EXCLUDED.asset_id,
  display_order = EXCLUDED.display_order,
  is_active = EXCLUDED.is_active,
  updated_by = EXCLUDED.updated_by,
  updated_at = CURRENT_TIMESTAMP;

-- =========================================================
-- 5) journey steps
-- =========================================================
WITH admin_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN public.user_role_assignments ura ON ura.user_profile_id = up.id
  JOIN public.roles r ON r.id = ura.role_id
  WHERE r.role_code = 'admin'
  ORDER BY up.created_at
  LIMIT 1
)
INSERT INTO public.journey_steps (
  id,
  step_no,
  step_name,
  link_url,
  helper_text,
  is_visible,
  updated_by,
  created_at,
  updated_at
)
SELECT *
FROM (
  SELECT
    '99999991-9999-4999-8999-999999999991'::uuid AS id,
    1::integer AS step_no,
    'ブランドを知る'::varchar(30) AS step_name,
    '/inim-dx/about.html'::varchar(255) AS link_url,
    'INIM の世界観とサービス概要を案内'::varchar(80) AS helper_text,
    true AS is_visible,
    ap.id AS updated_by,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
  FROM admin_profile ap
  UNION ALL
  SELECT
    '99999992-9999-4999-8999-999999999992'::uuid,
    2,
    'メニューを選ぶ',
    '/inim-dx/menu.html',
    '体験メニューと所要時間を比較',
    true,
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
  UNION ALL
  SELECT
    '99999993-9999-4999-8999-999999999993'::uuid,
    3,
    '店舗を確認する',
    '/inim-dx/stores.html',
    'アクセスしやすい店舗を選択',
    true,
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
  UNION ALL
  SELECT
    '99999994-9999-4999-8999-999999999994'::uuid,
    4,
    '日程を予約する',
    '/inim-dx/reserve.html',
    '希望日時と人数を入力',
    true,
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
  UNION ALL
  SELECT
    '99999995-9999-4999-8999-999999999995'::uuid,
    5,
    '事前相談をする',
    '/inim-dx/contact.html',
    '不明点や法人相談を受付',
    true,
    ap.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM admin_profile ap
) s
ON CONFLICT (id)
DO UPDATE SET
  step_no = EXCLUDED.step_no,
  step_name = EXCLUDED.step_name,
  link_url = EXCLUDED.link_url,
  helper_text = EXCLUDED.helper_text,
  is_visible = EXCLUDED.is_visible,
  updated_by = EXCLUDED.updated_by,
  updated_at = CURRENT_TIMESTAMP;

-- =========================================================
-- 6) optional sample users based on existing auth.users
--    Replace emails below after creating users in Supabase Authentication.
-- =========================================================
WITH sample_users AS (
  SELECT
    au.id AS auth_user_id,
    au.email,
    CASE
      WHEN au.email = 'member01@inim-dx.example' THEN 'テストユーザーA'
      WHEN au.email = 'member02@inim-dx.example' THEN 'テストユーザーB'
      ELSE au.email
    END AS display_name
  FROM auth.users au
  WHERE au.email IN ('member01@inim-dx.example', 'member02@inim-dx.example')
)
INSERT INTO public.user_profiles (
  auth_user_id,
  display_name,
  account_status,
  last_login_at,
  created_at,
  updated_at
)
SELECT
  su.auth_user_id,
  su.display_name,
  'active',
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
FROM sample_users su
ON CONFLICT (auth_user_id)
DO UPDATE SET
  display_name = EXCLUDED.display_name,
  account_status = 'active',
  updated_at = CURRENT_TIMESTAMP;

WITH editor_role AS (
  SELECT id FROM public.roles WHERE role_code = 'editor'
),
operator_role AS (
  SELECT id FROM public.roles WHERE role_code = 'operator'
),
sample_profiles AS (
  SELECT up.id, au.email
  FROM public.user_profiles up
  JOIN auth.users au ON au.id = up.auth_user_id
  WHERE au.email IN ('member01@inim-dx.example', 'member02@inim-dx.example')
)
INSERT INTO public.user_role_assignments (
  user_profile_id,
  role_id,
  assigned_at,
  created_at,
  updated_at
)
SELECT
  sp.id,
  CASE
    WHEN sp.email = 'member01@inim-dx.example' THEN (SELECT id FROM editor_role)
    ELSE (SELECT id FROM operator_role)
  END,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
FROM sample_profiles sp
ON CONFLICT (user_profile_id, role_id)
DO UPDATE SET
  assigned_at = CURRENT_TIMESTAMP,
  updated_at = CURRENT_TIMESTAMP;

-- =========================================================
-- 7) bookings / enquiries / logs
--    Runs only when sample users exist.
-- =========================================================
WITH sample_profiles AS (
  SELECT up.id, au.email
  FROM public.user_profiles up
  JOIN auth.users au ON au.id = up.auth_user_id
  WHERE au.email IN ('member01@inim-dx.example', 'member02@inim-dx.example')
),
member01 AS (
  SELECT id FROM sample_profiles WHERE email = 'member01@inim-dx.example' LIMIT 1
),
member02 AS (
  SELECT id FROM sample_profiles WHERE email = 'member02@inim-dx.example' LIMIT 1
)
INSERT INTO public.bookings (
  id,
  customer_profile_id,
  store_id,
  booking_type,
  booked_at,
  participant_count,
  status,
  note,
  created_at,
  updated_at
)
SELECT *
FROM (
  SELECT
    'aaaa0001-0000-4000-8000-000000000001'::uuid AS id,
    (SELECT id FROM member01) AS customer_profile_id,
    '66666661-6666-4666-8666-666666666661'::uuid AS store_id,
    'workshop'::varchar(40) AS booking_type,
    '2026-04-05 11:00:00+09'::timestamptz AS booked_at,
    2::integer AS participant_count,
    'confirmed'::varchar(20) AS status,
    '初回来店のため香り診断を希望'::text AS note,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
  UNION ALL
  SELECT
    'aaaa0002-0000-4000-8000-000000000002'::uuid,
    (SELECT id FROM member02),
    '66666662-6666-4666-8666-666666666662'::uuid,
    'workshop',
    '2026-04-06 14:00:00+09'::timestamptz,
    1,
    'pending',
    'ギフト用途を検討中',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'aaaa0003-0000-4000-8000-000000000003'::uuid,
    (SELECT id FROM member01),
    '66666663-6666-4666-8666-666666666663'::uuid,
    'consultation',
    '2026-04-08 13:30:00+09'::timestamptz,
    3,
    'in_progress',
    '法人向け導入相談',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'aaaa0004-0000-4000-8000-000000000004'::uuid,
    (SELECT id FROM member02),
    '66666661-6666-4666-8666-666666666661'::uuid,
    'workshop',
    '2026-04-10 16:00:00+09'::timestamptz,
    2,
    'completed',
    'リピート予約',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'aaaa0005-0000-4000-8000-000000000005'::uuid,
    (SELECT id FROM member01),
    '66666662-6666-4666-8666-666666666662'::uuid,
    'workshop',
    '2026-04-12 10:30:00+09'::timestamptz,
    4,
    'cancelled',
    '日程都合により取消',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) s
WHERE s.customer_profile_id IS NOT NULL
ON CONFLICT (id)
DO UPDATE SET
  customer_profile_id = EXCLUDED.customer_profile_id,
  store_id = EXCLUDED.store_id,
  booking_type = EXCLUDED.booking_type,
  booked_at = EXCLUDED.booked_at,
  participant_count = EXCLUDED.participant_count,
  status = EXCLUDED.status,
  note = EXCLUDED.note,
  updated_at = CURRENT_TIMESTAMP;

WITH admin_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN public.user_role_assignments ura ON ura.user_profile_id = up.id
  JOIN public.roles r ON r.id = ura.role_id
  WHERE r.role_code = 'admin'
  ORDER BY up.created_at
  LIMIT 1
),
operator_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN auth.users au ON au.id = up.auth_user_id
  WHERE au.email = 'member02@inim-dx.example'
  LIMIT 1
),
member01 AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN auth.users au ON au.id = up.auth_user_id
  WHERE au.email = 'member01@inim-dx.example'
  LIMIT 1
)
INSERT INTO public.enquiries (
  id,
  customer_profile_id,
  category,
  subject,
  body,
  status,
  assigned_to,
  created_at,
  updated_at
)
SELECT *
FROM (
  SELECT
    'bbbb0001-0000-4000-8000-000000000001'::uuid AS id,
    (SELECT id FROM member01) AS customer_profile_id,
    'general'::varchar(40) AS category,
    '初回体験の流れを知りたい'::varchar(150) AS subject,
    '所要時間と当日の持ち物を教えてください。'::text AS body,
    'completed'::varchar(20) AS status,
    (SELECT id FROM operator_profile) AS assigned_to,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
  UNION ALL
  SELECT
    'bbbb0002-0000-4000-8000-000000000002'::uuid,
    NULL,
    'reservation',
    '予約変更は可能ですか',
    '4月6日の予約時間を変更したいです。',
    'pending',
    (SELECT id FROM operator_profile),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'bbbb0003-0000-4000-8000-000000000003'::uuid,
    NULL,
    'pricing',
    '法人向け料金の相談',
    '10名規模での開催費用の目安を知りたいです。',
    'in_progress',
    (SELECT id FROM admin_profile),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'bbbb0004-0000-4000-8000-000000000004'::uuid,
    NULL,
    'partnership',
    'コラボイベントのご相談',
    '商業施設との共同企画をご相談したいです。',
    'pending',
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'bbbb0005-0000-4000-8000-000000000005'::uuid,
    NULL,
    'media',
    '取材依頼',
    '新店舗体験会の取材可否をご確認ください。',
    'completed',
    (SELECT id FROM admin_profile),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) s
ON CONFLICT (id)
DO UPDATE SET
  customer_profile_id = EXCLUDED.customer_profile_id,
  category = EXCLUDED.category,
  subject = EXCLUDED.subject,
  body = EXCLUDED.body,
  status = EXCLUDED.status,
  assigned_to = EXCLUDED.assigned_to,
  updated_at = CURRENT_TIMESTAMP;

WITH admin_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN public.user_role_assignments ura ON ura.user_profile_id = up.id
  JOIN public.roles r ON r.id = ura.role_id
  WHERE r.role_code = 'admin'
  ORDER BY up.created_at
  LIMIT 1
),
operator_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN auth.users au ON au.id = up.auth_user_id
  WHERE au.email = 'member02@inim-dx.example'
  LIMIT 1
),
existing_bookings AS (
  SELECT id
  FROM public.bookings
  WHERE id IN (
    'aaaa0001-0000-4000-8000-000000000001'::uuid,
    'aaaa0003-0000-4000-8000-000000000003'::uuid,
    'aaaa0004-0000-4000-8000-000000000004'::uuid,
    'aaaa0005-0000-4000-8000-000000000005'::uuid
  )
)
INSERT INTO public.booking_status_logs (
  id,
  booking_id,
  previous_status,
  next_status,
  changed_by,
  change_note,
  created_at,
  updated_at
)
SELECT
  s.id,
  s.booking_id,
  s.previous_status,
  s.next_status,
  s.changed_by,
  s.change_note,
  s.created_at,
  s.updated_at
FROM (
  SELECT
    'cccc0001-0000-4000-8000-000000000001'::uuid AS id,
    'aaaa0001-0000-4000-8000-000000000001'::uuid AS booking_id,
    'pending'::varchar(20) AS previous_status,
    'confirmed'::varchar(20) AS next_status,
    (SELECT id FROM operator_profile) AS changed_by,
    '空き枠確認後に確定'::text AS change_note,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
  UNION ALL
  SELECT
    'cccc0002-0000-4000-8000-000000000002'::uuid,
    'aaaa0003-0000-4000-8000-000000000003'::uuid,
    'pending',
    'in_progress',
    (SELECT id FROM admin_profile),
    '法人相談としてヒアリング開始',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'cccc0003-0000-4000-8000-000000000003'::uuid,
    'aaaa0004-0000-4000-8000-000000000004'::uuid,
    'confirmed',
    'completed',
    (SELECT id FROM operator_profile),
    '来店対応完了',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'cccc0004-0000-4000-8000-000000000004'::uuid,
    'aaaa0005-0000-4000-8000-000000000005'::uuid,
    'pending',
    'cancelled',
    (SELECT id FROM operator_profile),
    '顧客都合でキャンセル受付',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) s
JOIN existing_bookings er ON er.id = s.booking_id
WHERE s.changed_by IS NOT NULL
ON CONFLICT (id)
DO UPDATE SET
  booking_id = EXCLUDED.booking_id,
  previous_status = EXCLUDED.previous_status,
  next_status = EXCLUDED.next_status,
  changed_by = EXCLUDED.changed_by,
  change_note = EXCLUDED.change_note,
  updated_at = CURRENT_TIMESTAMP;

WITH admin_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN public.user_role_assignments ura ON ura.user_profile_id = up.id
  JOIN public.roles r ON r.id = ura.role_id
  WHERE r.role_code = 'admin'
  ORDER BY up.created_at
  LIMIT 1
),
operator_profile AS (
  SELECT up.id
  FROM public.user_profiles up
  JOIN auth.users au ON au.id = up.auth_user_id
  WHERE au.email = 'member02@inim-dx.example'
  LIMIT 1
),
existing_enquiries AS (
  SELECT id
  FROM public.enquiries
  WHERE id IN (
    'bbbb0001-0000-4000-8000-000000000001'::uuid,
    'bbbb0003-0000-4000-8000-000000000003'::uuid,
    'bbbb0005-0000-4000-8000-000000000005'::uuid
  )
)
INSERT INTO public.enquiry_status_logs (
  id,
  enquiry_id,
  previous_status,
  next_status,
  changed_by,
  change_note,
  created_at,
  updated_at
)
SELECT
  s.id,
  s.enquiry_id,
  s.previous_status,
  s.next_status,
  s.changed_by,
  s.change_note,
  s.created_at,
  s.updated_at
FROM (
  SELECT
    'dddd0001-0000-4000-8000-000000000001'::uuid AS id,
    'bbbb0001-0000-4000-8000-000000000001'::uuid AS enquiry_id,
    'pending'::varchar(20) AS previous_status,
    'completed'::varchar(20) AS next_status,
    (SELECT id FROM operator_profile) AS changed_by,
    'FAQ案内を送付して解決'::text AS change_note,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
  UNION ALL
  SELECT
    'dddd0002-0000-4000-8000-000000000002'::uuid,
    'bbbb0003-0000-4000-8000-000000000003'::uuid,
    'pending',
    'in_progress',
    (SELECT id FROM admin_profile),
    '法人ヒアリング日程を調整中',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  UNION ALL
  SELECT
    'dddd0003-0000-4000-8000-000000000003'::uuid,
    'bbbb0005-0000-4000-8000-000000000005'::uuid,
    'pending',
    'completed',
    (SELECT id FROM admin_profile),
    '広報窓口へ引継ぎ、返信完了',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) s
JOIN existing_enquiries ei ON ei.id = s.enquiry_id
WHERE s.changed_by IS NOT NULL
ON CONFLICT (id)
DO UPDATE SET
  enquiry_id = EXCLUDED.enquiry_id,
  previous_status = EXCLUDED.previous_status,
  next_status = EXCLUDED.next_status,
  changed_by = EXCLUDED.changed_by,
  change_note = EXCLUDED.change_note,
  updated_at = CURRENT_TIMESTAMP;

COMMIT;
