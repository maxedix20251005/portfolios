-- inim-dx / postcheck after reservation/inquiry rename migration
-- Run after:
-- 1. sql/00-3_rename_reservation_inquiry_tables.sql
-- 2. sql/03_rls_policies.sql

-- =========================================================
-- A) new/old table existence
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

-- Expected after migration:
-- - old names  = missing
-- - new names  = exists

-- =========================================================
-- B) row counts on new tables
-- =========================================================
select 'bookings' as table_name, count(*) from public.bookings
union all
select 'booking_status_logs', count(*) from public.booking_status_logs
union all
select 'enquiries', count(*) from public.enquiries
union all
select 'enquiry_status_logs', count(*) from public.enquiry_status_logs;

-- Compare these counts against the precheck result.

-- =========================================================
-- C) new column existence
-- =========================================================
select
  table_name,
  column_name,
  data_type
from information_schema.columns
where table_schema = 'public'
  and (
    (table_name = 'bookings' and column_name in ('booking_type', 'booked_at'))
    or
    (table_name = 'booking_status_logs' and column_name in ('booking_id'))
    or
    (table_name = 'enquiry_status_logs' and column_name in ('enquiry_id'))
  )
order by table_name, column_name;

-- Expected after migration:
-- - bookings.booking_type
-- - bookings.booked_at
-- - booking_status_logs.booking_id
-- - enquiry_status_logs.enquiry_id

-- =========================================================
-- D) new index existence
-- =========================================================
select
  indexname
from pg_indexes
where schemaname = 'public'
  and indexname in (
    'idx_bookings_customer_profile_id',
    'idx_bookings_store_id',
    'idx_bookings_status_booked_at',
    'idx_bookings_booked_at',
    'idx_enquiries_customer_profile_id',
    'idx_enquiries_assigned_to',
    'idx_enquiries_status_created_at',
    'idx_booking_status_logs_booking_id',
    'idx_booking_status_logs_changed_by',
    'idx_booking_status_logs_created_at',
    'idx_enquiry_status_logs_enquiry_id',
    'idx_enquiry_status_logs_changed_by',
    'idx_enquiry_status_logs_created_at'
  )
order by indexname;

-- =========================================================
-- E) new policies existence
-- =========================================================
select
  tablename,
  policyname
from pg_policies
where schemaname = 'public'
  and policyname in (
    'bookings_select_own_or_management',
    'bookings_insert_own_or_management',
    'bookings_update_own_or_management',
    'enquiries_select_own_or_management',
    'enquiries_insert_anon_or_own',
    'enquiries_update_management',
    'booking_status_logs_select_management',
    'booking_status_logs_insert_management',
    'enquiry_status_logs_select_management',
    'enquiry_status_logs_insert_management'
  )
order by tablename, policyname;

-- =========================================================
-- F) quick data preview
-- =========================================================
select
  b.id,
  b.booking_type,
  b.status,
  b.booked_at
from public.bookings b
order by b.booked_at
limit 5;

select
  e.id,
  e.category,
  e.status,
  e.created_at
from public.enquiries e
order by e.created_at desc
limit 5;
