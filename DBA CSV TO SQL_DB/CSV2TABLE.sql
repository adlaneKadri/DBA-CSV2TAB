-- --============================================================================================
--			 Master 2 EID2 - Promotion 2019-2020 
	
-- 			Groupe de Travail N° B21 : 
-- 				KADRI ADLAN   
-- 				DB user&pwd =   eid2
--				M2EID_21
--============================================================================================


--     			          S  T  A  R  T 


--============================================================================================
-- CREATION OF TABLE CSVfile1 + insertion
--============================================================================================
@create_csv_files


--============================================================================================
--  CREATE A VIEW  csvfile_view containt the csv file to be treated
--============================================================================================

CREATE OR REPLACE PROCEDURE create_csv_table(table_name VARCHAR2)
AS
BEGIN 
	EXECUTE IMMEDIATE 'CREATE VIEW csvfile_view AS (SELECT * FROM '||table_name||' )';
END;
/

-- HERE WE PUT OUR TABLE
DROP VIEW csvfile_view;
execute create_csv_table('CSVfile2'); 


--============================================================================================
-- some configuration of sqlplus -- A SWEET DISPLAY xD
--============================================================================================
@CONFIG



select table_name  from user_tables;
--============================================================================================
-- 			USE ALL FUNCTION ABOUT REG EXPRESSION
--============================================================================================

@REGEXPRES

--============================================================================================
-- GET THE NUMBER OF COLUMNS OF CSVFILE TABLE (here we use the view csvfile_view that contain
-- 												the csv file to be treated)
--	Soit N le nombre de lignes dans la source
--	Soit Pvi = le nombre de « séparateur ; » pour la ligne i
--	Le nombre de colonnes = Max(Pvi) + 1 pour i de 1 à N
--============================================================================================
CREATE OR REPLACE FUNCTION nbr_columns
RETURN NUMBER
as 
	CURSOR cr is select * from csvfile_view; 
	c_rec cr%rowtype;
	n number;
	columns_n  number:=1;
BEGIN 
	for c_rec in cr loop
		n := regexp_count(c_rec.Col,';') ;
		if columns_n < n then 
			columns_n := n;
		end if;
	exit when cr%notfound;
	end loop;

	RETURN(columns_n);
end;
/

--============================================================================================
-- TO GET WORD USING SPLIT
--	GET_BY_INDEX_SPLI("hello-world-am-adlane,kadri",	"-",	1) return hello 
-- 	GET_BY_INDEX_SPLI("hello-world-am-adlane,kadri",	"-",	4) return adlane 
--============================================================================================
CREATE OR REPLACE FUNCTION GET_BY_INDEX_SPLI(SENTECE VARCHAR ,DELIMEER VARCHAR2, INDEX_ NUMBER)
RETURN VARCHAR2
iS 
BEGIN 	
	return regexp_substr(SENTECE,'[^'||DELIMEER||']+',1,INDEX_);
END;
/

--============================================================================================
-- creation of table CSV2TABCOLUMNS using the csvfile data table
-- DESC:
--	- CREATE TABLE WITH CSV2TABCOLUMNS NAME 
--	- FOR EACH COLUMN IN THIS TABLE , WE CREATE A TABLE TO INSERT INFORMATION ABOUT THE CONTENT OF THIS COLUMN - NAMED SYNTAXCOL
--	- FOR EACH DATA WE INSERT IN CSV2TABCOLUMNS, WE NEED TO INSERT ITS INFORMATIONS IN TABLE OF SYANXCOL
--============================================================================================

PROMPT =========================================================================
PROMPT creation de la table CSV2TABCOLUMNS en utilisant les csvfile data table
PROMPT =========================================================================
PROMPT
Pause 		>>>>>>
PROMPT
CREATE or replace PROCEDURE CSV2TAB 
as
    CURSOR cr is select * from csvfile_view; 
    columns_n  number:=1;
    columns_size  number:=1;
    COLUMN_width  number(5);
    COLUMN_type VARCHAR2(100);
    n number;
    q VARCHAR2(200);
    nbr_words number;
    c_rec cr%rowtype;
    query_ VARCHAR2(2000) :='';
    query_TABLE VARCHAR2(2000) :='';
    a VARCHAR2(200);
    columns_var VARCHAR2(2000);
    columns_val VARCHAR2(2000);
    type_var VARCHAR2(2000);
    preference varchar2(60);
    OBSERVATION varchar2(60):= ' ';
