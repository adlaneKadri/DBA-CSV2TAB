-- ===============================================================================
-------- Université Paris 13 Sorbonne Paris Cité, Institut Galiée
-------- Master 2 EID2 - Promotion 2019-2020
-------- Bases de Données Avancées = Advanced Databases (BDA)
-------- Entrepôts de Données = Data Warehouses (DWH)
-------- Lacs de Données = Data Lakes (DL)
-------- La Data ; The Data

-------- La Donnée est le monde du futur ; Les données et le monde de l'avenir
-------- The Data is the world of the future ;  The Data and the future's world

-------- Big Data, Dark Data, Open Data, ... 

-- ===============================================================================

--   Enseignant-Chercheur Responsable        :  Dr. M. Faouzi Boufarès
--   http://www.lipn.univ-paris13.fr/~boufares

-- ===============================================================================
------------- Master 2 EID2 - Promotion 2019-2020

-- Groupe de Travail N° (Binôme)  : Bxy

-- NOM Prénom 1                   : np1
-- NOM Prénom 2                   : np2

-- ===============================================================================

-- ====>>> Votre fichier sql devra s'appeler : Bxy-DDplus.sql

-- ===============================================================================

--   Projet  BDM : Big Data Management - Gestion des Données Massives
--
--   Data Integration (DI) - Intégration de Données
--   Données structurées ; Données Semi-structurées ; Données NON structurées
--   Structured data; Semi-structured data; NON-structured data

--   Master Data Management (MDM) - Gestion des Données de Référence
--   Data Quality Managment (DQM) - Gestion de la qualité des données

--   More semantics to better correct the data 
--   Plus de sémantique afin de mieux corriger les données
-- ===============================================================================
-- =============================================================================== 
--   A new ETL   ETL & DQ : Extract-Transform-Load & Data-Quality 
--                    Al ETL Al Jadyd   
-- ===============================================================================
-- ===============================================================================

 /* 
-- =============================================================================== 
-- =============================================================================== 
-- MISSION IMPOSSIBLE OU POSSIBLE ????? !!!!!!!!!!!
-- Votre mission, si vous l'acceptez, est de : Eliminer... les doubles et les similaires

----------------------------+++-------------------------------------
-- M. Faouzi Boufarès,
-- Maître de Conférences en Informatique
-- Habilité à Diriger des Recherches
-- Université Paris 13, Sorbonne Paris Cité
-- Laboratory LIPN UMR CNRS 7030
-- 99 avenue Jean-Baptiste Clément
-- F-93430 Villetaneuse, France
-- Office: A109
-- Phone: [+33 1]/[01] 49 40 40 71
-- Fax:   [+33 1]/[01] 48 26 07 12
-- Email: boufares@lipn.univ-paris13.fr
-- Web: http://lipn.univ-paris13.fr/~boufares/
----------------------------+++-------------------------------------
-- =============================================================================== 
-- =============================================================================== 
/*
                                      $"   *.      
              mfbmfbmfbmfb                 $&nb sp;   J
                   abc                     4r  "
                   def                    .db
                  g   h                  e" $
         ..ec.. .i     j.              zP   $.zec..
     .^        3*b.     *.           .P" .@"4F      "4
   ."         d"  ^b.    *c        .$"  d"   $         %
  /          P      $.    "c      d"   @     3r         3
 4        .eE........$r===e$$$$eeP    J       *..        b
 $       $$$$$       $   4$$$$$$$     F       d$$$.      4
 $       $$$$$       $   4$$$$$$$     L       *$$$"      4
 4         "      ""3P ===$$$$$$"     3                  P
  *                 $       """        b                J
   ".             .P                    %.             @
     %.         z*"&nbs p;                     ^%.        .r"
        "*==*""                             ^"*==*""   
*/ 


REM ******************************************************************************
REM ******************************************************************************
REM ******************************************************************************
REM *******************  Elimination des doubles exacts  et des similaires *******
REM ******  Algo Data Deduplication + (DD+) [M. F. Boufarès Octobre 2019] ******
REM ******************************************************************************
REM ******************************************************************************
REM ******************************************************************************


-- ======================================================
-- ======================================================
REM -- Elimination des doubles et des similaires
REM -- Matching, Merging, and Deduplication
-- ======================================================

