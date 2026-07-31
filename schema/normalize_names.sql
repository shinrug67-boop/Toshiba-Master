-- One-off name-normalization pass: unifies squad_players.name spellings
-- against the rugby roster's canonical 'Firstname Lastname' form (see
-- scripts/build_rugby_data.py), and merges rows that were split into two
-- squad_players entries under different spellings for the same real
-- player (repoints injuries.squad_player_id then drops the now-empty
-- duplicate row). Only covers names with a confident 1:1 match against
-- the current 2024-2026 rugby roster -- older/departed players with no
-- overlap are left as-is.

-- merge group: ['A.Ofeina', 'AFU OFEINA'] -> Afu Ofeina
update squad_players set name = 'Afu Ofeina' where name = 'A.Ofeina';
update injuries set squad_player_id = (select id from squad_players where name = 'Afu Ofeina') where squad_player_id = (select id from squad_players where name = 'AFU OFEINA');
delete from squad_players where name = 'AFU OFEINA';

update squad_players set name = 'Andrew Makalio' where name = 'A.Makalio';
update squad_players set name = 'Asaeli Lausii' where name = 'ASAELI LAUSII';
-- merge group: ['A.Kuwayama', 'KUWAYAMA ATSUKI'] -> Atsuki Kuwayama
update squad_players set name = 'Atsuki Kuwayama' where name = 'A.Kuwayama';
update injuries set squad_player_id = (select id from squad_players where name = 'Atsuki Kuwayama') where squad_player_id = (select id from squad_players where name = 'KUWAYAMA ATSUKI');
delete from squad_players where name = 'KUWAYAMA ATSUKI';

-- merge group: ['D.Hashimoto', 'HASHIMOTO DAIGO'] -> Daigo Hashimoto
update squad_players set name = 'Daigo Hashimoto' where name = 'D.Hashimoto';
update injuries set squad_player_id = (select id from squad_players where name = 'Daigo Hashimoto') where squad_player_id = (select id from squad_players where name = 'HASHIMOTO DAIGO');
delete from squad_players where name = 'HASHIMOTO DAIGO';

-- merge group: ['F.Mori', 'MORI FUTOSHI'] -> Futoshi Mori
update squad_players set name = 'Futoshi Mori' where name = 'F.Mori';
update injuries set squad_player_id = (select id from squad_players where name = 'Futoshi Mori') where squad_player_id = (select id from squad_players where name = 'MORI FUTOSHI');
delete from squad_players where name = 'MORI FUTOSHI';

-- merge group: ['G.Ikenaga', 'IKENAGA GENTARO'] -> Gentaro Ikenaga
update squad_players set name = 'Gentaro Ikenaga' where name = 'G.Ikenaga';
update injuries set squad_player_id = (select id from squad_players where name = 'Gentaro Ikenaga') where squad_player_id = (select id from squad_players where name = 'IKENAGA GENTARO');
delete from squad_players where name = 'IKENAGA GENTARO';

update squad_players set name = 'Hayata Nakao' where name = 'H.Nakao';
update squad_players set name = 'Hiroki Yamamoto' where name = 'YAMAMOTO HIROKI';
-- merge group: ['J.Pierce', 'JACOB PIERCE'] -> Jacob Pierce
update squad_players set name = 'Jacob Pierce' where name = 'J.Pierce';
update injuries set squad_player_id = (select id from squad_players where name = 'Jacob Pierce') where squad_player_id = (select id from squad_players where name = 'JACOB PIERCE');
delete from squad_players where name = 'JACOB PIERCE';

update squad_players set name = 'Jone Naikabula' where name = 'JONE NAIKABULA';
update squad_players set name = 'Kohei Takahashi' where name = 'TAKAHASHI KOHEI';
update squad_players set name = 'Kyosuke Kajikawa' where name = 'KAJIKAWA KYOSUKE';
update squad_players set name = 'Mamoru Harada' where name = 'HARADA MAMORU';
-- merge group: ['HAMADA MASAKI', 'M.Hamada'] -> Masaki Hamada
update squad_players set name = 'Masaki Hamada' where name = 'HAMADA MASAKI';
update injuries set squad_player_id = (select id from squad_players where name = 'Masaki Hamada') where squad_player_id = (select id from squad_players where name = 'M.Hamada');
delete from squad_players where name = 'M.Hamada';

