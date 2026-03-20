-- inim-dx / existing auth user promotion to application admin
-- Usage:
-- 0. Run sql/00_create_app_schema.sql first.
-- 1. Replace the target email in the params CTE.
-- 2. Run this SQL in Supabase SQL Editor after the target user exists in Authentication > Users.
-- 3. This script creates/updates:
--    - public.user_profiles
--    - public.roles
--    - public.user_role_assignments

BEGIN;

WITH params AS (
  SELECT
    'chukai.namba@gmail.com'::text AS target_email,
    '運営管理者'::text AS display_name
),
target_user AS (
  SELECT
    au.id AS auth_user_id,
    p.display_name
  FROM auth.users au
  CROSS JOIN params p
  WHERE au.email = p.target_email
),
upsert_profile AS (
  INSERT INTO public.user_profiles (
    auth_user_id,
    display_name,
    account_status,
    last_login_at,
    created_at,
    updated_at
  )
  SELECT
    tu.auth_user_id,
    tu.display_name,
    'active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM target_user tu
  ON CONFLICT (auth_user_id)
  DO UPDATE SET
    display_name = EXCLUDED.display_name,
    account_status = 'active',
    updated_at = CURRENT_TIMESTAMP
  RETURNING id, auth_user_id
),
upsert_role AS (
  INSERT INTO public.roles (
    role_code,
    role_name,
    description,
    created_at,
    updated_at
  )
  VALUES (
    'admin',
    '管理者',
    '全機能へアクセスできるシステム管理者ロール',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  )
  ON CONFLICT (role_code)
  DO UPDATE SET
    role_name = EXCLUDED.role_name,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP
  RETURNING id
)
INSERT INTO public.user_role_assignments (
  user_profile_id,
  role_id,
  assigned_at,
  created_at,
  updated_at
)
SELECT
  up.id,
  r.id,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
FROM upsert_profile up
CROSS JOIN upsert_role r
ON CONFLICT (user_profile_id, role_id)
DO UPDATE SET
  assigned_at = CURRENT_TIMESTAMP,
  updated_at = CURRENT_TIMESTAMP;

COMMIT;
