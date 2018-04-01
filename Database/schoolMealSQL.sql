DROP VIEW IF EXISTS Soogikorrad_klasside_registreerimised CASCADE;
DROP VIEW IF EXISTS Opilaste_registreerimiste_koondtabel CASCADE;
DROP VIEW IF EXISTS Opilaste_registreerimised CASCADE;
DROP VIEW IF EXISTS Soogikordade_koondtabel CASCADE;
DROP VIEW IF EXISTS Opilaste_koondtabel CASCADE;
DROP VIEW IF EXISTS Soogikorrad_registreerimisele_avatud CASCADE;
DROP VIEW IF EXISTS Klass_opilasi_klassis CASCADE;

ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_klass_ID;
ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_opilase_seisundi_liik_kood;
ALTER TABLE Opilase_soogikorrad DROP CONSTRAINT FK_opilase_soogikorrad_isikukood;
ALTER TABLE Opilase_soogikorrad DROP CONSTRAINT FK_opilase_soogikorrad_soogikorra_ID;
ALTER TABLE Tootaja_ametid DROP CONSTRAINT FK_tootaja_ametid_amet_kood;
ALTER TABLE Tootaja_ametid DROP CONSTRAINT FK_tootaja_ametid_isikukood;
ALTER TABLE Tootaja DROP CONSTRAINT FK_tootaja_tootaja_seisundi_liik_kood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_isikukood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_klassi_seisundi_liik_kood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_kooliaste_kood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_soojate_grupp_kood;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_isikukood;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_soogikorra_seisundi_liik_kood;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_soogikorra_liik_kood;

DROP INDEX IF EXISTS IDX_tootaja_ametid_amet_kood;
DROP INDEX IF EXISTS IDX_tootaja_ametid_isikukood;
DROP INDEX IF EXISTS IDX_tootaja_tootaja_seisundi_liik_kood;
DROP INDEX IF EXISTS IDX_opilase_soogikorrad_isikukood;
DROP INDEX IF EXISTS IDX_opilase_soogikorrad_soogikorra_ID;
DROP INDEX IF EXISTS IDX_opilane_opilase_seisundi_liik_kood;
DROP INDEX IF EXISTS IDX_opilane_klass_ID;
DROP INDEX IF EXISTS IDX_soogikord_soogikorra_seisundi_liik_kood;
DROP INDEX IF EXISTS IDX_soogikord_soogikorra_liik_kood;
DROP INDEX IF EXISTS IDX_soogikord_isikukood;
DROP INDEX IF EXISTS IDX_klass_kooliaste_kood;
DROP INDEX IF EXISTS IDX_klass_klassi_seisundi_liik_kood;
DROP INDEX IF EXISTS IDX_klass_isikukood;
DROP INDEX IF EXISTS IDX_klass_soojate_grupp_kood;

DROP TABLE IF EXISTS Soogikorra_liik CASCADE;
DROP TABLE IF EXISTS Opilane;
DROP TABLE IF EXISTS Kooliaste;
DROP TABLE IF EXISTS Opilase_seisundi_liik;
DROP TABLE IF EXISTS Opilase_soogikorrad;
DROP TABLE IF EXISTS Amet;
DROP TABLE IF EXISTS Soogikorra_seisundi_liik;
DROP TABLE IF EXISTS Tootaja_ametid;
DROP TABLE IF EXISTS Tootaja;
DROP TABLE IF EXISTS Klass;
DROP TABLE IF EXISTS Soogikord;
DROP TABLE IF EXISTS Tootaja_seisundi_liik;
DROP TABLE IF EXISTS Klassi_seisundi_liik;
DROP TABLE IF EXISTS Soojate_grupp;

DROP DOMAIN IF EXISTS d_nimetus;
DROP DOMAIN IF EXISTS d_kirjeldus;
CREATE DOMAIN d_nimetus AS VARCHAR ( 50 ) NOT NULL CHECK (VALUE!~'^[[:space:]]*$');
CREATE DOMAIN d_kirjeldus AS VARCHAR ( 200 ) CHECK (VALUE!~'^[[:space:]]*$');