/*
-- Algo Data Deduplication + (DD+) [M. F. Boufarès Octobre 2019]


The DD + agorithm consists in splitting the data source into several blocks.
Then sort and clean each block independently of the others.
Finally, merge the blocks to perform deduplication.
This logic corresponds perfectly to the BigData MapReduce paradigm.
In addition, two functions should be developed which are the basis of all comparisons of similar VALUES:
- Match to compare the rows between them on the designated columns (double exact or similar),
- Merge to eliminate exact doubles or merge similar.
Intelligent processing should be done to designate the columns that are used for deduplication.



Algorithm DD+
Input : 
F : a set of rows/lines, the data source with anomalies
K : a set of columns that serve for deduplication (Key attributes)
Output :
FPrim : a final set of rows, the result of data deduplication process
FInter : a set of rows for intermediate results

Begin
N = Number of initial tuples in F
M = Memory size (M is much smaller than N)
B = Number of blocks B=[N/M] ent-sup

Example : 
The file F contains 14 VALUES ; N=14
F = 
Barcelone Bruxelles Paris Rome Paris 
Madrid Barcelone Bruxelles Paris Paris
Barcelone Madrid Londres Paris

The memory size is M=5 ; The the number of Blocks is B=3

-- Cutting FROM F to B blocks
CreateSortedBlocks(F,N,M,B,K);

3 Files/Blocks are created (F1, F2 and F3)
F1 = Barcelone Bruxelles Paris Rome Paris (Non trié)
F1 = Barcelone Bruxelles Paris Paris Rome (Trié)

F2 = Madrid Barcelone Bruxelles Paris Paris
F2 = Barcelone Bruxelles Madrid Paris Paris

F3 = Barcelone Madrid Londres Paris
F3 = Barcelone Londres Madrid Paris

-- Merge sorted blocks to build the final result
MergeSortedBlocks(B,FInter,FPrim);
END Algorithm DD+

----------------
Procedure CreateSortedBlocks
BEGIN

END;

----------------
Procedure MinimumValue
BEGIN

END;

----------------
Procedure MergeSortedBlocks
BEGIN
 
END;

Etc...

*/

-- === MFB0 =======================================

-- Données SANS anomalie syntaxique

DROP TABLE FILE_DEP;
DROP TABLE FILE_INTERM;
DROP TABLE FILE_ARR;

CREATE TABLE FILE_DEP (COLONNE VARCHAR(5));

INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Bruxelles');
INSERT INTO FILE_DEP VALUES ('Paris');
INSERT INTO FILE_DEP VALUES ('Rome');
INSERT INTO FILE_DEP VALUES ('Paris');

INSERT INTO FILE_DEP VALUES ('Madrid');
INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Bruxelles');
INSERT INTO FILE_DEP VALUES ('Paris');
INSERT INTO FILE_DEP VALUES ('Paris');

INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Madrid');
INSERT INTO FILE_DEP VALUES ('Londres');
INSERT INTO FILE_DEP VALUES ('Paris');
COMMIT;

SELECT * FROM FILE_DEP ;
SELECT COUNT(*) NBROCCUR FROM FILE_DEP ;
SELECT COLONNE, COUNT(*) NBROCCUR FROM FILE_DEP GROUP BY COLONNE;


CREATE TABLE FILE_INTERM AS SELECT * FROM FILE_DEP ;
CREATE TABLE FILE_ARR AS SELECT * FROM FILE_DEP WHERE 1=2;

/*
N=14
M=5
B=3
*/

CREATE TABLE FILE_INTERM1 AS SELECT * FROM FILE_INTERM WHERE ROWNUM <= 5 ;
-- CREATE TABLE FILE_INTERM1 AS SELECT * FROM FILE_INTERM WHERE ROWNUM <= 5 ORDER BY COLONNE;
DELETE FROM FILE_INTERM WHERE ROWNUM <= 5 ;
CREATE TABLE FILE_INTERM2 AS SELECT * FROM FILE_INTERM WHERE ROWNUM <= 5 ;
DELETE FROM FILE_INTERM WHERE ROWNUM <= 5 ;
CREATE TABLE FILE_INTERM3 AS SELECT * FROM FILE_INTERM WHERE ROWNUM <= 5 ;
DELETE FROM FILE_INTERM WHERE ROWNUM <= 5 ;

SELECT * FROM FILE_INTERM1;
SELECT * FROM FILE_INTERM2;
SELECT * FROM FILE_INTERM3;

CREATE TABLE FILE_MINMIN (COLONNE VARCHAR(5));

