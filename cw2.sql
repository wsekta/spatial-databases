SELECT CONCAT('Producent: ', pr.nazwa_producenta, ', liczba zamowien: ', SUM(z.ilosc), ', wartosc zamowienia: ', SUM(z.ilosc*p.cena)) AS raport_producenci FROM sklep.produkty p JOIN sklep.producenci pr ON pr.id_producenta = p.producenci_id_producenta JOIN sklep.zamowienia z ON z.produkty_id_produktu = p.id_produktu GROUP BY pr.nazwa_producenta;
SELECT CONCAT('Produkt: ', pr.nazwa_produktu, ', liczba zamowien: ', COUNT(z.id_zamowienia)) FROM sklep.zamowienia z RIGHT JOIN sklep.produkty pr ON pr.id_produktu = z.id_produktu GROUP BY pr.nazwa_produktu;
SELECT * FROM sklep.produkty NATURAL JOIN sklep.zamowienia;
SELECT * FROM zamowienia WHERE EXTRACT(MONTH FROM data) = 1; 
SELECT EXTRACT(DOW FROM  data)AS day, SUM(ilosc) as sum FROM sklep.zamowienia GROUP BY day ORDER BY sum DESC;
SELECT p.nazwa_produktu, SUM(z.ilosc) as sum FROM sklep.zamowienia z JOIN sklep.produkty p ON p.id_produktu=z.id_produktu GROUP BY p.nazwa_produktu ORDER BY sum DESC;
SELECT CONCAT('Produkt ', UPPER(p.nazwa_produktu), ', ktorego producentem jest ', LOWER(pr.nazwa_producenta), ', zamowiono ', COUNT(z.id_zamowienia), ' razy.') AS opis FROM sklep.zamowienia z RIGHT JOIN sklep.produkty p ON p.id_produktu = z.id_produktu JOIN sklep.producenci pr ON pr.id_producenta = p.id_producenta GROUP BY p.nazwa_produktu, pr.nazwa_producenta ORDER BY COUNT(z.id_zamowienia) DESC;
SELECT z.*, pr.*, SUM(pr.cena * z.ilosc) AS wartosc FROM sklep.zamowienia z JOIN sklep.produkty pr ON pr.id_produktu = z.id_produktu GROUP BY z.id_zamowienia, pr.id_produktu ORDER BY wartosc DESC LIMIT (SELECT COUNT(*) FROM sklep.zamowienia) - 3;
CREATE TABLE sklep.klienci(
    id_klienta serial NOT NULL,
    mail varchar(50)  NOT NULL,
    telefon varchar(9)  NOT NULL,
    CONSTRAINT klienci_pk PRIMARY KEY (id_klienta)
);
ALTER TABLE sklep.zamowienia ADD COLUMN id_klienta INT REFERENCES sklep.klienci(id_klienta);
INSERT INTO klienci(email, telefon)
VALUES
('jan1.nowak@gmail.com', '999999999'),
('jan2.nowak@gmail.com', '888888888'),
('jan3.nowak@gmail.com', '777777777');
UPDATE sklep.zamowienia SET id_klienta = 1 WHERE id_zamowienia IN (1, 2, 3, 4, 5);
UPDATE sklep.zamowienia SET id_klienta = 2 WHERE id_zamowienia IN (6, 7, 8, 9, 10);
UPDATE sklep.zamowienia SET id_klienta = 3 WHERE id_zamowienia IN (11, 12, 13, 14, 15);
SELECT k.*, p.nazwa_produktu, z.ilosc, z.ilosc*p.cena AS wartosc FROM sklep.zamowienia z RIGHT JOIN sklep.klienci k ON k.id_klienta = z.id_klienta JOIN sklep.produkty p ON p.produktu = z.id_produktu;
SELECT CONCAT('NAJRZADZIEJ ZAMAWIAJACY: ', k.*, ', ilosc zamowien: ', COUNT(z.id_zamowienia) AS suma, ', wartosc: ', SUM(z.ilosc*p.cena)) FROM sklep.zamowienia z RIGHT JOIN sklep.klienci k ON k.id_klienta = z.id_klienta JOIN sklep.produkty p ON p.id_produktu = z.id_produktu GROUP BY z.id_klienta ORDER BY suma LIMIT 1;	
DELETE FROM sklep.produkty WHERE id_produktu = (SELECT p.id_produktu FROM sklep.zamowienia z RIGHT OUTER JOIN sklep.produkty p ON z.id_produktu = p.id_produktu WHERE z.id_produktu IS NULL);
CREATE TABLE numer(
    liczba decimal(4,0)
);
CREATE SEQUENCE liczba_seq INCREMENT 5 MINVALUE 0 MAXVALUE 125 START 100 CYCLE;

ALTER SEQUENCE liczba_seq INCREMENT 6;
SELECT CURRVAL('liczba_seq'), NEXTVAL('liczba_seq');
DROP SEQUENCE liczba_seq;
CREATE USER Superuser298277 SUPERUSER;
CREATE USER guest298277;
GRANT CONNECT ON DATABASE s298277 TO guest298277;
GRANT SELECT ON ALL TABLES IN SCHEMA firma TO guest298277;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep TO guest298277;
ALTER USER Superuser298277 RENAME TO student;
ALTER USER student WITH NOSUPERUSER;
GRANT SELECT ON ALL TABLES IN SCHEMA firma TO student;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep TO student;
BEGIN;
UPDATE sklep.produkty SET cena = cena + CAST(10 AS money);
COMMIT;
BEGIN;
UPDATE sklep.produkty SET cena = 1.1*cena WHERE id_produktu = 3;
SAVEPOINT S1;
UPDATE sklep.zamowienia SET liczba_sztuk = 1.25*liczba_sztuk;
SAVEPOINT S2;
DELETE FROM sklep.klienci WHERE id_klienta IN (SELECT id_klienta FROM sklep.klienci k JOIN sklep.zamowienia z ON z.id_klienta = k.id_klienta JOIN produkty p ON z.id_produktu = p.id_produktu GROUP BY k.id_klienta ORDER BY SUM(p.cena*z.ilosc) DESC LIMIT 1);
ROLLBACK TO S1;
ROLLBACK TO S2;
ROLLBACK;
COMMIT;