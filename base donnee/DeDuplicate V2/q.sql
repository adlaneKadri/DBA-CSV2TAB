
COLUMN COLONNE FORMAT A20;
set line 1000;
set pages 200;

DROP TABLE FILE_DEP;
DROP TABLE FILE_INTERM;
DROP TABLE FILE_ARR;
--================================================================
-- 		CREATE TABLE WE GONNA TREAT 			--
--================================================================
CREATE TABLE FILE_DEP (COLONNE VARCHAR(15));

--BLOC 1
INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Bruxelles');
INSERT INTO FILE_DEP VALUES ('Paris');
INSERT INTO FILE_DEP VALUES ('Rome');
INSERT INTO FILE_DEP VALUES ('Paris');
--BLOC 2
INSERT INTO FILE_DEP VALUES ('Madrid');
INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Bruxelles');
INSERT INTO FILE_DEP VALUES ('Paris');
INSERT INTO FILE_DEP VALUES ('Paris');
--BLOC 3
INSERT INTO FILE_DEP VALUES ('Barcelone');
INSERT INTO FILE_DEP VALUES ('Madrid');
INSERT INTO FILE_DEP VALUES ('Londres');
INSERT INTO FILE_DEP VALUES ('Paris');
COMMIT;


--================================================================
-- 		CREATE INTERMEDIATE TABLES			--
--================================================================
CREATE TABLE FILE_INTERM AS SELECT * FROM FILE_DEP ;
CREATE TABLE FILE_ARR AS SELECT * FROM FILE_DEP WHERE 1=2;

SELECT * FROM FILE_DEP ;
SELECT * FROM FILE_INTERM ;
SELECT * FROM FILE_ARR ;

SELECT COUNT(*) NBROCCUR FROM FILE_DEP ;
SELECT COLONNE, COUNT(*) NBROCCUR FROM FILE_DEP GROUP BY COLONNE;
--================================================================
-- 			CREATE SET OF DB 			--
--================================================================
CREATE TABLE FILE_INTERM1 AS SELECT * FROM FILE_INTERM WHERE ROWNUM <= 5 ;
DELETE FROM FILE_INTERM WHERE ROWNUM <= 5 ;
CREATE TABLE FILE_INTERM2 AS SELECT * FROM FILE_INTERM WHERE ROWNUM <= 5 ;
DELETE FROM FILE_INTERM WHERE ROWNUM <= 5 ;
CREATE TABLE FILE_INTERM3 AS SELECT * FROM FILE_INTERM WHERE ROWNUM <= 5 ;
DELETE FROM FILE_INTERM WHERE ROWNUM <= 5 ;

SELECT * FROM FILE_INTERM1;
SELECT * FROM FILE_INTERM2;
SELECT * FROM FILE_INTERM3;
--================================================================
-- 			CREATE SET OF DB 			--
--================================================================

