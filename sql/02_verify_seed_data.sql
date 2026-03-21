-- inim-dx / seed data verification
-- Run after:
-- 1. sql/00-1_create_app_schema.sql
-- 2. sql/00-2_promote_existing_user_to_admin.sql
-- 3. sql/01_seed_core_data.sql

-- ---------------------------------------------------------
-- A. row counts
-- ---------------------------------------------------------
select 'user_profiles' as table_name, count(*) from public.user_profiles
union all
select 'roles', count(*) from public.roles
union all
select 'user_role_assignments', count(*) from public.user_role_assignments
union all
select 'stores', count(*) from public.stores
union all
select 'content_assets', count(*) from public.content_assets
union all
select 'top_hero_items', count(*) from public.top_hero_items
union all
select 'journey_steps', count(*) from public.journey_steps
union all
select 'bookings', count(*) from public.bookings
union all
select 'enquiries', count(*) from public.enquiries
union all
select 'booking_status_logs', count(*) from public.booking_status_logs
union all
select 'enquiry_status_logs', count(*) from public.enquiry_status_logs;

-- ---------------------------------------------------------
-- B. admin role assignment check
-- ---------------------------------------------------------
select
  au.email,
  up.display_name,
  r.role_code,
  r.role_name,
  up.account_status,
  up.created_at
from public.user_profiles up
join auth.users au
  on au.id = up.auth_user_id
join public.user_role_assignments ura
  on ura.user_profile_id = up.id
join public.roles r
  on r.id = ura.role_id
order by au.email, r.role_code;

-- ---------------------------------------------------------
-- C. hero and journey publish data
-- ---------------------------------------------------------
select
  display_order,
  title,
  cta_label,
  cta_url,
  is_active
from public.top_hero_items
where deleted_at is null
order by display_order;

select
  step_no,
  step_name,
  link_url,
  is_visible
from public.journey_steps
order by step_no;

-- ---------------------------------------------------------
-- D. sample business data overview
-- ---------------------------------------------------------
select
  r.id,
  up.display_name as customer_name,
  s.store_name,
  r.booking_type,
  r.status,
  r.booked_at
from public.bookings r
join public.user_profiles up
  on up.id = r.customer_profile_id
join public.stores s
  on s.id = r.store_id
order by r.booked_at;

select
  i.id,
  coalesce(up.display_name, 'anonymous') as customer_name,
  i.category,
  i.subject,
  i.status,
  i.created_at
from public.enquiries i
left join public.user_profiles up
  on up.id = i.customer_profile_id
order by i.created_at desc;

-- ---------------------------------------------------------
-- E. interpretation notes
-- ---------------------------------------------------------
-- bookings = 0 is acceptable when sample auth users do not exist.
-- enquiries may be > 0 even without sample auth users because anonymous records are included.
-- booking_status_logs depends on bookings.
-- enquiry_status_logs depends on both enquiries and available changed_by users.
