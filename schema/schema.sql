-- Toshiba Master Data schema, additive to the existing Rugby Analytics
-- Supabase project (same project as handoff/supabase/schema.sql -- comps/
-- teams/players/fixtures/team_match_stats/player_match_stats). Run once in
-- the Supabase SQL Editor before running scripts/load_injuries.py.
--
-- squad_players is deliberately a *separate* identity table from the
-- existing `players` table: `players` holds every Opta-tracked player across
-- every team/competition in the match-stats data (opponents included) and is
-- fully truncated/reloaded by handoff/scripts/load_supabase.py. Toshiba
-- Master Data (rugby/gym/conditioning pages, all scoped to this squad only)
-- gets its own stable identity table instead of trying to join against the
-- match-stats `players` table. The rugby page's per-player stats are
-- embedded directly into rugby.html (see scripts/build_rugby_data.py) rather
-- than served from Supabase, so squad_players/injuries are the only tables
-- here for now -- gym data joins onto squad_players once its format exists.

-- ids are assigned by the loader script (enumerate over sorted names), not
-- by a serial sequence -- same convention as comps/teams/players in
-- handoff/supabase/schema.sql, so re-running the loader with --truncate
-- reproduces the same ids deterministically.
create table if not exists squad_players (
  id   integer primary key,
  name text not null unique  -- canonical spelling, taken as-is from the source sheet
);

-- One row per injury event from the "全体" sheet of Record of past injuries.xlsx.
-- Only the two columns the dashboard actually filters/sorts on (season, date)
-- are broken out as typed columns; every other column (R/L, Part, Type,
-- Consultation, Dr.1, Ope., Start Jog, To RTP, Memo, ...) is kept as-is in
-- `raw`, keyed by its original header name. Those columns mix dates, "○"
-- flags, free text, and day-count strings ("6 d") in ways that weren't
-- reliable to type-cast without checking every one of the ~770 rows first --
-- promote individual keys out of `raw` into real columns once that's done.
create table if not exists injuries (
  id              integer primary key,  -- assigned by the loader, see note above
  squad_player_id integer not null references squad_players(id),
  season          text not null,
  injury_date     date,
  raw             jsonb not null
);
create index if not exists injuries_squad_player_idx on injuries(squad_player_id);
create index if not exists injuries_season_idx on injuries(season);

-- DB-level allowlist for everyone allowed into Toshiba Master Data (all
-- three pages: rugby/gym/conditioning share one login gate, no per-page
-- tiering). This is the real access control (enforced below via RLS
-- policies) -- the login page's client-side check is only a UX nicety,
-- since the anon key is public and a determined user could otherwise query
-- the tables directly.
create table if not exists coaching_staff_emails (
  email text primary key
);

alter table squad_players enable row level security;
alter table injuries enable row level security;
alter table coaching_staff_emails enable row level security;

create policy "coaching staff read" on squad_players for select
  using (exists (
    select 1 from coaching_staff_emails c
    where lower(c.email) = lower(auth.jwt()->>'email')
  ));

create policy "coaching staff read" on injuries for select
  using (exists (
    select 1 from coaching_staff_emails c
    where lower(c.email) = lower(auth.jwt()->>'email')
  ));

-- No select policy on coaching_staff_emails itself -- only the service_role
-- key (used by scripts, never shipped client-side) can read/write it.
