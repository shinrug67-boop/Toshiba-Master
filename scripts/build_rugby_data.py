#!/usr/bin/env python3
"""Build site/rugby.html's embedded data payload from the existing Rugby
Total Data project's compare_data.json (same per-player Attack/Defense/Kick/
Scrum/Lineout metrics already used by handoff/site/compare.html), filtered
down to Toshiba Brave Lupus Tokyo only.

This only reads the *already-built* compare_data.json -- it does not touch
the raw per-match CSVs, so it's cheap to re-run any time that file is
refreshed (see handoff/scripts/build_compare_data.py).

Usage:
  python3 build_rugby_data.py
"""
import json
import os
import re

COMPARE_DATA = os.path.expanduser(
    '~/Documents/Rugby Total Data/handoff/data/compare_data.json'
)
HERE = os.path.dirname(os.path.abspath(__file__))
RUGBY_HTML = os.path.join(HERE, '..', 'site', 'rugby.html')
TEAM_NAME = 'Toshiba Brave Lupus Tokyo'

START_MARK = '/*RUGBY_DATA_START*/'
END_MARK = '/*RUGBY_DATA_END*/'


def build_payload():
    src = json.load(open(COMPARE_DATA))
    team_idx = src['teams'].index(TEAM_NAME)
    rows = [r for r in src['P'] if r[2] == team_idx]

    comps_used = sorted({src['comps'][r[0]] for r in rows})
    player_idxs = sorted({r[3] for r in rows})
    new_idx = {old: i for i, old in enumerate(player_idxs)}

    players = [src['players'][old] for old in player_idxs]
    player_pos = [src['playerPos'][old] for old in player_idxs]

    # r = [compIdx, season, teamIdx, playerIdx, gp, ...pmet]; drop comp/team
    # (always the same single value here) and remap playerIdx to the compact
    # local index.
    P = [[r[1], new_idx[r[3]], r[4]] + r[5:] for r in rows]

    return {
        'team': TEAM_NAME,
        'comps': comps_used,
        'players': players,
        'playerPos': player_pos,
        'pmet': src['pmet'],
        'P': P,
    }


def main():
    payload = build_payload()
    js = json.dumps(payload, ensure_ascii=False, separators=(',', ':'))

    html = open(RUGBY_HTML).read()
    if START_MARK not in html or END_MARK not in html:
        raise SystemExit(f'markers {START_MARK} / {END_MARK} not found in {RUGBY_HTML}')
    pattern = re.compile(re.escape(START_MARK) + '.*?' + re.escape(END_MARK), re.S)
    # Function replacement, not a plain string -- re.sub parses backslash
    # sequences in a string replacement as escape/backref syntax, which would
    # corrupt the JSON if a name ever contains a backslash.
    html = pattern.sub(lambda m: START_MARK + js + END_MARK, html, count=1)
    open(RUGBY_HTML, 'w').write(html)

    print(f'{TEAM_NAME}: {len(payload["players"])} players, {len(payload["P"])} rows, '
          f'comps={payload["comps"]}')
    print(f'wrote embedded payload into {RUGBY_HTML} ({len(js) // 1024} KB)')


if __name__ == '__main__':
    main()
