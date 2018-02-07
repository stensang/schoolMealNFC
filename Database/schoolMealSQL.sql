ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_klass_ID;
ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_opilase_seisundi_liik_kood;
ALTER TABLE Opilase_soogikorrad DROP CONSTRAINT FK_opilase_soogikorrad_opilane_ID;
ALTER TABLE Opilase_soogikorrad DROP CONSTRAINT FK_opilase_soogikorrad_soogikorra_ID;
ALTER TABLE Tootaja_ametid DROP CONSTRAINT FK_tootaja_ametid_amet_kood;
ALTER TABLE Tootaja_ametid DROP CONSTRAINT FK_tootaja_ametid_tootaja_ID;
ALTER TABLE Tootaja DROP CONSTRAINT FK_tootaja_tootaja_seisundi_liik_kood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_tootaja_ID;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_klassi_seisundi_liik_kood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_kooliaste_kood;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_tootaja_ID;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_soogikorra_seisundi_liik_kood;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_soogikorra_liik_kood;

DROP INDEX IF EXISTS IDX_tootaja_ametid_amet_kood
DROP INDEX IF EXISTS IDX_tootaja_ametid_tootaja_ID
DROP INDEX IF EXISTS IDX_tootaja_tootaja_seisundi_liik_kood
DROP INDEX IF EXISTS IDX_opilase_soogikorrad_opilane_ID
DROP INDEX IF EXISTS IDX_opilase_soogikorrad_soogikorra_ID
DROP INDEX IF EXISTS IDX_opilane_opilase_seisundi_liik_kood
DROP INDEX IF EXISTS IDX_opilane_klass_ID
DROP INDEX IF EXISTS IDX_soogikord_soogikorra_seisundi_liik_kood
DROP INDEX IF EXISTS IDX_soogikord_soogikorra_liik_kood
DROP INDEX IF EXISTS IDX_soogikord_tootaja_ID
DROP INDEX IF EXISTS IDX_klass_kooliaste_kood
DROP INDEX IF EXISTS IDX_klass_klassi_seisundi_liik_kood
DROP INDEX IF EXISTS IDX_klass_tootaja_ID

DROP TABLE IF EXISTS Soogikorra_liik;
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

CREATE TABLE Tootaja (
	tootaja_ID SERIAL NOT NULL,
	epost VARCHAR ( 255 ) NOT NULL,
	parool VARCHAR ( 255 ) NOT NULL,
	tootaja_seisundi_liik_kood SMALLINT NOT NULL,
	CONSTRAINT AK_tootaja_epost UNIQUE (epost),
	CONSTRAINT PK_tootaja PRIMARY KEY (tootaja_ID)
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
	tootaja_ID INTEGER NOT NULL,
	kooliaste_kood SMALLINT NOT NULL,
	klassi_seisundi_liik_kood SMALLINT NOT NULL,
	CONSTRAINT PK_klass PRIMARY KEY (klass_ID),
	CONSTRAINT AK_klass_nimetus UNIQUE (nimetus)
	);
CREATE INDEX IDX_klass_kooliaste_kood ON Klass (kooliaste_kood );
CREATE INDEX IDX_klass_klassi_seisundi_liik_kood ON Klass (klassi_seisundi_liik_kood );
CREATE INDEX IDX_klass_tootaja_ID ON Klass (tootaja_ID );
CREATE TABLE Opilane (
	opilane_ID SERIAL NOT NULL,
	UID INTEGER NOT NULL,
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
	tootaja_ID INTEGER NOT NULL,
	soogikorra_seisundi_liik_kood SMALLINT NOT NULL,
	soogikorra_liik_kood SMALLINT NOT NULL,
	kuupaev DATE NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT PK_soogikord PRIMARY KEY (soogikorra_ID)
	);
