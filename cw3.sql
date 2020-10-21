CREATE DATABASE s298273_spatial_db;
CREATE EXTENSION postgis;

CREATE TABLE budynki(id SERIAL PRIMARY KEY, geometria GEOMETRY, nazwa TEXT);
CREATE TABLE drogi (id SERIAL PRIMARY KEY, geometria GEOMETRY, nazwa TEXT);
CREATE TABLE punkty_informacyjne(id SERIAL PRIMARY KEY, geometria GEOMETRY, nazwa TEXT);

INSERT INTO budynki VALUES (1, ST_GeomFromText('POLYGON((10.5 4, 10.5 1.5, 8 1.5, 8 4, 10.5 4))'), 'BuildingA'),
	(2, ST_GeomFromText('POLYGON((6 7, 6 5, 4 5, 4 7, 6 7))'), 'BuildingB'),
	(3, ST_GeomFromText('POLYGON((5 8, 5 6, 3 6, 3 8, 5 8))'), 'BuildingC'),
	(4, ST_GeomFromText('POLYGON((10 9, 10 8, 9 8, 9 9, 10 9))'), 'BuildingD'),
	(5, ST_GeomFromText('POLYGON((2 2, 2 1, 1 1, 1 2, 2 2))'), 'BuildingF');

INSERT INTO punkty_informacyjne VALUES (1, ST_GeomFromText('POINT(1 3.5)'), 'G'),
	(2, ST_GeomFromText('POINT(5.5 1.5)'), 'H'),
	(3, ST_GeomFromText('POINT(9.5 6)'), 'I'),
	(4, ST_GeomFromText('POINT(6 6.5)'), 'J'),
	(5, ST_GeomFromText('POINT(6 9.5)'), 'K');

INSERT INTO drogi VALUES (1, ST_MakeLine(ST_GeomFromText('POINT(0 4.5)'), ST_GeomFromText('POINT(12 4.5)')), 'RoadX'),
	(2, ST_MakeLine(ST_GeomFromText('POINT(7.5 0)'), ST_GeomFromText('POINT(7.5 10.5)')), 'RoadY');

SELECT SUM(ST_Length(geometria)) FROM drogi;

SELECT ST_AsText(geometria), ST_Area(geometria), ST_Length(ST_ExteriorRing(geometria))
	FROM budynki WHERE nazwa='BuildingA';

SELECT nazwa, ST_Area(geometria) FROM budynki;

SELECT nazwa, ST_Perimeter(geometria) FROM budynki ORDER BY ST_Area(geometria) DESC LIMIT 2;

SELECT ST_Distance(budynki.geometria, punkty_informacyjne.geometria) FROM budynki, punkty_informacyjne WHERE budynki.nazwa LIKE 'BuildingC' AND punkty_informacyjne.nazwa LIKE 'G';

SELECT ST_Area(ST_Intersection(ST_Buffer((SELECT geometria FROM budynki WHERE nazwa LIKE 'BuildingB'), 0.5), (SELECT geometria FROM budynki WHERE nazwa LIKE 'BuildingC')));

SELECT nazwa FROM budynki WHERE ST_Y(ST_Centroid(geometria)) > ST_Y(ST_PointN((SELECT geometria FROM drogi WHERE nazwa LIKE 'RoadX'), 1));

SELECT ST_Area(ST_SymDifference((SELECT geometria FROM budynki WHERE nazwa LIKE 'BuildingC'), 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'));  
