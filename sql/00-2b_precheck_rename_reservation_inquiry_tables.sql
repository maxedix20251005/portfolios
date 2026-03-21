-- inim-dx / precheck before reservation/inquiry rename migration
-- Purpose:
-- - Confirm the environment still uses the old table names.
-- - Confirm the rename target names do not already exist.
-- - Confirm old columns and old indexes are present before running:
--   sql/00-3_rename_reservation_inquiry_tables.sql

-- =========================================================
-- A) old/new table existence
-- =========================================================
select
  table_name,
  case when exists (
    select 1
    from information_schema.tables
    where table_schema = 'public'
      and table_name = t.table_name
  ) then 'exists' else 'missing' end as status
from (
  values
    ('reservations'),
    ('reservation_status_logs'),
    ('inquiries'),
    ('inquiry_status_logs'),
    ('bookings'),
    ('booking_status_logs'),
    ('enquiries'),
    ('enquiry_status_logs')
) as t(table_name)
order by table_name;

-- Expected before migration:
-- - old names  = exists
-- - new names  = missing

-- =========================================================
-- B) row counts on old tables
-- =========================================================
select 'reservations' as table_name, count(*) from public.reservations
union all
select 'reservation_status_logs', count(*) from public.reservation_status_logs
union all
select 'inquiries', count(*) from public.inquiries
union all
select 'inquiry_status_logs', count(*) from public.inquiry_status_logs;

-- Keep this result for comparison after migration.

-- =========================================================
-- C) old column existence
-- =========================================================
select
  table_name,
  column_name,
  data_type
from information_schema.columns
where table_schema = 'public'
  and (
    (table_name = 'reservations' and column_name in ('reservation_type', 'reserved_at'))
    or
    (table_name = 'reservation_status_logs' and column_name in ('reservation_id'))
    or
    (table_name = 'inquiry_status_logs' and column_name in ('inquiry_id'))
  )
order by table_name, column_name;

-- Expected before migration:
-- - reservations.reservation_type
-- - reservations.reserved_at
-- - reservation_status_logs.reservation_id
-- - inquiry_status_logs.inquiry_id

-- =========================================================
-- D) old indexes existence
-- =========================================================
select
  indexname
from pg_indexes
where schemaname = 'public'
  and indexname in (
    'idx_reservations_customer_profile_id',
    'idx_reservations_store_id',
    'idx_reservations_status_reserved_at',
    'idx_reservations_reserved_at',
    'idx_inquiries_customer_profile_id',
    'idx_inquiries_assigned_to',
    'idx_inquiries_status_created_at',
    'idx_reservation_status_logs_reservation_id',
    'idx_reservation_status_logs_changed_by',
    'idx_reservation_status_logs_created_at',
    'idx_inquiry_status_logs_inquiry_id',
    'idx_inquiry_status_logs_changed_by',
    'idx_inquiry_status_logs_created_at'
  )
order by indexname;

-- =========================================================
-- E) old policies existence
-- =========================================================
select
  tablename,
  policyname
from pg_policies
where schemaname = 'public'
  and policyname in (
    'reservations_select_own_or_management',
    'reservations_insert_own_or_management',
    'reservations_update_own_or_management',
    'inquiries_select_own_or_management',
    'inquiries_insert_anon_or_own',
    'inquiries_update_management',
    'reservation_status_logs_select_management',
    'reservation_status_logs_insert_management',
    'inquiry_status_logs_select_management',
    'inquiry_status_logs_insert_management'
  )
order by tablename, policyname;

-- =========================================================
-- F) execution guide
-- =========================================================
-- If the precheck matches expectations:
-- 1. Run sql/00-3_rename_reservation_inquiry_tables.sql
-- 2. Run sql/03_rls_policies.sql
-- 3. Run sql/02_verify_seed_data.sql