-- merge group: ['M.Mikami', 'MIKAMI MASATAKA'] -> Masataka Mikami
update squad_players set name = 'Masataka Mikami' where name = 'M.Mikami';
update injuries set squad_player_id = (select id from squad_players where name = 'Masataka Mikami') where squad_player_id = (select id from squad_players where name = 'MIKAMI MASATAKA');
delete from squad_players where name = 'MIKAMI MASATAKA';

update squad_players set name = 'Michael Collins' where name = 'MICHAEL COLLINS';
-- merge group: ['M.Leitch', 'MICHAEL LEITCH'] -> Michael Leitch
update squad_players set name = 'Michael Leitch' where name = 'M.Leitch';
update injuries set squad_player_id = (select id from squad_players where name = 'Michael Leitch') where squad_player_id = (select id from squad_players where name = 'MICHAEL LEITCH');
delete from squad_players where name = 'MICHAEL LEITCH';

update squad_players set name = 'Motoki Tanaka' where name = 'M.Tanaka';
update squad_players set name = 'Nik McCurran' where name = 'N.McCurran';
update squad_players set name = 'PJ Steenkamp' where name = 'PJ STEENKAMP';
update squad_players set name = 'Rei Ishioka' where name = 'ISHIOKA REI';
update squad_players set name = 'Richie Mo''unga' where name = 'RICHIE MO''UNGA';
-- merge group: ['R.Yamakawa', 'YAMAKAWA RIKYU'] -> Rikyu Yamakawa
update squad_players set name = 'Rikyu Yamakawa' where name = 'R.Yamakawa';
update injuries set squad_player_id = (select id from squad_players where name = 'Rikyu Yamakawa') where squad_player_id = (select id from squad_players where name = 'YAMAKAWA RIKYU');
delete from squad_players where name = 'YAMAKAWA RIKYU';

-- merge group: ['R.Thompson', 'ROB THOMPSON'] -> Rob Thompson
update squad_players set name = 'Rob Thompson' where name = 'R.Thompson';
update injuries set squad_player_id = (select id from squad_players where name = 'Rob Thompson') where squad_player_id = (select id from squad_players where name = 'ROB THOMPSON');
delete from squad_players where name = 'ROB THOMPSON';

-- merge group: ['KIMURA SENA', 'S.Kimura'] -> Sena Kimura
update squad_players set name = 'Sena Kimura' where name = 'KIMURA SENA';
update injuries set squad_player_id = (select id from squad_players where name = 'Sena Kimura') where squad_player_id = (select id from squad_players where name = 'S.Kimura');
delete from squad_players where name = 'S.Kimura';

-- merge group: ['S.Tamanivalu', 'SETA TAMANIVALU'] -> Seta Tamanivalu
update squad_players set name = 'Seta Tamanivalu' where name = 'S.Tamanivalu';
update injuries set squad_player_id = (select id from squad_players where name = 'Seta Tamanivalu') where squad_player_id = (select id from squad_players where name = 'SETA TAMANIVALU');
delete from squad_players where name = 'SETA TAMANIVALU';

-- merge group: ['S.Frizell', 'SHANNON FRIZELL'] -> Shannon Frizell
update squad_players set name = 'Shannon Frizell' where name = 'S.Frizell';
update injuries set squad_player_id = (select id from squad_players where name = 'Shannon Frizell') where squad_player_id = (select id from squad_players where name = 'SHANNON FRIZELL');
delete from squad_players where name = 'SHANNON FRIZELL';

-- merge group: ['ITO SHOHEI', 'S.Ito'] -> Shohei Ito
update squad_players set name = 'Shohei Ito' where name = 'ITO SHOHEI';
update injuries set squad_player_id = (select id from squad_players where name = 'Shohei Ito') where squad_player_id = (select id from squad_players where name = 'S.Ito');
delete from squad_players where name = 'S.Ito';

update squad_players set name = 'Shohei Toyoshima' where name = 'TOYOSHIMA SHOHEI';
-- merge group: ['IKEDO SHOTARO', 'S.Ikedo'] -> Shotaro Ikedo
update squad_players set name = 'Shotaro Ikedo' where name = 'IKEDO SHOTARO';
update injuries set squad_player_id = (select id from squad_players where name = 'Shotaro Ikedo') where squad_player_id = (select id from squad_players where name = 'S.Ikedo');
delete from squad_players where name = 'S.Ikedo';

