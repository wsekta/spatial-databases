--- zad. 1 ---
CREATE DATABASE s298273;

--- zad. 2 ---
CREATE SCHEMA firma;

--- zad. 3 ---
CREATE ROLE ksiegowosc;
GRANT CONNECT ON DATABASE s298273 TO ksiegowosc;
GRANT USAGE ON SCHEMA firma TO ksiegowosc;

--- zad. 4 ---
CREATE TABLE firma.pracownicy(
	id_pracownika SERIAL, 
	imie TEXT NOT NULL, 
	nazwisko TEXT NOT NULL, 
	adres TEXT, 
	telefon TEXT
);

CREATE TABLE firma.godziny(
	id_godziny SERIAL, 
	data DATE NOT NULL, 
	liczba_godzin BIGINT NOT NULL, 
	id_pracownika BIGINT NOT NULL
);

CREATE TABLE firma.pensja_stanowisko(
	id_pensji SERIAL, 
	stanowisko TEXT NOT NULL, 
	kwota BIGINT NOT NULL
);

CREATE TABLE firma.premia(
	id_premii SERIAL, 
	rodzaj TEXT, 
	kwota BIGINT NOT NULL
);

CREATE TABLE firma.wynagrodzenie(
	id_wynagrodzenia SERIAL, 
	data DATE NOT NULL, 
	id_pracownika BIGINT NOT NULL, 
	id_godziny BIGINT NOT NULL, 
	id_pensji BIGINT NOT NULL, 
	id_premii BIGINT NOT NULL
);

ALTER TABLE firma.pracownicy
    OWNER to postgres;
ALTER TABLE firma.godziny
    OWNER to postgres;
ALTER TABLE firma.pensja_stanowisko
    OWNER to postgres;
ALTER TABLE firma.premia
    OWNER to postgres;
ALTER TABLE firma.wynagrodzenie
    OWNER to postgres;

--- b) ---
ALTER TABLE firma.pracownicy
    ADD PRIMARY KEY (id_pracownika);    
ALTER TABLE firma.godziny
    ADD PRIMARY KEY (id_godziny);    
ALTER TABLE firma.pensja_stanowisko
    ADD PRIMARY KEY (id_pensji);    
ALTER TABLE firma.premia
    ADD PRIMARY KEY (id_premii);
ALTER TABLE firma.wynagrodzenie
    ADD PRIMARY KEY (id_wynagrodzenia);

--- c) ---
ALTER TABLE firma.godziny 
	ADD CONSTRAINT fk_pracownicy 
	FOREIGN KEY (id_pracownika) 
	REFERENCES firma.pracownicy (id_pracownika);
ALTER TABLE firma.wynagrodzenie 
	ADD CONSTRAINT fk_pracownicy 
	FOREIGN KEY (id_pracownika) 
	REFERENCES firma.pracownicy (id_pracownika);
ALTER TABLE firma.wynagrodzenie 
	ADD CONSTRAINT fk_godziny 
	FOREIGN KEY (id_godziny) 
	REFERENCES firma.godziny (id_godziny);
ALTER TABLE firma.wynagrodzenie 
	ADD CONSTRAINT fk_pensja 
	FOREIGN KEY (id_pensji) 
	REFERENCES firma.pensja_stanowisko (id_pensji);
ALTER TABLE firma.wynagrodzenie 
	ADD CONSTRAINT fk_premia 
	FOREIGN KEY (id_premii) 
	REFERENCES firma.premia (id_premii);

--- d) ---
CREATE INDEX idx_prac ON firma.pracownicy(id_pracownika);
CREATE INDEX idx_godz ON firma.godziny(id_godziny);
CREATE INDEX idx_pensja ON firma.pensja_stanowisko(id_pensji);
CREATE INDEX idx_premia ON firma.premia(id_premii);
CREATE INDEX idx_wyn ON firma.wynagrodzenie(id_wynagrodzenia);

--- e) ---
COMMENT ON TABLE firma.godziny IS 'Tabela z godzinami pracy';
COMMENT ON TABLE firma.pensja_stanowisko IS 'Tabela laczaca pensje ze stanowiskiem';
COMMENT ON TABLE firma.pracownicy IS 'Tabela z danymi o pracownikach';
COMMENT ON TABLE firma.premia IS 'Tabela z informacjami o premii';
COMMENT ON TABLE firma.wynagrodzenie IS 'Tabela z informacjami o wynagrodzeniu';

