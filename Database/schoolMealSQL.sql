ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_klass_ID;
ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_opilase_seisundi_liik_kood;
ALTER TABLE Opilase_soogikorrad DROP CONSTRAINT FK_opilase_soogikorrad_opilane_ID;
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
DROP INDEX IF EXISTS IDX_opilase_soogikorrad_opilane_ID;
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

CREATE TABLE Tootaja (
	isikukood CHAR ( 11 ) NOT NULL,
	eesnimi VARCHAR ( 255 ) NOT NULL,
	perenimi VARCHAR ( 255 ) NOT NULL,
	epost VARCHAR ( 255 ) NOT NULL,
	parool VARCHAR ( 255 ) NOT NULL,
	tootaja_seisundi_liik_kood SMALLINT NOT NULL,
	CONSTRAINT AK_tootaja_epost UNIQUE (epost),
	CONSTRAINT PK_tootaja PRIMARY KEY (isikukood)
	);
CREATE INDEX IDX_tootaja_tootaja_seisundi_liik_kood ON Tootaja (tootaja_seisundi_liik_kood );
CREATE TABLE Tootaja_seisundi_liik (
	tootaja_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT PK_tootaja_seisundi_liik PRIMARY KEY (tootaja_seisundi_liik_kood),
	CONSTRAINT AK_tootaja_seisundi_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Soogikorra_liik (
	soogikorra_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT PK_soogikorra_liik PRIMARY KEY (soogikorra_liik_kood),
	CONSTRAINT AK_soogikorra_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Opilase_soogikorrad (
	opilase_soogikorra_ID SERIAL NOT NULL,
	soogikorra_ID SMALLINT NOT NULL,
	opilane_ID SMALLINT NOT NULL,
	registreerimise_kuupaev DATE NOT NULL,
	CONSTRAINT PK_opilase_soogikorrad PRIMARY KEY (opilase_soogikorra_ID)
	);
CREATE INDEX IDX_opilase_soogikorrad_opilane_ID ON Opilase_soogikorrad (opilane_ID );
CREATE INDEX IDX_opilase_soogikorrad_soogikorra_ID ON Opilase_soogikorrad (soogikorra_ID );
CREATE TABLE Klass (
	klass_ID SERIAL NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
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
	opilane_ID SERIAL NOT NULL,
	UID VARCHAR (15) NOT NULL,
	opilase_seisundi_liik_kood SMALLINT NOT NULL,
	klass_ID SMALLINT NOT NULL,
	CONSTRAINT TC_opilane_UID UNIQUE (UID),
	CONSTRAINT PK_opilane PRIMARY KEY (opilane_ID)
	);
CREATE INDEX IDX_opilane_opilase_seisundi_liik_kood ON Opilane (opilase_seisundi_liik_kood );
CREATE INDEX IDX_opilane_klass_ID ON Opilane (klass_ID );
CREATE TABLE Klassi_seisundi_liik (
	klassi_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT AK_klassi_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_klassi_seisundi_liik PRIMARY KEY (klassi_seisundi_liik_kood)
	);
CREATE TABLE Soogikorra_seisundi_liik (
	soogikorra_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT PK_soogikorra_seisundi_liik PRIMARY KEY (soogikorra_seisundi_liik_kood),
	CONSTRAINT AK_soogikorra_seisundi_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Kooliaste (
	kooliaste_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT AK_kooliaste_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_kooliaste PRIMARY KEY (kooliaste_kood)
	);
CREATE TABLE Amet (
	amet_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
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
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT PK_soogikord PRIMARY KEY (soogikorra_ID)
	);
CREATE TABLE Soojate_grupp (
	soojate_grupp_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT AK_soojate_grupp_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_soojate_grupp PRIMARY KEY (soojate_grupp_kood)
	);
CREATE INDEX IDX_soogikord_soogikorra_seisundi_liik_kood ON Soogikord (soogikorra_seisundi_liik_kood );
CREATE INDEX IDX_soogikord_soogikorra_liik_kood ON Soogikord (soogikorra_liik_kood );
CREATE INDEX IDX_soogikord_isikukood ON Soogikord (isikukood );
CREATE TABLE Opilase_seisundi_liik (
	opilase_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT AK_opilase_seisundi_liik UNIQUE (nimetus),
	CONSTRAINT PK_opilase_seisundi_liik PRIMARY KEY (opilase_seisundi_liik_kood)
	);
CREATE TABLE Tootaja_ametid (
	tootaja_amet_kood SERIAL NOT NULL,
	isikukood VARCHAR ( 11 ) NOT NULL,
	amet_kood SMALLINT NOT NULL,
	CONSTRAINT PK_tootaja_ametid PRIMARY KEY (tootaja_amet_kood)
	);
CREATE INDEX IDX_tootaja_ametid_amet_kood ON Tootaja_ametid (amet_kood );
CREATE INDEX IDX_tootaja_ametid_isikukood ON Tootaja_ametid (isikukood );

ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_klass_ID FOREIGN KEY (klass_ID) REFERENCES Klass (klass_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_opilase_seisundi_liik_kood FOREIGN KEY (opilase_seisundi_liik_kood) REFERENCES Opilase_seisundi_liik (opilase_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_opilane_ID FOREIGN KEY (opilane_ID) REFERENCES Opilane (opilane_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_soogikorra_ID FOREIGN KEY (soogikorra_ID) REFERENCES Soogikord (soogikorra_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_amet_kood FOREIGN KEY (amet_kood) REFERENCES Amet (amet_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_isikukood FOREIGN KEY (isikukood) REFERENCES Tootaja (isikukood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
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
SELECT opilase_soogikorrad.soogikorra_id, opilane.klass_id, COUNT(*) as opilasi_registreeritud
FROM opilase_soogikorrad JOIN opilane on opilase_soogikorrad.opilane_id = opilane.opilane_id
GROUP BY opilase_soogikorrad.soogikorra_id, opilane.klass_id;

-- MATERIALIZED VIEWS

CREATE MATERIALIZED VIEW Soogikorrad_registreerimisele_avatud AS
SELECT Soogikord.soogikorra_id, Soogikorra_liik.nimetus, Soogikord.vaikimisi
FROM Soogikord JOIN Soogikorra_liik
    ON Soogikord.soogikorra_liik_kood = Soogikorra_liik.soogikorra_liik_kood
WHERE Soogikord.soogikorra_seisundi_liik_kood = 3;

CREATE MATERIALIZED VIEW Klass_opilasi_klassis AS
SELECT klass.klass_id, klass.nimetus, klass.soojate_grupp_kood, count(*) as opilasi_klassis
FROM Klass JOIN Opilane
		ON klass.klass_id = opilane.klass_id
WHERE opilane.opilase_seisundi_liik_kood = 1
GROUP BY klass.klass_id, klass.nimetus;

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

INSERT INTO Tootaja (isikukood, eesnimi, perenimi, epost, parool, tootaja_seisundi_liik_kood) VALUES ('38001010014', 'Eesnimi', 'Perenimi', 'eesnimi.perenimi@epost.ee', 'Trustno1', 1);
INSERT INTO Tootaja_ametid (isikukood, amet_kood) VALUES ('38001010014', 1219);
INSERT INTO Tootaja_ametid (isikukood, amet_kood) VALUES ('38001010014', 2341);

INSERT INTO Soogikord (soogikorra_ID, isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus) VALUES (1, '38001010014', 3, 2, '2018-02-16', '1', 'Kirjeldus ...');
INSERT INTO Soogikord (soogikorra_ID, isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus) VALUES (2, '38001010014', 3, 3, '2018-02-16', '0', 'Kirjeldus ...');
INSERT INTO Soogikord (soogikorra_ID, isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus) VALUES (3, '38001010014', 3, 1, '2018-02-16', '0', 'Kirjeldus ...');

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

INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (1, '13213021943240', 1, 1);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (2, '13213021943241', 1, 1);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (3, '13213021943242', 1, 2);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (4, '13213021943243', 1, 2);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (5, '13213021943244', 1, 3);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (6, '13213021943245', 1, 3);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (7, '13213021943246', 1, 4);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (8, '13213021943247', 1, 4);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (9, '13213021943248', 1, 5);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (10, '13213021943249', 1, 5);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (11, '13213021943250', 1, 6);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (12, '13213021943251', 1, 6);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (13, '13213021943252', 1, 7);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (14, '13213021943253', 1, 7);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (15, '13213021943254', 1, 8);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (16, '13213021943255', 1, 8);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (17, '13213021943256', 1, 9);
INSERT INTO Opilane (opilane_ID, UID, opilase_seisundi_liik_kood, klass_ID) VALUES (18, '13213021943257', 1, 9);

INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 1, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 2, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 3, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 4, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 5, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 6, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 7, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 8, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 9, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 10, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 11, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 12, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 13, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 14, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 15, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 16, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 17, '2018-02-16');
INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (1, 18, '2018-02-16');
