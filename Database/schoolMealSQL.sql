ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_klass_ID;
ALTER TABLE Opilane DROP CONSTRAINT FK_opilane_opilase_seisundi_liik_kood;
ALTER TABLE Opilase_soogikorrad DROP CONSTRAINT FK_opilase_soogikorrad_opilane_ID;
ALTER TABLE Opilase_soogikorrad DROP CONSTRAINT FK_opilase_soogikorrad_soogikorra_ID;
ALTER TABLE Tootaja_ametid DROP CONSTRAINT FK_tootaja_ametid_amet_ID;
ALTER TABLE Tootaja_ametid DROP CONSTRAINT FK_tootaja_ametid_tootaja_ID;
ALTER TABLE Tootaja DROP CONSTRAINT FK_tootaja_tootaja_seisundi_liik_kood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_tootaja_ID;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_klassi_seisundi_liik_kood;
ALTER TABLE Klass DROP CONSTRAINT FK_klass_kooliaste_kood;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_tootaja_ID;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_soogikorra_seisundi_liik_kood;
ALTER TABLE Soogikord DROP CONSTRAINT FK_soogikord_soogikorra_liik_kood;
DROP TABLE Soogikorra_liik;
DROP TABLE Opilane;
DROP TABLE Kooliaste;
DROP TABLE Opilase_seisundi_liik;
DROP TABLE Opilase_soogikorrad;
DROP TABLE Amet;
DROP TABLE Soogikorra_seisundi_liik;
DROP TABLE Tootaja_ametid;
DROP TABLE Tootaja;
DROP TABLE Klass;
DROP TABLE Soogikord;
DROP TABLE Tootaja_seisundi_liik;
DROP TABLE Klassi_seisundi_liik;
CREATE TABLE Tootaja_ametid (
	tootaja_amet_ID SERIAL NOT NULL,
	tootaja_ID INTEGER NOT NULL,
	amet_ID SMALLINT NOT NULL,
	CONSTRAINT PK_tootaja_ametid PRIMARY KEY (tootaja_amet_ID)
	);
CREATE INDEX IDX_tootaja_ametid_amet_ID ON Tootaja_ametid (amet_ID );
CREATE INDEX IDX_tootaja_ametid_tootaja_ID ON Tootaja_ametid (tootaja_ID );
CREATE TABLE Tootaja (
	tootaja_ID SERIAL NOT NULL,
	e-post VARCHAR ( 255 ) NOT NULL,
	parool VARCHAR ( 255 ) NOT NULL,
	tootaja_seisundi_liik_kood SMALLINT NOT NULL,
	CONSTRAINT AK_tootaja_e-post UNIQUE (e-post),
	CONSTRAINT PK_tootaja PRIMARY KEY (tootaja_ID)
	);
