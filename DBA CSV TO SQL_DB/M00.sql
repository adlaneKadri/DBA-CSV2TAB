set SERVEROUTPUT on;

COLUMN REFERENCES FORMAT A20
COLUMN OLDNAME FORMAT A10
--COLUMN NEWNAME FORMAT A50
COLUMN NEWNAME FORMAT A10
COLUMN M000 FORMAT 99
COLUMN M100 FORMAT 99
COLUMN M101 FORMAT 99
COLUMN M102 FORMAT 99
COLUMN M103 FORMAT 99
COLUMN M104 FORMAT 99
COLUMN M105 FORMAT 99 
COLUMN M106 FORMAT 99
COLUMN M107 FORMAT 99
COLUMN M108 FORMAT 99
COLUMN M109 FORMAT 99
COLUMN M110 FORMAT 99
--COLUMN M111 FORMAT A20
COLUMN M111 FORMAT A8
COLUMN M112 FORMAT 99
COLUMN M113 FORMAT 99
--COLUMN M114 FORMAT A20
COLUMN M114 FORMAT A11
COLUMN M115 FORMAT 99 
COLUMN M116 FORMAT 99

DROP TABLE DR_CSVFile_TabCol ;
CREATE TABLE DR_CSVFile_TabCol
(
    REFERENCES VARCHAR2(100), -- NomDuFichier CSV_ DateSystème
    OLDNAME VARCHAR2(100),-- Col_i
    NEWNAME VARCHAR2(100),-- Col_i_syntax_sementique
    M000 NUMBER(5),--Number of rows
    M100 NUMBER(5),--Number of NULL values
    M101 NUMBER(5),--Number of NOT NULL values
    M102 NUMBER(5),--min length (characters)
    M103 NUMBER(5),--MAX LENGTH (characters)
    M104 NUMBER(5),--Number of Words
    M105 NUMBER(5),--Number of values of the STRING TYPE 
    M106 NUMBER(5),--Number of values of the NUMBER TYPE
    M107 NUMBER(5),--Number of values of the DATE TYPE
    M108 NUMBER(5),--Number of values of the BOOLEAN TYPE
    M109 NUMBER(5),--Number of values of the NULL TYPE
    M110 NUMBER(5),--Number of DIFFERENT values
    M111 Varchar2(10),--The DOMINANT syntactic TYPE
    M112 NUMBER(5),--Number of syntactic ANOMALIES
    M113 NUMBER(5),--Number of syntactic NORMAL values M113
    M114 Varchar2(50),--The DOMINANT semantic CATEGORY M114
    M115 NUMBER(5),--Number of semantic ANOMALIES 
    M116 NUMBER(5)--Number of semantic NORMAL values 
);

CREATE OR REPLACE PROCEDURE RES_PROFILAGE IS 
    query VARCHAR2(2000) :='';
    nbr_col number;
    M000 NUMBER:=0;
    M100 NUMBER:=0;
    M101 NUMBER:=0;
    M102 NUMBER:=0;
    M103 NUMBER:=0;
    M104 NUMBER:=0;
    M105 NUMBER:=0; 
    M106 NUMBER:=0;
    M107 NUMBER:=0;
    M108 NUMBER:=0;
    M109 NUMBER:=0;
    M110 NUMBER:=0;
    M111 Varchar2(10):='';
    M112 NUMBER:=0;
    M113 NUMBER:=0;
    M114 Varchar2(50):='';
    M115 NUMBER:=0; 
    M116 NUMBER:=0;
    sub  Varchar2(50):='';
