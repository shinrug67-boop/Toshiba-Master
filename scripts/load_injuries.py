#!/usr/bin/env python3
"""Loader: data/raw/Record of past injuries.xlsx ("全体" sheet only) ->
Supabase tables defined in schema/schema.sql (run that SQL file
in the Supabase SQL Editor first).

This is medical data, so unlike handoff/scripts/load_supabase.py the default
action is a dry run: it only prints what it *would* load. Pass --load to
actually write to Supabase.

Requires two environment variables when --load is passed (never commit
these):
  SUPABASE_URL               e.g. https://xxxx.supabase.co
  SUPABASE_SERVICE_ROLE_KEY  service_role key (Project Settings -> API).
                              This key bypasses RLS -- do not put it in any
                              client-side/HTML file, only use it here.

Usage:
  python3 load_injuries.py                    # dry run, no env vars needed
  SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... python3 load_injuries.py --load [--truncate]
"""
import datetime
import json
import os
import sys

import openpyxl

HERE = os.path.dirname(os.path.abspath(__file__))
XLSX_PATH = os.path.join(HERE, '..', 'data', 'raw', 'Record of past injuries.xlsx')
SHEET_NAME = '全体'
BATCH = 500


def json_safe(value):
    # Every datetime in this sheet is midnight (date-only data entered via
    # Excel's date picker) -- drop the time component instead of emitting
    # "2015-04-30T00:00:00" everywhere.
    if isinstance(value, datetime.datetime):
        return value.date().isoformat()
    if isinstance(value, datetime.date):
        return value.isoformat()
    return value


def load_rows():
    wb = openpyxl.load_workbook(XLSX_PATH, data_only=True)
    ws = wb[SHEET_NAME]
    rows_iter = ws.iter_rows(values_only=True)
    headers = next(rows_iter)
    records = []
    for row in rows_iter:
        record = dict(zip(headers, row))
        if not record.get('Name'):
            continue
        records.append(record)
    return records


def build_payload(records):
    names = sorted({str(r['Name']).strip() for r in records})
    player_id = {name: i for i, name in enumerate(names)}
    squad_players = [{'id': i, 'name': name} for i, name in enumerate(names)]

    injuries = []
    for i, r in enumerate(records):
        name = str(r['Name']).strip()
        season = r.get('Season')
        injury_date = json_safe(r.get('Injury Date'))
        raw = {str(k): json_safe(v) for k, v in r.items() if k is not None}
        injuries.append({
            'id': i,
            'squad_player_id': player_id[name],
            'season': str(season) if season is not None else None,
            'injury_date': injury_date,
            'raw': raw,
        })
    return squad_players, injuries


def post_batches(session_url, headers, table, rows):
    import requests
    url = f'{session_url}/rest/v1/{table}'
    for i in range(0, len(rows), BATCH):
        chunk = rows[i:i + BATCH]
        r = requests.post(url, headers=headers, data=json.dumps(chunk))
        if r.status_code >= 300:
            sys.exit(f'FAILED inserting into {table} (rows {i}-{i + len(chunk)}): {r.status_code} {r.text[:500]}')
    print(f'{table}: inserted {len(rows)} rows')


def truncate(session_url, headers, table, pk_col):
    import requests
    url = f'{session_url}/rest/v1/{table}?{pk_col}=not.is.null'
    r = requests.delete(url, headers=headers)
    if r.status_code >= 300:
        sys.exit(f'FAILED truncating {table}: {r.status_code} {r.text[:500]}')
    print(f'{table}: cleared')


def main():
    do_load = '--load' in sys.argv
    do_truncate = '--truncate' in sys.argv

    records = load_rows()
    squad_players, injuries = build_payload(records)

    seasons = sorted({inj['season'] for inj in injuries if inj['season']})
    print(f'Source: {XLSX_PATH}')
    print(f'Sheet "{SHEET_NAME}": {len(records)} injury rows, {len(squad_players)} unique players')
    print(f'Seasons found: {seasons}')
    print('Sample player:', squad_players[0])
    print('Sample injury:', json.dumps(injuries[0], ensure_ascii=False, indent=2))

    if not do_load:
        print('\nDry run only -- pass --load to actually write to Supabase.')
        return

    supabase_url = os.environ.get('SUPABASE_URL', '').rstrip('/')
    service_key = os.environ.get('SUPABASE_SERVICE_ROLE_KEY', '')
    if not supabase_url or not service_key:
        sys.exit('Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY environment variables first.')
    headers = {
        'apikey': service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
    }

    if do_truncate:
        truncate(supabase_url, headers, 'injuries', 'id')
        truncate(supabase_url, headers, 'squad_players', 'id')

    post_batches(supabase_url, headers, 'squad_players', squad_players)
    post_batches(supabase_url, headers, 'injuries', injuries)
    print('done')


if __name__ == '__main__':
    main()
