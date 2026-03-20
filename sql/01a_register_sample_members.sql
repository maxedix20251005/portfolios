-- inim-dx / register sample member01 and member02 into application tables
-- Prerequisite:
-- - Create these users first in Supabase Authentication > Users:
--   - member01@inim-dx.example
--   - member02@inim-dx.example
-- - Run sql/00_create_app_schema.sql first.
-- - Run sql/00_promote_existing_user_to_admin.sql first.

BEGIN;

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

COMMIT;