CREATE INDEX IDX_tootaja_tootaja_seisundi_liik_kood ON Tootaja (tootaja_seisundi_liik_kood );
CREATE TABLE Tootaja_seisundi_liik (
	tootaja_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT PK_tootaja_seisundi_liik PRIMARY KEY (tootaja_seisundi_liik_kood),
	CONSTRAINT AK_tootaja_seisundi_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Soogikorra_liik (
	soogikorra_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT PK_soogikorra_liik PRIMARY KEY (soogikorra_liik_kood),
	CONSTRAINT AK_soogikorra_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Opilase_soogikorrad (
	opilase_soogikorra_ID SERIAL NOT NULL,
	soogikorra_ID INTEGER NOT NULL,
	opilane_ID INTEGER NOT NULL,
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
CREATE INDEX TC_Klass51 ON Klass (kooliaste_kood );
CREATE INDEX TC_Klass52 ON Klass (klassi_seisundi_liik_kood );
CREATE INDEX TC_Klass53 ON Klass (tootaja_ID );
CREATE TABLE Opilane (
	opilane_ID SERIAL NOT NULL,
	UID INTEGER NOT NULL,
	opilase_seisundi_liik_kood SMALLINT NOT NULL,
	klass_ID INTEGER NOT NULL,
	CONSTRAINT TC_opilane_UID UNIQUE (UID),
	CONSTRAINT PK_opilane PRIMARY KEY (opilane_ID)
	);
CREATE INDEX IDX_opilane_opilase_seisundi_liik_kood ON Opilane (opilase_seisundi_liik_kood );
CREATE INDEX IDX_opilane_klass_ID ON Opilane (klass_ID );
CREATE TABLE Klassi_seisundi_liik (
	klassi_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT AK_klassi_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_klassi_seisundi_liik PRIMARY KEY (klassi_seisundi_liik_kood)
	);
CREATE TABLE Soogikorra_seisundi_liik (
	soogikorra_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT PK_soogikorra_seisundi_liik PRIMARY KEY (soogikorra_seisundi_liik_kood),
	CONSTRAINT AK_soogikorra_seisundi_liik_nimetus UNIQUE (nimetus)
	);
CREATE TABLE Kooliaste (
	kooliaste_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT AK_kooliaste_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_kooliaste PRIMARY KEY (kooliaste_kood)
	);
CREATE TABLE Amet (
	amet_ID SMALLINT NOT NULL,
	nimetus VARCHAR ( 50 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT AK_amet_nimetus UNIQUE (nimetus),
	CONSTRAINT PK_amet PRIMARY KEY (amet_ID)
	);
CREATE TABLE Soogikord (
	soogikorra_ID SERIAL NOT NULL,
	tootaja_ID INTEGER NOT NULL,
	soogikorra_seisundi_liik_kood SMALLINT NOT NULL,
	soogikorra_liik_kood SMALLINT NOT NULL,
	kuupaev DATE NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT PK_soogikord PRIMARY KEY (soogikorra_ID)
	);
CREATE INDEX IDX_soogikord_soogikorra_seisundi_liik_kood ON Soogikord (soogikorra_seisundi_liik_kood );
CREATE INDEX IDX_soogikord_soogikorra_liik_kood ON Soogikord (soogikorra_liik_kood );
CREATE INDEX IDX_soogikord_tootaja_ID ON Soogikord (tootaja_ID );
CREATE TABLE Opilase_seisundi_liik (
	opilase_seisundi_liik_kood SMALLINT NOT NULL,
	nimetus VARCHAR ( 1 ) NOT NULL,
	kirjeldus VARCHAR ( 200 ) NOT NULL,
	CONSTRAINT AK_opilase_seisundi_liik UNIQUE (nimetus),
	CONSTRAINT PK_opilase_seisundi_liik PRIMARY KEY (opilase_seisundi_liik_kood)
	);
ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_klass_ID FOREIGN KEY (klass_ID) REFERENCES Klass (klass_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilane ADD CONSTRAINT FK_opilane_opilase_seisundi_liik_kood FOREIGN KEY (opilase_seisundi_liik_kood) REFERENCES Opilase_seisundi_liik (opilase_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_opilane_ID FOREIGN KEY (opilane_ID) REFERENCES Opilane (opilane_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Opilase_soogikorrad ADD CONSTRAINT FK_opilase_soogikorrad_soogikorra_ID FOREIGN KEY (soogikorra_ID) REFERENCES Soogikord (soogikorra_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_amet_ID FOREIGN KEY (amet_ID) REFERENCES Amet (amet_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja_ametid ADD CONSTRAINT FK_tootaja_ametid_tootaja_ID FOREIGN KEY (tootaja_ID) REFERENCES Tootaja (tootaja_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Tootaja ADD CONSTRAINT FK_tootaja_tootaja_seisundi_liik_kood FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES Tootaja_seisundi_liik (tootaja_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_tootaja_ID FOREIGN KEY (tootaja_ID) REFERENCES Tootaja (tootaja_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_klassi_seisundi_liik_kood FOREIGN KEY (klassi_seisundi_liik_kood) REFERENCES Klassi_seisundi_liik (klassi_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Klass ADD CONSTRAINT FK_klass_kooliaste_kood FOREIGN KEY (kooliaste_kood) REFERENCES Kooliaste (kooliaste_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_tootaja_ID FOREIGN KEY (tootaja_ID) REFERENCES Tootaja (tootaja_ID)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_soogikorra_seisundi_liik_kood FOREIGN KEY (soogikorra_seisundi_liik_kood) REFERENCES Soogikorra_seisundi_liik (soogikorra_seisundi_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE Soogikord ADD CONSTRAINT FK_soogikord_soogikorra_liik_kood FOREIGN KEY (soogikorra_liik_kood) REFERENCES Soogikorra_liik (soogikorra_liik_kood)  ON DELETE NO ACTION ON UPDATE NO ACTION;