CREATE TABLE Isik (
	isikukood CHAR ( 11 ) NOT NULL,
	eesnimi VARCHAR ( 100 ) NOT NULL,
	perekonnanimi VARCHAR ( 100 ) NOT NULL,
	CONSTRAINT PK_isik PRIMARY KEY (isikukood),
	CONSTRAINT CHK_isik_isikukood CHECK (isikukood~'^([3-6]{1}[[:digit:]]{2}[0-1]{1}[[:digit:]]{1}[0-3]{1}[[:digit:]]{5})$'),
	CONSTRAINT CHK_isik_perekonnanimi_ei_koosne_numbritest CHECK (perekonnanimi!~'^.*[[:digit:]].*$'),
	CONSTRAINT CHK_isik_perekonnanimi_ei_koosne_tyhikutest CHECK (perekonnanimi!~'^[[:space:]]*$'),
	CONSTRAINT CHK_isik_eesnimi_ei_koosne_tyhikutest CHECK (eesnimi!~'^[[:space:]]*$'),
	CONSTRAINT CHK_isik_eesnimi_ei_koosne_numbritest CHECK (eesnimi!~'^.*[[:digit:]].*$')
);
CREATE TABLE Tootaja (
	isikukood CHAR ( 11 ) NOT NULL,
	epost VARCHAR ( 100 ) NOT NULL,
	parool VARCHAR ( 60 ) NOT NULL,
	tootaja_seisundi_liik_kood SMALLINT DEFAULT 1 NOT NULL,
	CONSTRAINT PK_tootaja PRIMARY KEY (isikukood),
	CONSTRAINT CHK_tootaja_epost_ei_koosne_tyhikutest CHECK (epost!~'^[[:space:]]*$'),
	CONSTRAINT CHK_tootaja_epost CHECK (epost~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
	);
CREATE INDEX IDX_tootaja_tootaja_seisundi_liik_kood ON Tootaja (tootaja_seisundi_liik_kood );
CREATE TABLE Tootaja_seisundi_liik (
	tootaja_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT PK_tootaja_seisundi_liik PRIMARY KEY (tootaja_seisundi_liik_kood),
	CONSTRAINT AK_tootaja_seisundi_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Soogikorra_liik (
	soogikorra_liik_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT PK_soogikorra_liik PRIMARY KEY (soogikorra_liik_kood),
	CONSTRAINT AK_soogikorra_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Opilase_soogikorrad (
	opilase_soogikorra_ID SERIAL NOT NULL,
	soogikorra_ID SMALLINT NOT NULL,
	isikukood CHAR ( 11 ) NOT NULL,
	registreerimise_kuupaev DATE NOT NULL,
	CONSTRAINT PK_opilase_soogikorrad PRIMARY KEY (opilase_soogikorra_ID),
	CONSTRAINT AK_Opilase_soogikorrad_soogikorra_id_isikukood UNIQUE (soogikorra_ID, isikukood)
	);
CREATE INDEX IDX_opilase_soogikorrad_isikukood ON Opilase_soogikorrad (isikukood );
CREATE INDEX IDX_opilase_soogikorrad_soogikorra_ID ON Opilase_soogikorrad (soogikorra_ID );
CREATE TABLE Klass (
	klass_ID SERIAL NOT NULL,
	nimetus D_NIMETUS,
	isikukood VARCHAR ( 11 ) NOT NULL,
	kooliaste_kood SMALLINT NOT NULL,
	klassi_seisundi_liik_kood SMALLINT NOT NULL,
	soojate_grupp_kood SMALLINT NOT NULL,
	CONSTRAINT PK_klass PRIMARY KEY (klass_ID),
	CONSTRAINT AK_klass_nimetus UNIQUE (nimetus)
	);
CREATE INDEX IDX_klass_kooliaste_kood ON Klass (kooliaste_kood );
CREATE INDEX IDX_klass_klassi_seisundi_liik_kood ON Klass (klassi_seisundi_liik_kood );
CREATE INDEX IDX_klass_isikukood ON Klass (isikukood );
CREATE INDEX IDX_klass_soojate_grupp_kood ON Klass (soojate_grupp_kood);
CREATE TABLE Opilane (
	isikukood CHAR ( 11 ) NOT NULL,
	UID VARCHAR ( 15 ) NOT NULL,
	opilase_seisundi_liik_kood SMALLINT NOT NULL,
	klass_ID SMALLINT NOT NULL,
	CONSTRAINT AK_opilane_UID UNIQUE (UID),
	CONSTRAINT PK_opilane PRIMARY KEY (isikukood)
	);
CREATE INDEX IDX_opilane_opilase_seisundi_liik_kood ON Opilane (opilase_seisundi_liik_kood );
CREATE INDEX IDX_opilane_klass_ID ON Opilane (klass_ID );
CREATE TABLE Klassi_seisundi_liik (
	klassi_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT AK_klassi_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_klassi_seisundi_liik PRIMARY KEY (klassi_seisundi_liik_kood)
	);
CREATE TABLE Soogikorra_seisundi_liik (
	soogikorra_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT PK_soogikorra_seisundi_liik PRIMARY KEY (soogikorra_seisundi_liik_kood),
	CONSTRAINT AK_soogikorra_seisundi_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Kooliaste (
	kooliaste_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT AK_kooliaste_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_kooliaste PRIMARY KEY (kooliaste_kood)
	);
CREATE TABLE Amet (
	amet_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT AK_amet_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_amet PRIMARY KEY (amet_kood)
	);
CREATE TABLE Soogikord (
	soogikorra_ID SERIAL NOT NULL,
	isikukood VARCHAR ( 11 ) NOT NULL,
	soogikorra_seisundi_liik_kood SMALLINT NOT NULL,
	soogikorra_liik_kood SMALLINT NOT NULL,
	kuupaev DATE NOT NULL,
	vaikimisi BOOLEAN NOT NULL,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT PK_soogikord PRIMARY KEY (soogikorra_ID)
	);
CREATE TABLE Soojate_grupp (
	soojate_grupp_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT AK_soojate_grupp_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_soojate_grupp PRIMARY KEY (soojate_grupp_kood)
	);
CREATE INDEX IDX_soogikord_soogikorra_seisundi_liik_kood ON Soogikord (soogikorra_seisundi_liik_kood );
CREATE INDEX IDX_soogikord_soogikorra_liik_kood ON Soogikord (soogikorra_liik_kood );
CREATE INDEX IDX_soogikord_isikukood ON Soogikord (isikukood );
CREATE TABLE Opilase_seisundi_liik (
	opilase_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus D_NIMETUS,
	kirjeldus D_KIRJELDUS,
	CONSTRAINT AK_opilase_seisundi_liik UNIQUE (nimetus),
	CONSTRAINT PK_opilase_seisundi_liik PRIMARY KEY (opilase_seisundi_liik_kood)
	);
CREATE TABLE Tootaja_ametid (
	tootaja_amet_id SERIAL NOT NULL,
	isikukood VARCHAR ( 11 ) NOT NULL,
	amet_kood SMALLINT NOT NULL,
	CONSTRAINT PK_tootaja_ametid PRIMARY KEY (tootaja_amet_id)
	);
CREATE INDEX IDX_tootaja_ametid_amet_kood ON Tootaja_ametid (amet_kood );
CREATE INDEX IDX_tootaja_ametid_isikukood ON Tootaja_ametid (isikukood );

ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_isikukood FOREIGN KEY (isikukood) REFERENCES Isik (isikukood) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_klass_ID FOREIGN KEY (klass_ID) REFERENCES Klass (klass_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_opilase_seisundi_liik_kood FOREIGN KEY (opilase_seisundi_liik_kood) REFERENCES Opilase_seisundi_liik (opilase_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_isikukood FOREIGN KEY (isikukood) REFERENCES Opilane (isikukood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_soogikorra_ID FOREIGN KEY (soogikorra_ID) REFERENCES Soogikord (soogikorra_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_amet_id FOREIGN KEY (amet_kood) REFERENCES Amet (amet_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_isikukood FOREIGN KEY (isikukood) REFERENCES Tootaja (isikukood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja ADD CONSTRAINT FK_tootaja_isikukood FOREIGN KEY (isikukood) REFERENCES Isik (isikukood) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE Tootaja ADD CONSTRAINT FK_tootaja_tootaja_seisundi_liik_kood FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES Tootaja_seisundi_liik (tootaja_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_isikukood FOREIGN KEY (isikukood) REFERENCES Tootaja (isikukood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_klassi_seisundi_liik_kood FOREIGN KEY (klassi_seisundi_liik_kood) REFERENCES Klassi_seisundi_liik (klassi_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_kooliaste_kood FOREIGN KEY (kooliaste_kood) REFERENCES Kooliaste (kooliaste_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_soojate_grupp_kood FOREIGN KEY (soojate_grupp_kood) REFERENCES Soojate_grupp (soojate_grupp_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_isikukood FOREIGN KEY (isikukood) REFERENCES Tootaja (isikukood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_soogikorra_seisundi_liik_kood FOREIGN KEY (soogikorra_seisundi_liik_kood) REFERENCES Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_soogikorra_liik_kood FOREIGN KEY (soogikorra_liik_kood) REFERENCES Soogikorra_liik (soogikorra_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;

-- VIEWS

-- Tuleb mõelda parem süsteem, sest tabeli suurenedes läheb päringuks palju aega
CREATE VIEW Soogikorrad_klasside_registreerimised AS
SELECT
	opilase_soogikorrad.soogikorra_id,
	opilane.klass_id,
	COUNT(*) as opilasi_registreeritud
FROM opilase_soogikorrad
	INNER JOIN opilane ON opilase_soogikorrad.isikukood = opilane.isikukood
GROUP BY
	opilase_soogikorrad.soogikorra_id,
	opilane.klass_id;

CREATE VIEW Opilaste_registreerimiste_koondtabel AS
SELECT
	s.soogikorra_id,
	sl.nimetus,
	os.isikukood,
	s.kuupaev
FROM opilase_soogikorrad os
	INNER JOIN soogikord s ON os.soogikorra_id = s.soogikorra_id
	INNER JOIN soogikorra_liik sl ON s.soogikorra_liik_kood = sl.soogikorra_liik_kood;

-- Tuleb mõelda parem süsteem, sest tabeli suurenedes läheb päringuks palju aega.
CREATE VIEW Opilaste_registreerimised AS
SELECT
	os.isikukood,
	to_char(s.kuupaev,'YYYY-MM') as kuu,
	sl.nimetus,
	COUNT(*) AS registreerimised
FROM Opilase_soogikorrad os
	INNER JOIN soogikord s ON os.soogikorra_id = s.soogikorra_id
	INNER JOIN soogikorra_liik sl ON s.soogikorra_liik_kood = sl.soogikorra_liik_kood
GROUP BY 1, 2, 3;

CREATE VIEW Soogikordade_koondtabel AS
SELECT
 	s.soogikorra_id,
 	s.isikukood,
  sl.nimetus,
  s.kuupaev,
  s.kirjeldus,
  s.vaikimisi,
  ssl.nimetus as seisund
FROM soogikord s
 	INNER JOIN soogikorra_liik sl ON s.soogikorra_liik_kood = sl.soogikorra_liik_kood
  INNER JOIN soogikorra_seisundi_liik ssl ON s.soogikorra_seisundi_liik_kood = ssl.soogikorra_seisundi_liik_kood;

CREATE VIEW Opilaste_koondtabel AS
SELECT
	o.isikukood,
	i.eesnimi,
	i.perekonnanimi,
	k.nimetus as klass
FROM opilane o
		INNER JOIN Isik i ON o.isikukood = i.isikukood
		INNER JOIN Klass k ON o.klass_id = k.klass_id
WHERE
	k.klassi_seisundi_liik_kood = 1;

 CREATE VIEW Soogikorrad_registreerimisele_avatud AS
 SELECT
	 Soogikord.soogikorra_id,
	 Soogikorra_liik.nimetus,
	 Soogikord.vaikimisi
 FROM Soogikord
 	INNER JOIN Soogikorra_liik ON Soogikord.soogikorra_liik_kood = Soogikorra_liik.soogikorra_liik_kood
 WHERE
 	Soogikord.soogikorra_seisundi_liik_kood = 3;

 CREATE VIEW Klass_opilasi_klassis AS
 SELECT
 	klass.klass_id,
 	klass.nimetus,
 	klass.soojate_grupp_kood,
 	count(*) as opilasi_klassis
 FROM Klass
 	INNER JOIN Opilane ON klass.klass_id = opilane.klass_id
 WHERE
 	opilane.opilase_seisundi_liik_kood = 1
 GROUP BY
 	klass.klass_id,
	klass.nimetus;


-- SAMPLE DATA

INSERT INTO Amet (amet_kood, nimetus) VALUES (1345, 'koolidirektor');
INSERT INTO Amet (amet_kood, nimetus) VALUES (2341, 'õpetaja');
INSERT INTO Amet (amet_kood, nimetus) VALUES (1219, 'majandusala juhataja');

INSERT INTO Tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (0, 'Töölt lahkunud');
INSERT INTO Tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (1, 'Tööl');

INSERT INTO Kooliaste (kooliaste_kood, nimetus, kirjeldus) VALUES (1, 'I kooliaste', '1.–3. klass');
INSERT INTO Kooliaste (kooliaste_kood, nimetus, kirjeldus) VALUES (2, 'II kooliaste', '4.–6. klass');
INSERT INTO Kooliaste (kooliaste_kood, nimetus, kirjeldus) VALUES (3, 'III kooliaste', '7.–9. klass');

INSERT INTO Soojate_grupp (soojate_grupp_kood, nimetus, kirjeldus) VALUES (1, 'I kooliaste', '1.–3. klass');
INSERT INTO Soojate_grupp (soojate_grupp_kood, nimetus, kirjeldus) VALUES (2, 'II kooliaste', '4.–6. klass');
INSERT INTO Soojate_grupp (soojate_grupp_kood, nimetus, kirjeldus) VALUES (3, 'III kooliaste', '7.–9. klass');

INSERT INTO Soogikorra_liik (soogikorra_liik_kood, nimetus) VALUES (1, 'Hommikusöök');
INSERT INTO Soogikorra_liik (soogikorra_liik_kood, nimetus) VALUES (2, 'Lõunasöök');
INSERT INTO Soogikorra_liik (soogikorra_liik_kood, nimetus) VALUES (3, 'Lisaeine');

INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (0, 'Arhiveeritud');
INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (1, 'Koostamisel');
INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (2, 'Kinnitatud');
INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (3, 'Registreerimine avatud');
INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (4, 'Registreerimine suletud');

-- Nimed genereeritud tööriistaga http://namegenerators.org/estonian-male-name-generator-ee/
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('38001010014', 'Eino', 'Öpik');

INSERT INTO Tootaja (isikukood, epost, parool, tootaja_seisundi_liik_kood) VALUES ('38001010014', 'eino.opik@epost.ee', 'Trustno1', 1);
INSERT INTO Tootaja_ametid (isikukood, amet_kood) VALUES ('38001010014', 1219);
INSERT INTO Tootaja_ametid (isikukood, amet_kood) VALUES ('38001010014', 2341);

INSERT INTO Soogikord (soogikorra_ID, isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus) VALUES (1, '38001010014', 3, 2, '2018-03-17', '1', 'Kirjeldus ...');
INSERT INTO Soogikord (soogikorra_ID, isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus) VALUES (2, '38001010014', 3, 3, '2018-03-17', '0', 'Kirjeldus ...');
INSERT INTO Soogikord (soogikorra_ID, isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus) VALUES (3, '38001010014', 3, 1, '2018-03-17', '0', 'Kirjeldus ...');

INSERT INTO Klassi_seisundi_liik (klassi_seisundi_liik_kood, nimetus) VALUES (0, 'lõpetanud');
INSERT INTO Klassi_seisundi_liik (klassi_seisundi_liik_kood, nimetus) VALUES (1, 'aktiivne');

INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (1, '1. klass', '38001010014', 2, 1, 1);
INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (2, '2. klass', '38001010014', 2, 1, 1);
INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (3, '3. klass', '38001010014', 2, 1, 1);

INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (4, '4. klass', '38001010014', 2, 1, 2);
INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (5, '5. klass', '38001010014', 2, 1, 2);
INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (6, '6. klass', '38001010014', 2, 1, 2);

INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (7, '7. klass', '38001010014', 2, 1, 3);
INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (8, '8. klass', '38001010014', 2, 1, 3);
INSERT INTO Klass (klass_ID, nimetus, isikukood, kooliaste_kood, klassi_seisundi_liik_kood, soojate_grupp_kood) VALUES (9, '9. klass', '38001010014', 2, 1, 3);

INSERT INTO Opilase_seisundi_liik (opilase_seisundi_liik_kood, nimetus) VALUES (0, 'lõpetanud');
INSERT INTO Opilase_seisundi_liik (opilase_seisundi_liik_kood, nimetus) VALUES (1, 'õpib');

-- Nimed genereeritud tööriistaga http://namegenerators.org/estonian-male-name-generator-ee/
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('51101011010', 'Jaanus', 'Orav');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('61102022020', 'Katriin', 'Kalda');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('51003033030', 'Arvi', 'Kukk');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('61004044040', 'Ave', 'Jänes');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('50905055050', 'Ilmar', 'Nurmsalu');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('60906066060', 'Jaana', 'Kesküla');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('50807077070', 'Indrek', 'Aasmäe');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('60808088080', 'Marta', 'Kalda');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('50709099090', 'Joonas', 'Jakobson');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('60710101100', 'Mariliis', 'Vitsut');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('50611111110', 'Timmo', 'Ilves');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('60612121120', 'Kaia', 'Rüütli');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('50501111100', 'Eduard', 'Piip');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('60502121210', 'Janne', 'Jõgi');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('50403133130', 'Allar', 'Eskola');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('60404144140', 'Liisa', 'Laurits');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('50305155150', 'Rene', 'Lill');
INSERT INTO Isik (isikukood, eesnimi, perekonnanimi) VALUES ('60306166160', 'Helga', 'Kotka');

INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('51101011010', '13213021943240', 1, 1);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('61102022020', '13213021943241', 1, 1);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('51003033030', '13213021943242', 1, 2);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('61004044040', '13213021943243', 1, 2);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('50905055050', '13213021943244', 1, 3);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('60906066060', '13213021943245', 1, 3);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('50807077070', '13213021943246', 1, 4);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('60808088080', '13213021943247', 1, 4);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('50709099090', '13213021943248', 1, 5);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('60710101100', '13213021943249', 1, 5);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('50611111110', '13213021943250', 1, 6);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('60612121120', '13213021943251', 1, 6);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('50501111100', '13213021943252', 1, 7);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('60502121210', '13213021943253', 1, 7);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('50403133130', '13213021943254', 1, 8);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('60404144140', '13213021943255', 1, 8);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('50305155150', '13213021943256', 1, 9);
INSERT INTO Opilane (isikukood, uid, opilase_seisundi_liik_kood, klass_ID) VALUES ('60306166160', '13213021943257', 1, 9);

INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '51101011010', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (2, '51101011010', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (3, '51101011010', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '61102022020', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '51003033030', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '61004044040', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '50905055050', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '60906066060', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '50807077070', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '60808088080', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '50709099090', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '60710101100', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '50611111110', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '60612121120', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '50501111100', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '60502121210', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '50403133130', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '60404144140', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '50305155150', '2018-03-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, isikukood, registreerimise_kuupaev) VALUES (1, '60306166160', '2018-03-16');

UPDATE Tootaja SET parool = public.crypt(parool,public.gen_salt('bf', 11));

CREATE OR REPLACE FUNCTION f_on_majandusala_juhataja(text, text)
RETURNS boolean AS $$
DECLARE rslt boolean;
BEGIN
SELECT INTO rslt
(parool = public.crypt($2, parool))
FROM Tootaja t INNER JOIN Tootaja_ametid USING (isikukood) WHERE epost=$1 AND amet_kood = 1219 AND tootaja_seisundi_liik_kood = 1;
RETURN coalesce(rslt, FALSE);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE
SET search_path = public, pg_temp;
COMMENT ON FUNCTION f_on_majandusala_juhataja(text, text) IS
'Selle funktsiooni abil autenditakse majandusala juhataja. Funktsiooni väljakutsel on esimene argument e-post ja teine
argument parool. Juhtkonna liikmel on õigus süsteemi siseneda, vaid siis kui tema seisundiks on aktiivne';
