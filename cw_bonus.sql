--- 1. ---
SELECT matchid, player FROM gole WHERE teamid = 'POL';

--- 2. ---
SELECT * FROM mecze JOIN gole ON (id = matchid) WHERE player = 'Jakub Blaszczykowski' AND id = '1004';

--- 3. ---
SELECT player, teamname, stadium, mdate FROM mecze JOIN gole ON (id=matchid) JOIN druzyny ON (druzyny.id=gole.teamid) WHERE teamname = 'Poland';

--- 4. ---
SELECT team1, team2, player FROM gole JOIN mecze ON (id = matchid) WHERE player LIKE 'Mario%';

--- 5. ---
SELECT player, teamid, coach, gtime FROM gole JOIN druzyny ON (id = teamid) WHERE gtime <= 10;