BEGIN

    nbr_col := nbr_columns;
    FOR i IN 1..nbr_col+1 
    LOOP
        query :='INSERT INTO DR_CSVFile_TabCol VALUES(';
        
        execute immediate 'select count(*) from DR_CSVFILE_COL'||i into M000;
        execute immediate 'select count(*) from DR_CSVFILE_COL'||i||' where OLDVALUES =''NULL''' into M100;
        execute immediate 'select count(*) from DR_CSVFILE_COL'||i||' where OLDVALUES !=''NULL''' into M101;
        execute immediate 'select MIN(COLUMNWIDHT) from DR_CSVFILE_COL'||i into M102;
        execute immediate 'select MAX(COLUMNWIDHT) from DR_CSVFILE_COL'||i into M103;
        execute immediate 'select MAX(NUMBEROFWORDS) from DR_CSVFILE_COL'||i into M104;
        execute immediate 'select COUNT(SYNTACTICTYPE) from DR_CSVFILE_COL'||i||' where UPPER(SYNTACTICTYPE) =''VARCHAR2''' into M105;
        execute immediate 'select COUNT(SYNTACTICTYPE) from DR_CSVFILE_COL'||i||' where UPPER(SYNTACTICTYPE) =''NUMBER''' into M106;
        execute immediate 'select COUNT(SYNTACTICTYPE) from DR_CSVFILE_COL'||i||' where UPPER(SYNTACTICTYPE) =''DATE''' into M107;
        execute immediate 'select COUNT(SYNTACTICTYPE) from DR_CSVFILE_COL'||i||' where UPPER(SYNTACTICTYPE) =''BOOLEAN''' into M108;
        execute immediate 'select COUNT(SYNTACTICTYPE) from DR_CSVFILE_COL'||i||' where UPPER(SYNTACTICTYPE) = ''NULL''' into M109;
        execute immediate 'select COUNT(DISTINCT OLDVALUES) from DR_CSVFILE_COL'||i into M110;
	
    execute immediate 'SELECT SYNTACTICTYPE FROM (SELECT SYNTACTICTYPE,COUNT(*) as b FROM DR_CSVFILE_COL'||i||' WHERE SYNTACTICTYPE IS NOT NULL GROUP BY SYNTACTICTYPE) 
        where b = (SELECT MAX(a) FROM (SELECT SYNTACTICTYPE,COUNT(*) as a FROM DR_CSVFILE_COL'||i||' WHERE SYNTACTICTYPE IS NOT NULL GROUP BY SYNTACTICTYPE))' into M111;
        execute immediate 'select COUNT(OBSERVATION) from DR_CSVFILE_COL'||i||' where OBSERVATION IS NOT NULL' into M112;
        execute immediate 'select COUNT(OBSERVATION) from DR_CSVFILE_COL'||i||' where OBSERVATION IS NULL' into M113;
        
	execute immediate 'SELECT SEMANTICCATEGORY FROM (SELECT SEMANTICCATEGORY,COUNT(*) as b FROM DR_CSVFILE_COL'||i||' WHERE SEMANTICCATEGORY IS NOT NULL GROUP BY 		SEMANTICCATEGORY) 
        where b = (SELECT MAX(a) FROM (SELECT SEMANTICCATEGORY,COUNT(*) as a FROM DR_CSVFILE_COL'||i||' WHERE SEMANTICCATEGORY IS NOT NULL GROUP BY SEMANTICCATEGORY))' into 		M114;

	execute immediate 'SELECT SEMANTICSUBCATEGORY FROM (SELECT SEMANTICSUBCATEGORY,COUNT(*) as b FROM DR_CSVFILE_COL'||i||' WHERE SEMANTICSUBCATEGORY IS NOT NULL GROUP 		BY SEMANTICSUBCATEGORY) 
        where b = (SELECT MAX(a) FROM (SELECT SEMANTICSUBCATEGORY,COUNT(*) as a FROM DR_CSVFILE_COL'||i||' WHERE SEMANTICSUBCATEGORY IS NOT NULL GROUP BY 		    
	SEMANTICSUBCATEGORY))' into sub;

        execute immediate 'select COUNT(SEMANTICCATEGORY) from DR_CSVFILE_COL'||i||' where SEMANTICCATEGORY != ''' ||M114||'''' into M115;
        execute immediate 'select COUNT(SEMANTICCATEGORY) from DR_CSVFILE_COL'||i||' where SEMANTICCATEGORY = ''' ||M114||'''' into M116;

        --query := query ||'''CSVFILE_'||SYSDATE||''',''Col'||i||''',''Col'||i||'_'||M111||'_'||M114||'_'||sub||''','||M000||','||M100||','||M101||','||M102||','||M103||','||M104||','||M105||','||M106||','||M107||','||M108||','||M109||','||M110||','''||M111||''','||M112||','||M113||','''||M114||''','||M115||','||M116||')';
        query := query ||'''CSVFILE_'||SYSDATE||''',''Col_adan_'||i||''',''Col'||i||''','||M000||','||M100||','||M101||','||M102||','||M103||','||M104||','||M105||','||M106||','||M107||','||M108||','||M109||','||M110||','''||M111||''','||M112||','||M113||','''||M114||''','||M115||','||M116||')';

        execute immediate query;
	--query :='INSERT INTO DR_CSVFile_TabCol VALUES(';
    END LOOP;
    
END;
/
exec RES_PROFILAGE;

select * from DR_CSVFile_TabCol;