-- merge group: ['MANO TAICHI', 'T.Mano'] -> Taichi Mano
update squad_players set name = 'Taichi Mano' where name = 'MANO TAICHI';
update injuries set squad_player_id = (select id from squad_players where name = 'Taichi Mano') where squad_player_id = (select id from squad_players where name = 'T.Mano');
delete from squad_players where name = 'T.Mano';

update squad_players set name = 'Taiki Matsunobu' where name = 'MATSUNOBU TAIKI';
update squad_players set name = 'Taishiro Kido' where name = 'T.Kido';
-- merge group: ['OGAWA TAKAHIRO', 'T.Ogawa'] -> Takahiro Ogawa
update squad_players set name = 'Takahiro Ogawa' where name = 'OGAWA TAKAHIRO';
update injuries set squad_player_id = (select id from squad_players where name = 'Takahiro Ogawa') where squad_player_id = (select id from squad_players where name = 'T.Ogawa');
delete from squad_players where name = 'T.Ogawa';

-- merge group: ['SASAKI TAKESHI', 'T.Sasaki'] -> Takeshi Sasaki
update squad_players set name = 'Takeshi Sasaki' where name = 'SASAKI TAKESHI';
update injuries set squad_player_id = (select id from squad_players where name = 'Takeshi Sasaki') where squad_player_id = (select id from squad_players where name = 'T.Sasaki');
delete from squad_players where name = 'T.Sasaki';

-- merge group: ['MATSUNAGA TAKURO', 'T.Matsunaga'] -> Takuro Matsunaga
update squad_players set name = 'Takuro Matsunaga' where name = 'MATSUNAGA TAKURO';
update injuries set squad_player_id = (select id from squad_players where name = 'Takuro Matsunaga') where squad_player_id = (select id from squad_players where name = 'T.Matsunaga');
delete from squad_players where name = 'T.Matsunaga';

update squad_players set name = 'Taufa Latu' where name = 'TAUFA LATU';
-- merge group: ['MAKABE TERUO', 'T.Makabe'] -> Teruo Makabe
update squad_players set name = 'Teruo Makabe' where name = 'MAKABE TERUO';
update injuries set squad_player_id = (select id from squad_players where name = 'Teruo Makabe') where squad_player_id = (select id from squad_players where name = 'T.Makabe');
delete from squad_players where name = 'T.Makabe';

update squad_players set name = 'Tjay Clarke' where name = 'T.Clarke';
-- merge group: ['KUWAYAMA TOSHIKI', 'T.Kuwayama'] -> Toshiki Kuwayama
update squad_players set name = 'Toshiki Kuwayama' where name = 'KUWAYAMA TOSHIKI';
update injuries set squad_player_id = (select id from squad_players where name = 'Toshiki Kuwayama') where squad_player_id = (select id from squad_players where name = 'T.Kuwayama');
delete from squad_players where name = 'T.Kuwayama';

-- merge group: ['V.Taumoefolau', 'VEA TAUMOEFOLAU'] -> Vea Taumoefolau
update squad_players set name = 'Vea Taumoefolau' where name = 'V.Taumoefolau';
update injuries set squad_player_id = (select id from squad_players where name = 'Vea Taumoefolau') where squad_player_id = (select id from squad_players where name = 'VEA TAUMOEFOLAU');
delete from squad_players where name = 'VEA TAUMOEFOLAU';

update squad_players set name = 'Warner Dearns' where name = 'WARNER DEARNS';
-- merge group: ['TOKUNAGA YOSHITAKA', 'Y.Tokunaga'] -> Yoshitaka Tokunaga
update squad_players set name = 'Yoshitaka Tokunaga' where name = 'TOKUNAGA YOSHITAKA';
update injuries set squad_player_id = (select id from squad_players where name = 'Yoshitaka Tokunaga') where squad_player_id = (select id from squad_players where name = 'Y.Tokunaga');
delete from squad_players where name = 'Y.Tokunaga';

