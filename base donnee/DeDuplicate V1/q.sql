--USER 		: M1INFO_10 
--PASSWORD	: M1INFO_10
DROP TABLE NEW_T_JOIN;
DROP TABLE T;
DROP TABLE NEW_T;
DROP TABLE EtudIG;
DROP TABLE EtudIUTV;
CREATE TABLE EtudIUTV (
    id          VARCHAR2(20),
    Nom         VARCHAR2(30),
    Prenom      VARCHAR2(30),
    DateN       DATE,
    Ville       VARCHAR2(30),
    Pays        VARCHAR2(30)
);

CREATE TABLE EtudIG (
    NumE            VARCHAR2(20),
    NomE            VARCHAR2(30),
    PrenE           VARCHAR2(30),
    DN              DATE,
    Vil             VARCHAR2(30),
    Pay             VARCHAR2(30)
);

INSERT INTO EtudIUTV VALUES('i1', 'LE BON', 'Adam', '19/6/2001', 'Epinay sur seine', 'France');
INSERT INTO EtudIUTV VALUES('i2', 'BELLE', 'Clemence', '16/10/1996', 'Nice', 'France');
INSERT INTO EtudIUTV VALUES('i3', 'BELLE', 'C.', '16/10/1996', 'Nice', 'France');
INSERT INTO EtudIG VALUES('g1', 'LE BON', 'Adam', '19/6/2001', 'Epinay-sur-seine', 'France');
INSERT INTO EtudIG VALUES('g2', 'LEBON', 'Adams', '19/6/2001', 'Epinay-sur-seine', 'France');
--=========================================================================================
--  JOIN ALL TABLES IN ONLY ONE TABLE
--=========================================================================================
CREATE TABLE T AS (
    SELECT * FROM EtudIUTV UNION SELECT * FROM EtudIG
    );

SELECT * FROM T;  