BEGIN
	--get the number max of columns
	columns_n:=nbr_columns;
	DBMS_OUTPUT.PUT_LINE('- number max of columns is => '||(1+columns_n));

	-- CREATE TABLE CSV2TABCOLUMNS AND FOR EACH COLUMN WE CREATE A TABLE AS META-TABLE
		if columns_n  !=1 then 
			query_ := 'create table CSV2TABCOLUMNS (';
			FOR i in 1..columns_n loop
				
				query_ :=query_||'Col'||i||' VARCHAR2(100),';
				query_TABLE:='create table DR_CSVFILE_COL'||i||' (REFERENCES VARCHAR2(100),OLDVALUES VARCHAR2(1000), SYNTACTICTYPE VARCHAR2(100), COLUMNWIDHT number(5),NUMBEROFWORDS number(2), OBSERVATION VARCHAR2(1000), NEWVALUES VARCHAR2(1000),SEMANTICCATEGORY VARCHAR2(1000) ,SEMANTICSUBCATEGORY VARCHAR2(1000))';
				Execute immediate query_TABLE;
			end loop;
			n:= columns_n+1;
			query_ :=query_||'Col'||n||' VARCHAR2(30))';
			
			--QUERY TO CREATE A TABLE AS META-base of this column	
			query_TABLE:='create table DR_CSVFILE_COL'||n||' (REFERENCES VARCHAR2(100),OLDVALUES VARCHAR2(1000), SYNTACTICTYPE VARCHAR2(100), COLUMNWIDHT number(5),NUMBEROFWORDS number(2), OBSERVATION VARCHAR2(1000), NEWVALUES VARCHAR2(1000),SEMANTICCATEGORY VARCHAR2(1000) ,SEMANTICSUBCATEGORY VARCHAR2(1000))';
			-- EXECUTE THE QUERY TO CREATE THE TABLE OF COLUMN DESCRIPTION 			
			Execute immediate query_TABLE;
		end if;
		--DBMS_OUTPUT.PUT_LINE('create table with this query : '||query_);
		execute immediate query_;
		commit;

	for c_rec in cr loop 
		--columns_size:= regexp_count(c_rec.Col,';') ;
		columns_size:=nbr_columns;
		query_:= 'insert into CSV2TABCOLUMNS(';
		for i in 1 .. columns_size + 1 loop
			preference := 'CSVfile_'||replace(sysdate,'/','-')||'_Col'||i;
			--DBMS_OUTPUT.PUT_LINE('prference: '||preference);
			--get the element with index = i , after spliting on ';'
			a:=GET_BY_INDEX_SPLI(c_rec.Col,';',i);	
			COLUMN_width:=LENGTH(a);
			COLUMN_type:=VerifRegExpr(a);
			nbr_words:=regexp_count(a,'[ ^]')+1;
			IF a is NULL then 
				a:='NULL';
				OBSERVATION:='NULL<?>NULE_VALUES';
				COLUMN_width:=0;
				COLUMN_type:='NULL';
				nbr_words:=0;
			END IF;
			
	
			if i = (columns_size+1) then
				columns_var:=columns_var||'col'||i||') VALUES(';
				columns_val:=columns_val||''''||a||''''||')';
				query_TABLE:='insert into DR_CSVFILE_COL'||i||'(REFERENCES, OLDVALUES,SYNTACTICTYPE , COLUMNWIDHT,NUMBEROFWORDS,OBSERVATION)VALUES('''||preference||''','''||a||''','''||COLUMN_type||''','''||COLUMN_width||''','''||nbr_words||''','''||OBSERVATION||''')';
				OBSERVATION:=' ';
				--DBMS_OUTPUT.PUT_LINE(query_TABLE);
				Execute immediate query_TABLE;
				commit;
			else 
				columns_var:=columns_var||'col'||i||',';
				columns_val:=columns_val||''''||a||''''||',';
				
				--DBMS_OUTPUT.PUT_LINE(a||' =>: '||type_var);
				query_TABLE:='insert into DR_CSVFILE_COL'||i||'(REFERENCES, OLDVALUES,SYNTACTICTYPE, COLUMNWIDHT,NUMBEROFWORDS,OBSERVATION)VALUES('''||preference||''','''||a||''','''||COLUMN_type||''','''||COLUMN_width||''','''||nbr_words||''','''||OBSERVATION||''')';
				--DBMS_OUTPUT.PUT_LINE(query_TABLE);
				OBSERVATION:=' ';
				Execute immediate query_TABLE;
			end if ; 
		end loop;
		query_:=query_||columns_var||columns_val;
		columns_val:='';
		columns_var:='';
		--DBMS_OUTPUT.PUT_LINE('=>: '||query_);
		execute immediate query_;

	exit when cr%notfound;

	end loop;
END;
/

--============================================================================================
-- EXECUTION AND DISPLAY SOME RESULT - FOR INFORMATIONS
--============================================================================================
execute CSV2TAB;
show errors;
PROMPT ==================================
PROMPT 	Afficher la table CSV2TABCOLUMNS
PROMPT ==================================
PROMPT
Pause 		>>>>>>
PROMPT
select * from CSV2TABCOLUMNS;


PROMPT ========================================
PROMPT	DR_CSVFILE_COL pour toutes les colonnes
PROMPT ========================================
PROMPT
Pause 		>>>>>>
PROMPT

@DISPLAY_TABLES

--============================================================================================
-- this function give for a column name, the most type 
--============================================================================================
CREATE OR REPLACE FUNCTION TYPE_OF(COLUMN_NAME VARCHAR2)
RETURN VARCHAR2
iS 
	best_type VARCHAR2(100);
	query VARCHAR2(1000);
BEGIN 
	query := 'SELECT SYNTACTICTYPE FROM (SELECT SYNTACTICTYPE,COUNT(*) as b FROM '||COLUMN_NAME||' GROUP BY SYNTACTICTYPE) where b = (SELECT MAX(a) FROM (SELECT SYNTACTICTYPE,COUNT(*) as a FROM '||COLUMN_NAME||' GROUP BY SYNTACTICTYPE))';

		EXECUTE IMMEDIATE query INTO best_type ;
return best_type;
END;
/
--============================================================================================
-- a procedure just to display for each column , the real type... we're not gonna use it 
--============================================================================================
CREATE OR REPLACE PROCEDURE validate_type
IS
	best_type VARCHAR2(1000);
	cpt_best_type number;
	query VARCHAR2(2000);
	n_columns number;
BEGIN
	n_columns := nbr_columns+1;
	for i in 1..n_columns loop

	--query := 'SELECT TYPE FROM (SELECT TYPE,COUNT(*) as b FROM syntaxCol'||i||' GROUP BY TYPE) where b = (SELECT MAX(a) FROM (SELECT TYPE,COUNT(*) as a FROM syntaxCol'||i||' GROUP BY TYPE))';
		--EXECUTE IMMEDIATE query INTO best_type ;
		best_type:=TYPE_OF('DR_CSVFILE_COL'||i);
		DBMS_OUTPUT.PUT_LINE('dominant dans la columns '||i||':'||best_type);

	END LOOP;
END;
/
--============================================================================================
-- EXECUTE VALIDATE_TYPE TO SEE THE BEST TIME IN EACH COLUMN
--============================================================================================
execute validate_type; 


--============================================================================================

-- 									LUNDI 23 DECEMBRE 2019									--

--============================================================================================

PROMPT =================================
PROMPT	Mis a jour le reste du colonnes
PROMPT =================================
Pause 		>>>>>>
PROMPT

--============================================================================================
-- UPDATE TABLE   ON COLUMNS 'OBSERVATION' AND 'NEW VALUES' AND SEMANTIC_CATEGORY_AND_SUBCATEGORY
--============================================================================================

@UPDATE_COLUMNS


--TO DISPLAY TABLES
@DISPLAY_TABLES

PROMPT ====================================
PROMPT ... 		M00		 ...
PROMPT ====================================
Pause 		>>>>>> 
PROMPT

--============================================================================================
-- TABLE    M  0  0  
--============================================================================================
@M00




--============================================================================================
-- DROP ALL TABLE
--============================================================================================


@DROP_ALL_TABLES
show error;

