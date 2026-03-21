-- inim-dx / Supabase RLS and authorization policies
-- Prerequisite:
-- - Run sql/00-1_create_app_schema.sql first.
-- - Run sql/00-2_promote_existing_user_to_admin.sql first.
-- - Run sql/01_seed_core_data.sql first.
--
-- Policy concept:
-- - Public site can read only published content.
-- - Management roles are controlled by public.roles / public.user_role_assignments.
-- - admin: full management access
-- - editor: content editing access
-- - operator: booking/enquiry operations access
-- - customer/authenticated user: own bookings / own enquiries only
-- - anonymous user: enquiry insert only (customer_profile_id must be NULL)

BEGIN;

-- =========================================================
-- 1) Helper functions
-- =========================================================
CREATE OR REPLACE FUNCTION public.current_user_profile_id()
RETURNS uuid
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT up.id
  FROM public.user_profiles up
  WHERE up.auth_user_id = auth.uid()
    AND up.deleted_at IS NULL
  LIMIT 1
$$;

CREATE OR REPLACE FUNCTION public.has_role(target_role text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_profiles up
    JOIN public.user_role_assignments ura
      ON ura.user_profile_id = up.id
    JOIN public.roles r
      ON r.id = ura.role_id
    WHERE up.auth_user_id = auth.uid()
      AND up.deleted_at IS NULL
      AND r.role_code = target_role
  )
$$;

CREATE OR REPLACE FUNCTION public.has_any_role(target_roles text[])
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_profiles up
    JOIN public.user_role_assignments ura
      ON ura.user_profile_id = up.id
    JOIN public.roles r
      ON r.id = ura.role_id
    WHERE up.auth_user_id = auth.uid()
      AND up.deleted_at IS NULL
      AND r.role_code = ANY(target_roles)
  )
$$;

GRANT EXECUTE ON FUNCTION public.current_user_profile_id() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.has_role(text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.has_any_role(text[]) TO anon, authenticated;

-- =========================================================
-- 2) Enable RLS
-- =========================================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_role_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.top_hero_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.journey_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.booking_status_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enquiry_status_logs ENABLE ROW LEVEL SECURITY;

-- =========================================================
-- 3) Drop old policies if rerun
-- =========================================================
DROP POLICY IF EXISTS user_profiles_select_own_or_admin ON public.user_profiles;
DROP POLICY IF EXISTS user_profiles_update_admin_only ON public.user_profiles;

DROP POLICY IF EXISTS roles_select_management ON public.roles;
DROP POLICY IF EXISTS roles_write_admin_only ON public.roles;

DROP POLICY IF EXISTS user_role_assignments_select_management ON public.user_role_assignments;
DROP POLICY IF EXISTS user_role_assignments_write_admin_only ON public.user_role_assignments;

DROP POLICY IF EXISTS content_assets_public_read ON public.content_assets;
DROP POLICY IF EXISTS content_assets_select_management ON public.content_assets;
DROP POLICY IF EXISTS content_assets_write_editor_admin ON public.content_assets;

DROP POLICY IF EXISTS top_hero_items_public_read ON public.top_hero_items;
DROP POLICY IF EXISTS top_hero_items_select_management ON public.top_hero_items;
DROP POLICY IF EXISTS top_hero_items_write_editor_admin ON public.top_hero_items;

DROP POLICY IF EXISTS journey_steps_public_read ON public.journey_steps;
DROP POLICY IF EXISTS journey_steps_select_management ON public.journey_steps;
DROP POLICY IF EXISTS journey_steps_write_editor_admin ON public.journey_steps;

DROP POLICY IF EXISTS stores_public_read ON public.stores;
DROP POLICY IF EXISTS stores_select_management ON public.stores;
DROP POLICY IF EXISTS stores_write_admin_operator ON public.stores;

DROP POLICY IF EXISTS bookings_select_own_or_management ON public.bookings;
DROP POLICY IF EXISTS bookings_insert_own_or_management ON public.bookings;
DROP POLICY IF EXISTS bookings_update_own_or_management ON public.bookings;

DROP POLICY IF EXISTS enquiries_select_own_or_management ON public.enquiries;
DROP POLICY IF EXISTS enquiries_insert_anon_or_own ON public.enquiries;
DROP POLICY IF EXISTS enquiries_update_management ON public.enquiries;

DROP POLICY IF EXISTS booking_status_logs_select_management ON public.booking_status_logs;
DROP POLICY IF EXISTS booking_status_logs_insert_management ON public.booking_status_logs;

DROP POLICY IF EXISTS enquiry_status_logs_select_management ON public.enquiry_status_logs;
DROP POLICY IF EXISTS enquiry_status_logs_insert_management ON public.enquiry_status_logs;

-- =========================================================
-- 4) Policies
-- =========================================================

-- user_profiles
CREATE POLICY user_profiles_select_own_or_admin
ON public.user_profiles
FOR SELECT
TO authenticated
USING (
  auth_user_id = auth.uid()
  OR public.has_role('admin')
);

CREATE POLICY user_profiles_update_admin_only
ON public.user_profiles
FOR UPDATE
TO authenticated
USING (public.has_role('admin'))
WITH CHECK (public.has_role('admin'));