--- f) ---
ALTER TABLE firma.pracownicy DISABLE TRIGGER ALL;
ALTER TABLE firma.godziny DISABLE TRIGGER ALL;
ALTER TABLE firma.wynagrodzenie DISABLE TRIGGER ALL;
ALTER TABLE firma.pensja_stanowisko DISABLE TRIGGER ALL;
ALTER TABLE firma.premia DISABLE TRIGGER ALL;


--- zad 5. ---
--- a) ---
ALTER TABLE firma.godziny 
	ADD COLUMN miesiac integer NOT NULL CHECK(miesiac < 13), 
	ADD COLUMN numer_tygodnia integer NOT NULL CHECK(numer_tygodnia < 54);

--- b) ---
ALTER TABLE firma.wynagrodzenie
	ALTER COLUMN data TYPE TEXT;

--- zad 6. ---
--- a) ---
SELECT id_pracownika, nazwisko FROM firma.pracownicy;
--- b) ---
SELECT p.id_pracownika FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	WHERE g.liczba_godzin*ps.kwota+pr.kwota > 1000;
--- c) ---
SELECT p.id_pracownika FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	WHERE g.liczba_godzin*ps.kwota > 2000 AND pr.kwota = 0;
--- d) ---
SELECT * FROM firma.pracownicy WHERE imie LIKE 'J%';
--- e) ---
SELECT * FROM firma.pracownicy WHERE nazwisko LIKE '%n%' AND imie LIKE '%a';
--- f) ---
SELECT p.* FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	WHERE g.liczba_godzin*ps.kwota > 1500 AND g.liczba_godzin*ps.kwota < 3000;

--- zad 7. ---
--- a) ---
SELECT p.* FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	ORDER BY ps.kwota;
--- b) ---
SELECT p.* FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	ORDER BY g.liczba_godzin*ps.kwota+pr.kwota DESC;
--- c) ---
SELECT count(*) FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	GROUP BY ps.stanowisko; 
--- d) ---
SELECT min(ps.kwota),max(ps.kwota),avg(ps.kwota) FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	WHERE ps.stanowisko LIKE 'kierownik'; 
--- e) ---
SELECT sum(g.liczba_godzin*ps.kwota+pr.kwota) FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii; 
--- f) ---
SELECT sum(g.liczba_godzin*ps.kwota+pr.kwota) FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	GROUP BY ps.stanowisko; 
--- g) ---
SELECT count(pr.id_premii) FROM firma.pracownicy p
	JOIN firma.wynagrodzenie w ON w.id_pracownika=p.id_pracownika
	JOIN firma.pensja_stanowisko ps ON w.id_pensji=ps.id_pensji
	JOIN firma.godziny g ON w.id_godziny=g.id_godziny
	JOIN firma.premia pr ON w.id_premii=pr.id_premii
	GROUP BY ps.stanowisko;

--- zad 8. ---
--- a) ---
UPDATE firma.pracownicy SET telefon='(+48)' || telefon;
--- b) ---
UPDATE firma.pracownicy SET telefon=substring(telefon, 1, 5) || substring(telefon, 6, 3) || '-' || substring(telefon, 10,3) || '-' || substring(telefon, 14, 3);
-- c) ---
SELECT * FROM firma.pracownicy WHERE character_length(nazwisko)=(SELECT MAX(character_length(nazwisko)) FROM firma.pracownicy);
--- d) ---
SELECT MD5(CONCAT(p.id_pracownika, p.imie, p.nazwisko, p.adres, p.telefon, ps.kwota)) FROM firma.pracownicy p 
	JOIN firma.wynagrodzenie w ON w.id_pracownika = p.id_pracownika 
	JOIN firma.pensja_stanowisko ps ON ps.id_pensji = w.id_pensji;
	
--- zad 9. ---
SELECT CONCAT('Pracownik ', p.imie, ' ', p.nazwisko, 
			  ', w dniu ', g.data,' otrzymal pensje calkowita na kwote ', (ps.kwota + pr.kwota), 
			  ', gdzie wynagrodzenie zasadnicze wynosilo: ', 
			  ps.kwota * g.liczba_godzin, ' zl, premia:', pr.kwota, ' zl, liczba nadgodzin: ', 
			  (CASE WHEN g.liczba_godzin <= 160 THEN 0 ELSE (g.liczba_godzin-160) END)) 
	FROM firma.pracownicy p JOIN firma.wynagrodzenie w ON w.id_pracownika = p.id_pracownika 
		JOIN firma.godziny g ON g.id_godziny = w.id_godziny 
		JOIN firma.pensja_stanowisko ps ON w.id_pensji = ps.id_pensji 
		JOIN firma.premia pr ON pr.id_premii = w.id_premii;