CREATE INDEX IDX_soogikord_soogikorra_seisundi_liik_kood ON Soogikord (soogikorra_seisundi_liik_kood );
CREATE INDEX IDX_soogikord_soogikorra_liik_kood ON Soogikord (soogikorra_liik_kood );
CREATE INDEX IDX_soogikord_tootaja_ID ON Soogikord (tootaja_ID );
CREATE TABLE Opilase_seisundi_liik (
	opilase_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ),
	CONSTRAINT AK_opilase_seisundi_liik UNIQUE (nimetus),
	CONSTRAINT PK_opilase_seisundi_liik PRIMARY KEY (opilase_seisundi_liik_kood)
	);
CREATE TABLE Tootaja_ametid (
	tootaja_amet_kood SERIAL NOT NULL,
	tootaja_ID SMALLINT NOT NULL,
	amet_kood SMALLINT NOT NULL,
	CONSTRAINT PK_tootaja_ametid PRIMARY KEY (tootaja_amet_kood)
	);
CREATE INDEX IDX_tootaja_ametid_amet_kood ON Tootaja_ametid (amet_kood );
CREATE INDEX IDX_tootaja_ametid_tootaja_ID ON Tootaja_ametid (tootaja_ID );

ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_klass_ID FOREIGN KEY (klass_ID) REFERENCES Klass (klass_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_opilase_seisundi_liik_kood FOREIGN KEY (opilase_seisundi_liik_kood) REFERENCES Opilase_seisundi_liik (opilase_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_opilane_ID FOREIGN KEY (opilane_ID) REFERENCES Opilane (opilane_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_soogikorra_ID FOREIGN KEY (soogikorra_ID) REFERENCES Soogikord (soogikorra_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_amet_kood FOREIGN KEY (amet_kood) REFERENCES Amet (amet_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_tootaja_ID FOREIGN KEY (tootaja_ID) REFERENCES Tootaja (tootaja_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja ADD CONSTRAINT FK_tootaja_tootaja_seisundi_liik_kood FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES Tootaja_seisundi_liik (tootaja_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_tootaja_ID FOREIGN KEY (tootaja_ID) REFERENCES Tootaja (tootaja_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_klassi_seisundi_liik_kood FOREIGN KEY (klassi_seisundi_liik_kood) REFERENCES Klassi_seisundi_liik (klassi_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_kooliaste_kood FOREIGN KEY (kooliaste_kood) REFERENCES Kooliaste (kooliaste_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_tootaja_ID FOREIGN KEY (tootaja_ID) REFERENCES Tootaja (tootaja_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_soogikorra_seisundi_liik_kood FOREIGN KEY (soogikorra_seisundi_liik_kood) REFERENCES Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_soogikorra_liik_kood FOREIGN KEY (soogikorra_liik_kood) REFERENCES Soogikorra_liik (soogikorra_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;

INSERT INTO Amet (amet_kood, nimetus) VALUES (1345, 'koolidirektor');
INSERT INTO Amet (amet_kood, nimetus) VALUES (2341, 'õpetaja');
INSERT INTO Amet (amet_kood, nimetus) VALUES (1219, 'majandusala juhataja');

INSERT INTO Tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (0, 'Töölt lahkunud');
INSERT INTO Tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (1, 'Tööl');

INSERT INTO Kooliaste (kooliaste_kood, nimetus, kirjeldus) VALUES (1, 'I kooliaste', '1.–3. klass');
INSERT INTO Kooliaste (kooliaste_kood, nimetus, kirjeldus) VALUES (2, 'II kooliaste', '4.–6. klass');
INSERT INTO Kooliaste (kooliaste_kood, nimetus, kirjeldus) VALUES (3, 'III kooliaste', '7.–9. klass');

INSERT INTO Soogikorra_liik (soogikorra_liik_kood, nimetus) VALUES (1, 'Hommikusöök');
INSERT INTO Soogikorra_liik (soogikorra_liik_kood, nimetus) VALUES (2, 'Lõunasöök');
INSERT INTO Soogikorra_liik (soogikorra_liik_kood, nimetus) VALUES (3, 'Lisaeine');

INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (1, 'Koostamisel');
INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (2, 'Avalikustatud');
INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (3, 'Lõpetatud');
INSERT INTO Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood, nimetus) VALUES (4, 'Arhiveeritud');
