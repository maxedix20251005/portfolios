-- inim-dx / migration for reservation/inquiry table renaming
-- Purpose:
-- - reservations            -> bookings
-- - reservation_status_logs -> booking_status_logs
-- - inquiries               -> enquiries
-- - inquiry_status_logs     -> enquiry_status_logs
-- - reservation_type        -> booking_type
-- - reserved_at             -> booked_at
-- - reservation_id          -> booking_id
-- - inquiry_id              -> enquiry_id
--
-- Recommended usage:
-- 1. Take a backup or snapshot in Supabase before running.
-- 2. Run this only on an environment that still has the old names.
-- 3. After running, apply sql/03_rls_policies.sql again.
-- 4. Then run sql/02_verify_seed_data.sql with the updated names.

BEGIN;

-- =========================================================
-- 1) Drop old RLS policies before renaming
-- =========================================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'reservations'
  ) THEN
    EXECUTE 'DROP POLICY IF EXISTS reservations_select_own_or_management ON public.reservations';
    EXECUTE 'DROP POLICY IF EXISTS reservations_insert_own_or_management ON public.reservations';
    EXECUTE 'DROP POLICY IF EXISTS reservations_update_own_or_management ON public.reservations';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'inquiries'
  ) THEN
    EXECUTE 'DROP POLICY IF EXISTS inquiries_select_own_or_management ON public.inquiries';
    EXECUTE 'DROP POLICY IF EXISTS inquiries_insert_anon_or_own ON public.inquiries';
    EXECUTE 'DROP POLICY IF EXISTS inquiries_update_management ON public.inquiries';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'reservation_status_logs'
  ) THEN
    EXECUTE 'DROP POLICY IF EXISTS reservation_status_logs_select_management ON public.reservation_status_logs';
    EXECUTE 'DROP POLICY IF EXISTS reservation_status_logs_insert_management ON public.reservation_status_logs';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'inquiry_status_logs'
  ) THEN
    EXECUTE 'DROP POLICY IF EXISTS inquiry_status_logs_select_management ON public.inquiry_status_logs';
    EXECUTE 'DROP POLICY IF EXISTS inquiry_status_logs_insert_management ON public.inquiry_status_logs';
  END IF;
END $$;

-- =========================================================
-- 2) Rename base tables
-- =========================================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'reservations'
  ) AND NOT EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'bookings'
  ) THEN
    ALTER TABLE public.reservations RENAME TO bookings;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'inquiries'
  ) AND NOT EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'enquiries'
  ) THEN
    ALTER TABLE public.inquiries RENAME TO enquiries;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'reservation_status_logs'
  ) AND NOT EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'booking_status_logs'
  ) THEN
    ALTER TABLE public.reservation_status_logs RENAME TO booking_status_logs;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'inquiry_status_logs'
  ) AND NOT EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relnamespace = 'public'::regnamespace
      AND relname = 'enquiry_status_logs'
  ) THEN
    ALTER TABLE public.inquiry_status_logs RENAME TO enquiry_status_logs;
  END IF;
END $$;

-- =========================================================
-- 3) Rename columns
-- =========================================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'bookings'
      AND column_name = 'reservation_type'
  ) THEN
    ALTER TABLE public.bookings RENAME COLUMN reservation_type TO booking_type;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'bookings'
      AND column_name = 'reserved_at'
  ) THEN
    ALTER TABLE public.bookings RENAME COLUMN reserved_at TO booked_at;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'booking_status_logs'
      AND column_name = 'reservation_id'
  ) THEN
    ALTER TABLE public.booking_status_logs RENAME COLUMN reservation_id TO booking_id;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'enquiry_status_logs'
      AND column_name = 'inquiry_id'
  ) THEN
    ALTER TABLE public.enquiry_status_logs RENAME COLUMN inquiry_id TO enquiry_id;
  END IF;
END $$;

-- =========================================================
-- 4) Rename constraints to match the new naming
-- =========================================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'reservation_status_logs_reservation_id_fkey'
  ) THEN
    ALTER TABLE public.booking_status_logs
      RENAME CONSTRAINT reservation_status_logs_reservation_id_fkey
      TO booking_status_logs_booking_id_fkey;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'inquiry_status_logs_inquiry_id_fkey'
  ) THEN
    ALTER TABLE public.enquiry_status_logs
      RENAME CONSTRAINT inquiry_status_logs_inquiry_id_fkey
      TO enquiry_status_logs_enquiry_id_fkey;
  END IF;
END $$;

-- =========================================================
-- 5) Rename custom indexes
-- =========================================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_reservations_customer_profile_id')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_bookings_customer_profile_id') THEN
    ALTER INDEX public.idx_reservations_customer_profile_id RENAME TO idx_bookings_customer_profile_id;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_reservations_store_id')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_bookings_store_id') THEN
    ALTER INDEX public.idx_reservations_store_id RENAME TO idx_bookings_store_id;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_reservations_status_reserved_at')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_bookings_status_booked_at') THEN
    ALTER INDEX public.idx_reservations_status_reserved_at RENAME TO idx_bookings_status_booked_at;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_reservations_reserved_at')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_bookings_booked_at') THEN
    ALTER INDEX public.idx_reservations_reserved_at RENAME TO idx_bookings_booked_at;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_inquiries_customer_profile_id')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_enquiries_customer_profile_id') THEN
    ALTER INDEX public.idx_inquiries_customer_profile_id RENAME TO idx_enquiries_customer_profile_id;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_inquiries_assigned_to')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_enquiries_assigned_to') THEN
    ALTER INDEX public.idx_inquiries_assigned_to RENAME TO idx_enquiries_assigned_to;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_inquiries_status_created_at')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_enquiries_status_created_at') THEN
    ALTER INDEX public.idx_inquiries_status_created_at RENAME TO idx_enquiries_status_created_at;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_reservation_status_logs_reservation_id')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_booking_status_logs_booking_id') THEN
    ALTER INDEX public.idx_reservation_status_logs_reservation_id RENAME TO idx_booking_status_logs_booking_id;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_reservation_status_logs_changed_by')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_booking_status_logs_changed_by') THEN
    ALTER INDEX public.idx_reservation_status_logs_changed_by RENAME TO idx_booking_status_logs_changed_by;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_reservation_status_logs_created_at')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_booking_status_logs_created_at') THEN
    ALTER INDEX public.idx_reservation_status_logs_created_at RENAME TO idx_booking_status_logs_created_at;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_inquiry_status_logs_inquiry_id')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_enquiry_status_logs_enquiry_id') THEN
    ALTER INDEX public.idx_inquiry_status_logs_inquiry_id RENAME TO idx_enquiry_status_logs_enquiry_id;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_inquiry_status_logs_changed_by')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_enquiry_status_logs_changed_by') THEN
    ALTER INDEX public.idx_inquiry_status_logs_changed_by RENAME TO idx_enquiry_status_logs_changed_by;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_inquiry_status_logs_created_at')
     AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'i' AND relname = 'idx_enquiry_status_logs_created_at') THEN
    ALTER INDEX public.idx_inquiry_status_logs_created_at RENAME TO idx_enquiry_status_logs_created_at;
  END IF;
END $$;

-- =========================================================
-- 6) Ensure RLS remains enabled on the new names
-- =========================================================
ALTER TABLE IF EXISTS public.bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.enquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.booking_status_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.enquiry_status_logs ENABLE ROW LEVEL SECURITY;

COMMIT;

-- Next step:
-- Re-run sql/03_rls_policies.sql after this migration to create policies with the new names.
