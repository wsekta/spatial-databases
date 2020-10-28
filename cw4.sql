--- zd 4 ---
CREATE TABLE tableB AS SELECT popp.* FROM popp, majrivers 
	WHERE popp.f_codedesc LIKE 'Building' GROUP BY popp.gid 
	HAVING MIN(ST_Distance(majrivers.geom, popp.geom)) < 100000;
SELECT COUNT(1) FROM tableB;

--- zd 5 ---
CREATE TABLE airportsNew(gid SERIAL, name TEXT, geom GEOMETRY, elev NUMERIC);
INSERT INTO airportsNew (name, geom, elev) SELECT name, geom, elev FROM airports;

--- a) ---
SELECT airportsNew.*, ST_Y(geom) AS y FROM airportsNew ORDER BY y DESC LIMIT 1;
SELECT airportsNew.*, ST_Y(geom) AS y FROM airportsNew ORDER BY y LIMIT 1;

--- b) ---
INSERT INTO airportsNew(name, geom, elev)
	VALUES ('airportB', CONCAT('Point(',
		(SELECT((SELECT ST_Y(geom) FROM airportsNew ORDER BY ST_Y(geom) DESC LIMIT 1) + (SELECT ST_Y(geom) FROM airportsNew ORDER BY ST_Y(geom) LIMIT 1))/2),
		' ',
		(SELECT((SELECT ST_X(geom) AS x FROM airportsNew ORDER BY x DESC LIMIT 1) + (SELECT ST_X(geom) AS x FROM airportsNew ORDER BY x LIMIT 1))/2),
	')'), 121.37);

--- zd 6 ---
SELECT ST_Area(ST_Buffer(ST_ShortestLine((SELECT geom FROM lakes WHERE names LIKE 'Iliamna Lake'),(SELECT geom FROM airports WHERE name LIKE 'AMBLER')), 1000));

--- zd 7 ---
SELECT vegdesc, SUM(area_km2) 
	FROM (SELECT vegdesc, trees.area_km2 FROM trees JOIN tundra ON trees.geom = tundra.geom) AS trees_tundra 
	GROUP BY vegdesc;
SELECT vegdesc, SUM(area_km2) 
	FROM (SELECT vegdesc, trees.area_km2 FROM trees JOIN cw4.swamp ON trees.geom = swamp.geom) AS trees_swamp 
	GROUP BY vegdesc;