-- A répéter un certain nombre de fois (nombre de valeurs distinctes)
DELETE FROM FILE_MINMIN ;
INSERT INTO FILE_MINMIN AS SELECT * FROM FILE_INTERM1 WHERE ROWNUM = 1;
INSERT INTO FILE_MINMIN AS SELECT * FROM FILE_INTERM2 WHERE ROWNUM = 1;
INSERT INTO FILE_MINMIN AS SELECT * FROM FILE_INTERM3 WHERE ROWNUM = 1;

SELECT * FROM FILE_MINMIN;

SELECT MIN(COLONNE) MINMIN FROM FILE_MINMIN ;

DROP TABLE FILE_X1;
CREATE TABLE FILE_X1 AS SELECT * FROM FILE_INTERM1 WHERE COLONNE = 'MINMIN';
DELETE FROM FILE_INTERM1 WHERE COLONNE = 'MINMIN'; -- La valeur récupérée

DROP TABLE FILE_X2;
CREATE TABLE FILE_X2 AS SELECT * FROM FILE_INTERM1 WHERE COLONNE = 'MINMIN';
DELETE FROM FILE_INTERM2 WHERE COLONNE = 'MINMIN'; -- La valeur récupérée

DROP TABLE FILE_X3;
CREATE TABLE FILE_X3 AS SELECT * FROM FILE_INTERM1 WHERE COLONNE = 'MINMIN';
DELETE FROM FILE_INTERM3 WHERE COLONNE = 'MINMIN'; -- La valeur récupérée

DROP TABLE FILE_Y;
CREATE TABLE FILE_Y AS 
(
SELECT * FROM FILE_X1
UNION ALL
SELECT * FROM FILE_X2
UNION ALL
SELECT * FROM FILE_X3
);

-- Toutes les valeurs "proches" égales ou similaires sont récupérées
-- Marquer toutes ces lignes !
-- Ceci peut permettre d'expliquer ultérieurement le résultat de la fusion

INSERT INTO FILE_ARR AS
SELECT * FROM FILE_Y ; 

SELECT * FROM FILE_ARR ;