-- roles
CREATE POLICY roles_select_management
ON public.roles
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor', 'operator']));

CREATE POLICY roles_write_admin_only
ON public.roles
FOR ALL
TO authenticated
USING (public.has_role('admin'))
WITH CHECK (public.has_role('admin'));

-- user_role_assignments
CREATE POLICY user_role_assignments_select_management
ON public.user_role_assignments
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor', 'operator']));

CREATE POLICY user_role_assignments_write_admin_only
ON public.user_role_assignments
FOR ALL
TO authenticated
USING (public.has_role('admin'))
WITH CHECK (public.has_role('admin'));

-- content_assets
CREATE POLICY content_assets_public_read
ON public.content_assets
FOR SELECT
TO anon, authenticated
USING (deleted_at IS NULL);

CREATE POLICY content_assets_select_management
ON public.content_assets
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor', 'operator']));

CREATE POLICY content_assets_write_editor_admin
ON public.content_assets
FOR ALL
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor']))
WITH CHECK (public.has_any_role(ARRAY['admin', 'editor']));

-- top_hero_items
CREATE POLICY top_hero_items_public_read
ON public.top_hero_items
FOR SELECT
TO anon, authenticated
USING (deleted_at IS NULL AND is_active = true);

CREATE POLICY top_hero_items_select_management
ON public.top_hero_items
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor', 'operator']));

CREATE POLICY top_hero_items_write_editor_admin
ON public.top_hero_items
FOR ALL
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor']))
WITH CHECK (public.has_any_role(ARRAY['admin', 'editor']));

-- journey_steps
CREATE POLICY journey_steps_public_read
ON public.journey_steps
FOR SELECT
TO anon, authenticated
USING (is_visible = true);

CREATE POLICY journey_steps_select_management
ON public.journey_steps
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor', 'operator']));

CREATE POLICY journey_steps_write_editor_admin
ON public.journey_steps
FOR ALL
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor']))
WITH CHECK (public.has_any_role(ARRAY['admin', 'editor']));

-- stores
CREATE POLICY stores_public_read
ON public.stores
FOR SELECT
TO anon, authenticated
USING (deleted_at IS NULL AND is_active = true);

CREATE POLICY stores_select_management
ON public.stores
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'editor', 'operator']));

CREATE POLICY stores_write_admin_operator
ON public.stores
FOR ALL
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'operator']))
WITH CHECK (public.has_any_role(ARRAY['admin', 'operator']));

-- bookings
CREATE POLICY bookings_select_own_or_management
ON public.bookings
FOR SELECT
TO authenticated
USING (
  customer_profile_id = public.current_user_profile_id()
  OR public.has_any_role(ARRAY['admin', 'operator'])
);

CREATE POLICY bookings_insert_own_or_management
ON public.bookings
FOR INSERT
TO authenticated
WITH CHECK (
  customer_profile_id = public.current_user_profile_id()
  OR public.has_any_role(ARRAY['admin', 'operator'])
);

CREATE POLICY bookings_update_own_or_management
ON public.bookings
FOR UPDATE
TO authenticated
USING (
  customer_profile_id = public.current_user_profile_id()
  OR public.has_any_role(ARRAY['admin', 'operator'])
)
WITH CHECK (
  customer_profile_id = public.current_user_profile_id()
  OR public.has_any_role(ARRAY['admin', 'operator'])
);

-- enquiries
CREATE POLICY enquiries_select_own_or_management
ON public.enquiries
FOR SELECT
TO authenticated
USING (
  customer_profile_id = public.current_user_profile_id()
  OR public.has_any_role(ARRAY['admin', 'operator'])
);

CREATE POLICY enquiries_insert_anon_or_own
ON public.enquiries
FOR INSERT
TO anon, authenticated
WITH CHECK (
  (
    auth.uid() IS NULL
    AND customer_profile_id IS NULL
    AND status = 'pending'
  )
  OR (
    auth.uid() IS NOT NULL
    AND (
      customer_profile_id = public.current_user_profile_id()
      OR public.has_any_role(ARRAY['admin', 'operator'])
      OR customer_profile_id IS NULL
    )
  )
);

CREATE POLICY enquiries_update_management
ON public.enquiries
FOR UPDATE
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'operator']))
WITH CHECK (public.has_any_role(ARRAY['admin', 'operator']));

-- booking_status_logs
CREATE POLICY booking_status_logs_select_management
ON public.booking_status_logs
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'operator']));

CREATE POLICY booking_status_logs_insert_management
ON public.booking_status_logs
FOR INSERT
TO authenticated
WITH CHECK (public.has_any_role(ARRAY['admin', 'operator']));

-- enquiry_status_logs
CREATE POLICY enquiry_status_logs_select_management
ON public.enquiry_status_logs
FOR SELECT
TO authenticated
USING (public.has_any_role(ARRAY['admin', 'operator']));

CREATE POLICY enquiry_status_logs_insert_management
ON public.enquiry_status_logs
FOR INSERT
TO authenticated
WITH CHECK (public.has_any_role(ARRAY['admin', 'operator']));

COMMIT;