update squad_players set name = 'Yuhei Sugiyama' where name = 'SUGIYAMA YUHEI';
update squad_players set name = 'Yuma Fujino' where name = 'FUJINO YUMA';
-- merge group: ['KOKAJI YUTA', 'Y.Kokaji'] -> Yuta Kokaji
update squad_players set name = 'Yuta Kokaji' where name = 'KOKAJI YUTA';
update injuries set squad_player_id = (select id from squad_players where name = 'Yuta Kokaji') where squad_player_id = (select id from squad_players where name = 'Y.Kokaji');
delete from squad_players where name = 'Y.Kokaji';

update squad_players set name = 'Yuto Mori' where name = 'MORI YUTO';

-- Found on a follow-up looser pass (surname-token overlap) -- these two
-- didn't match the strict initial+surname / two-word-reorder heuristics
-- above: "AMUELA" is a typo for "SAMUELA" (missing leading S), and
-- "Du Toit" is a two-word surname the initial-pattern regex didn't allow.
-- Correct name order is "Anise Samuela" (confirmed by the user) -- the
-- rugby roster's "Samuela Anise" has the two tokens swapped.
update squad_players set name = 'Anise Samuela' where name = 'ANISE AMUELA';
update squad_players set name = 'Stephanus Du Toit' where name = 'S.Du Toit';
-- Title-case the remaining ALL CAPS names (no rugby-data match to
-- cross-reference, so just normalize capitalization: first letter of
-- each word uppercase, rest lowercase).
update squad_players set name = 'Chinen Yu' where name = 'CHINEN YU';
update squad_players set name = 'Fujita Takahiro' where name = 'FUJITA TAKAHIRO';
update squad_players set name = 'Gwante Kim' where name = 'GWANTE KIM';
update squad_players set name = 'Hirata Kai' where name = 'HIRATA KAI';
update squad_players set name = 'Ishii Kai' where name = 'ISHII KAI';
update squad_players set name = 'Ito Shin' where name = 'ITO SHIN';
update squad_players set name = 'Iwafuchi Makoto' where name = 'IWAFUCHI MAKOTO';
update squad_players set name = 'Jack Stratton' where name = 'JACK STRATTON';
update squad_players set name = 'Kasai Hiroto' where name = 'KASAI HIROTO';
update squad_players set name = 'Kobayashi Yohei' where name = 'KOBAYASHI YOHEI';
update squad_players set name = 'Matsuoka Hisayoshi' where name = 'MATSUOKA HISAYOSHI';
update squad_players set name = 'Matt Todd' where name = 'MATT TODD';
update squad_players set name = 'Miyagami Ren' where name = 'MIYAGAMI REN';
update squad_players set name = 'Morita Yoshikazu' where name = 'MORITA YOSHIKAZU';
update squad_players set name = 'Murayama Ren' where name = 'MURAYAMA REN';
update squad_players set name = 'Natsui Daisuke' where name = 'NATSUI DAISUKE';
update squad_players set name = 'Ono Hitoshi' where name = 'ONO HITOSHI';
update squad_players set name = 'Ouchi Shin' where name = 'OUCHI SHIN';
update squad_players set name = 'Rye On Yoon' where name = 'RYE ON YOON';
update squad_players set name = 'Takagi Shoichi' where name = 'TAKAGI SHOICHI';
update squad_players set name = 'Tim Bateman' where name = 'TIM BATEMAN';
update squad_players set name = 'Tom Taylor' where name = 'TOM TAYLOR';
update squad_players set name = 'Yoshida Tomoki' where name = 'YOSHIDA TOMOKI';

-- Reported by the user: 3 more typo/abbreviation variants duplicating
-- players already renamed above. No squad_players rename needed here (the
-- canonical row already exists) -- just repoint injuries and drop the dupe.
update injuries set squad_player_id = (select id from squad_players where name = 'Asaeli Lausii') where squad_player_id = (select id from squad_players where name = 'L.Asaeli');
delete from squad_players where name = 'L.Asaeli';

update injuries set squad_player_id = (select id from squad_players where name = 'Richie Mo''unga') where squad_player_id = (select id from squad_players where name = 'R.Mounga');
delete from squad_players where name = 'R.Mounga';

update injuries set squad_player_id = (select id from squad_players where name = 'Michael Collins') where squad_player_id = (select id from squad_players where name = 'M.Colins');
delete from squad_players where name = 'M.Colins';