-- Construire une résultante (une fusion) des lignes qui sont dans FILE_Y
-- Il s'agit de la fonction MERGE qui doit fusionner les lignes considérées proches/similaires
-- Ne garder qu'un seul exemplaire si c'est un double exact
-- Fusionner plusieurs lignes dans la mesure où elles se ressemblent
-- QUESTION : Que Faut-il garder ?
-- Ajouter la ligne résultat de la fusion dans FILE_ARR (En principe c'est la seule qui doit être gardée)

-- ??? et la suite ...



-- =============================================================================== 
-- Données AVEC anomalies syntaxiques

-- === MFB1 ============= VILLE ===================

DROP TABLE FILE_DEP;
DROP TABLE FILE_INTERM;
DROP TABLE FILE_ARR;

CREATE TABLE FILE_DEP (COLONNE VARCHAR(5));

INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Bruxelles');
INSERT INTO FILE_DEP VALUES ('Paris');
INSERT INTO FILE_DEP VALUES ('Rome');
INSERT INTO FILE_DEP VALUES ('Paris');

INSERT INTO FILE_DEP VALUES ('Madrid');
INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Bruxelles');
INSERT INTO FILE_DEP VALUES ('Paris');
INSERT INTO FILE_DEP VALUES ('Paris');

INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Madrid');
INSERT INTO FILE_DEP VALUES ('Londres');
INSERT INTO FILE_DEP VALUES ('Paris');
INSERT INTO FILE_DEP VALUES ('PARIS');
INSERT INTO FILE_DEP VALUES ('Pari');
INSERT INTO FILE_DEP VALUES ('Parisss');
INSERT INTO FILE_DEP VALUES ('Bruxelle');
COMMIT;

SELECT * FROM FILE_DEP ;
SELECT COUNT(*) NBROCCUR FROM FILE_DEP ;
SELECT COLONNE, COUNT(*) NBROCCUR FROM FILE_DEP GROUP BY COLONNE;



-- =============================================================================== 
-- =============================================================================== 

-- === MFB2 ============= UNIV PARIS 13 ===================

CREATE TABLE ETUDIUTV (NUMETUD VARCHAR2(10), NOMETUD VARCHAR2(20), PRENOMETUD VARCHAR2(20), 
DATENAISETUD DATE, VILLEETUD VARCHAR2(20), PAYSETUD VARCHAR2(20));

INSERT INTO ETUDIUTV VALUES ('iutv1', 'LE BON', 'Adam', '19-06-2001', 'EPINAY SUR SEINE', 'FRANCE');
INSERT INTO ETUDIUTV VALUES ('iutv2', 'LE BON', 'Adam', '19-06-2001', 'EPINAY SUR SEINE', 'FRANCE');
INSERT INTO ETUDIUTV VALUES ('iutv3', 'BELLE', 'Clemene', '16-10-1996', 'NICE', 'FRANCE');
INSERT INTO ETUDIUTV VALUES ('iutv4', 'UNIQUE', 'Alexandre', '19-06-2001', 'PARIS', 'FRANCE');
INSERT INTO ETUDIUTV VALUES ('iutv5', 'TRAIFORT', 'Eve', '19-06-2001', 'EPINAY-SUR-SEINE', 'FRANCE');
INSERT INTO ETUDIUTV VALUES ('iutv6', 'TRAIFORT', 'Nadia', '17-09-2000', 'EPINAY-SUR-SEINE', 'FRANCE');
INSERT INTO ETUDIUTV VALUES ('iutv7', 'CHEVALIER', 'Ines', '17-09-2000', 'EPINAY-SUR-SEINE', NULL);


CREATE TABLE ETUDIG (NUME VARCHAR2(10), NOME VARCHAR2(20), PRENE VARCHAR2(20),
DNE DATE, VILLEE VARCHAR2(20), PAYSE VARCHAR2(20));

INSERT INTO ETUDIG VALUES ('ig1', 'LE BON', 'Adem', '19-06-2001', 'EPINAY-SUR-SEINE', 'FRANCE');
INSERT INTO ETUDIG VALUES ('ig2', 'BELLE', 'C.', '16-10-1996', 'NICE', 'FRANCE');
INSERT INTO ETUDIG VALUES ('ig3', 'LEBON', 'Adams', NULL, 'PARIS', 'FRANCE');
INSERT INTO ETUDIG VALUES ('ig4', 'CHEVALIER', 'Ines', '17-09-2000', 'EPINAY-SUR-SEINE', 'FRANCE');

COMMIT;

CREATE TABLE TOUSLESETUD AS (SELECT * FROM ETUDIUTV UNION SELECT * FROM ETUDIG);

SELECT * FROM TOUSLESETUD ;

SELECT DISTINCT * FROM TOUSLESETUD ;

-- =============================================================================== 
-- =============================================================================== 

-- === MFB3 ============= BIBLIOGRAPHIE BD-ACM BD-DBLP ===================

CREATE TABLE BDACM (
ID VARCHAR2(50) PRIMARY KEY,
Title VARCHAR2(500), 
Authors VARCHAR2(500), 
Venue VARCHAR2(500), 
Year NUMBER
);

INSERT INTO BDACM VALUES
('564753', 'A compact B-tree', 'Peter Bumbulis, Ivan T. Bowman', 'International Conference on Management of Data', 2002);
INSERT INTO BDACM VALUES
('872806', 'A theory of redo recovery', 'David Lomet, Mark Tuttle', 'International Conference on Management of Data',2003);

COMMIT;


CREATE TABLE BDDBLP (
ID VARCHAR2(50) PRIMARY KEY,
Title VARCHAR2(500), 
Authors VARCHAR2(500), 
Venue VARCHAR2(500), 
Year NUMBER
);

INSERT INTO BDDBLP VALUES
('conf/sigmod/BumbulisB02', 'A compact B-tree', 'Ivan T. Bowman, Peter Bumbulis', 'SIGMOD Conference', 2002);
INSERT INTO BDDBLP VALUES
('conf/sigmod/LometT03', 'A Theory of Redo Recovery', 'Mark R. Tuttle, David B. Lomet', 'SIGMOD Conference', 2003);
INSERT INTO BDDBLP VALUES
('conf/sigmod/DraperHW01', 'The Nimble Integration Engine', 'Daniel S. Weld, Alon Y. Halevy, Denise Draper', 'SIGMOD Conference', 2001);
COMMIT;

CREATE TABLE BIBLIOGRAPHIE AS (SELECT * FROM BDACM UNION SELECT * FROM BDDBLP);

SELECT * FROM BIBLIOGRAPHIE ;

SELECT DISTINCT * FROM BIBLIOGRAPHIE ;

-- =============================================================================== 
-- =============================================================================== 

