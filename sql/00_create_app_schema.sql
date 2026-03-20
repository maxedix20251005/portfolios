-- inim-dx / application schema bootstrap for Supabase
-- Run this before promote/seed scripts.

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id),
  display_name VARCHAR(80) NOT NULL,
  account_status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (account_status IN ('active', 'invited', 'suspended', 'withdrawn')),
  last_login_at TIMESTAMPTZ NULL,
  deleted_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  role_code VARCHAR(40) NOT NULL UNIQUE,
  role_name VARCHAR(80) NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.user_role_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_profile_id UUID NOT NULL REFERENCES public.user_profiles(id),
  role_id UUID NOT NULL REFERENCES public.roles(id),
  assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_user_role_assignments_user_role UNIQUE (user_profile_id, role_id)
);

CREATE TABLE IF NOT EXISTS public.content_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bucket_name VARCHAR(80) NOT NULL DEFAULT 'public-assets',
  file_path VARCHAR(255) NOT NULL UNIQUE,
  file_type VARCHAR(20) NOT NULL,
  mime_type VARCHAR(80) NULL,
  alt_text VARCHAR(255) NULL,
  uploaded_by UUID NULL REFERENCES public.user_profiles(id),
  deleted_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.top_hero_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(60) NOT NULL,
  lead_text VARCHAR(160) NOT NULL,
  cta_label VARCHAR(20) NOT NULL,
  cta_url VARCHAR(255) NOT NULL,
  asset_id UUID NULL REFERENCES public.content_assets(id),
  display_order INTEGER NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  updated_by UUID NULL REFERENCES public.user_profiles(id),
  deleted_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.journey_steps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  step_no INTEGER NOT NULL UNIQUE,
  step_name VARCHAR(30) NOT NULL,
  link_url VARCHAR(255) NOT NULL,
  helper_text VARCHAR(80) NULL,
  is_visible BOOLEAN NOT NULL DEFAULT true,
  updated_by UUID NULL REFERENCES public.user_profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_name VARCHAR(120) NOT NULL,
  prefecture VARCHAR(40) NULL,
  address VARCHAR(255) NULL,
  business_hours VARCHAR(120) NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  deleted_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.reservations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_profile_id UUID NOT NULL REFERENCES public.user_profiles(id),
  store_id UUID NOT NULL REFERENCES public.stores(id),
  reservation_type VARCHAR(40) NOT NULL DEFAULT 'workshop',
  reserved_at TIMESTAMPTZ NOT NULL,
  participant_count INTEGER NOT NULL DEFAULT 1 CHECK (participant_count >= 1),
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled')),
  note TEXT NULL,
  deleted_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.inquiries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_profile_id UUID NULL REFERENCES public.user_profiles(id),
  category VARCHAR(40) NOT NULL DEFAULT 'general',
  subject VARCHAR(150) NOT NULL,
  body TEXT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')),
  assigned_to UUID NULL REFERENCES public.user_profiles(id),
  deleted_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.reservation_status_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reservation_id UUID NOT NULL REFERENCES public.reservations(id),
  previous_status VARCHAR(20) NULL,
  next_status VARCHAR(20) NOT NULL,
  changed_by UUID NULL REFERENCES public.user_profiles(id),
  change_note TEXT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.inquiry_status_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  inquiry_id UUID NOT NULL REFERENCES public.inquiries(id),
  previous_status VARCHAR(20) NULL,
  next_status VARCHAR(20) NOT NULL,
  changed_by UUID NULL REFERENCES public.user_profiles(id),
  change_note TEXT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_top_hero_items_display_order_active
  ON public.top_hero_items (display_order)
  WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_user_profiles_display_name
  ON public.user_profiles (display_name);

CREATE INDEX IF NOT EXISTS idx_user_profiles_account_status
  ON public.user_profiles (account_status);

CREATE INDEX IF NOT EXISTS idx_user_role_assignments_user_profile_id
  ON public.user_role_assignments (user_profile_id);

CREATE INDEX IF NOT EXISTS idx_user_role_assignments_role_id
  ON public.user_role_assignments (role_id);

CREATE INDEX IF NOT EXISTS idx_content_assets_uploaded_by
  ON public.content_assets (uploaded_by);

CREATE INDEX IF NOT EXISTS idx_content_assets_file_type
  ON public.content_assets (file_type);

CREATE INDEX IF NOT EXISTS idx_top_hero_items_asset_id
  ON public.top_hero_items (asset_id);

CREATE INDEX IF NOT EXISTS idx_top_hero_items_is_active_display_order
  ON public.top_hero_items (is_active, display_order);

CREATE INDEX IF NOT EXISTS idx_journey_steps_is_visible_step_no
  ON public.journey_steps (is_visible, step_no);

CREATE INDEX IF NOT EXISTS idx_stores_is_active
  ON public.stores (is_active);

CREATE INDEX IF NOT EXISTS idx_stores_store_name
  ON public.stores (store_name);

CREATE INDEX IF NOT EXISTS idx_reservations_customer_profile_id
  ON public.reservations (customer_profile_id);

CREATE INDEX IF NOT EXISTS idx_reservations_store_id
  ON public.reservations (store_id);

CREATE INDEX IF NOT EXISTS idx_reservations_status_reserved_at
  ON public.reservations (status, reserved_at);

CREATE INDEX IF NOT EXISTS idx_reservations_reserved_at
  ON public.reservations (reserved_at);

CREATE INDEX IF NOT EXISTS idx_inquiries_customer_profile_id
  ON public.inquiries (customer_profile_id);

CREATE INDEX IF NOT EXISTS idx_inquiries_assigned_to
  ON public.inquiries (assigned_to);

CREATE INDEX IF NOT EXISTS idx_inquiries_status_created_at
  ON public.inquiries (status, created_at);

CREATE INDEX IF NOT EXISTS idx_reservation_status_logs_reservation_id
  ON public.reservation_status_logs (reservation_id);

CREATE INDEX IF NOT EXISTS idx_reservation_status_logs_changed_by
  ON public.reservation_status_logs (changed_by);

CREATE INDEX IF NOT EXISTS idx_reservation_status_logs_created_at
  ON public.reservation_status_logs (created_at);

CREATE INDEX IF NOT EXISTS idx_inquiry_status_logs_inquiry_id
  ON public.inquiry_status_logs (inquiry_id);

CREATE INDEX IF NOT EXISTS idx_inquiry_status_logs_changed_by
  ON public.inquiry_status_logs (changed_by);

CREATE INDEX IF NOT EXISTS idx_inquiry_status_logs_created_at
  ON public.inquiry_status_logs (created_at);

COMMIT;
