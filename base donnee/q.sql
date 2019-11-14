
set line 10000;
set pages 200;
SET SERVEROUTPUT ON
COLUMN REFERENCES  FORMAT A25
COLUMN OLDVALUES  FORMAT A10
COLUMN SYNTACTICTYPE  FORMAT A20
COLUMN COLUMNWIDHT  FORMAT 99
COLUMN NUMBEROFWORDS  FORMAT 99
COLUMN OBSERVATION FORMAT A20
COLUMN REGULAREXPR FORMAT A60
COLUMN SEMANTICCATEGORY FORMAT A20
COLUMN NEWVALUES FORMAT A30
COLUMN SEMANTICSUBCATEGORY FORMAT A20
COLUMN SUBCATEGORY FORMAT A30
COLUMN REGULAREXPRESSION FORMAT A80
COLUMN CATEGORY FORMAT A30


COLUMN CSVFILE FORMAT A30
COLUMN DR_CSVFile_Col1  FORMAT A10
COLUMN DR_CSVFile_Col2 FORMAT A10
COLUMN DR_CSVFile_Col3 FORMAT A10
COLUMN DR_CSVFile_Col4 FORMAT A10
COLUMN DR_CSVFile_Col5 FORMAT A10
COLUMN DR_CSVFile_Col6 FORMAT A10

drop table CSV2TABCOLUMNS;
drop table DR_CSVFile_Col1;
drop table DR_CSVFile_Col2;
drop table DR_CSVFile_Col3;
drop table DR_CSVFile_Col4;
drop table DR_CSVFile_Col5;
drop table DR_CSVFile_Col6;

-------------------=====================================================================================
CREATE OR REPLACE FUNCTION GET_BY_INDEX_SPLI(SENTECE VARCHAR ,DELIMEER VARCHAR2, INDEX_ NUMBER)
RETURN VARCHAR2
iS 
BEGIN 	
	return regexp_substr(SENTECE,'[^'||DELIMEER||']+',1,INDEX_);
END;
/
--======================================================================================================
CREATE or replace PROCEDURE CSV2TAB 
as
    CURSOR cr is select * from CSVfile1; 
    columns_n  number:=1;
    columns_size  number:=1;
    COLUMN_width  number(5);
    COLUMN_type VARCHAR2(20);
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
    observation varchar2(60):= ' ';
BEGIN
	--get the number max of columns
	columns_n:=nbr_columns;
	DBMS_OUTPUT.PUT_LINE('- number max of columns is => '||columns_n);

	-- CREATE TABLE CSV2TABCOLUMNS AND FOR EACH COLUMN WE CREATE A TABLE AS META-TABLE
		if columns_n  !=1 then 
			query_ := 'create table CSV2TABCOLUMNS (';
			FOR i in 1..columns_n loop
				
				query_ :=query_||'Col'||i||' VARCHAR2(30),';
				query_TABLE:='create table DR_CSVFile_Col'||i||' (REFERENCES VARCHAR2(100),OLDVALUES VARCHAR2(1000), SYNTACTICTYPE VARCHAR2(20), COLUMNWIDHT number(5),NUMBEROFWORDS number(2), OBSERVATION VARCHAR2(1000), NEWVALUES VARCHAR2(1000),SEMANTICCATEGORY VARCHAR2(1000) ,SEMANTICSUBCATEGORY VARCHAR2(1000))';
				Execute immediate query_TABLE;
			end loop;
			n:= columns_n+1;
			query_ :=query_||'Col'||n||' VARCHAR2(30))';
			
			--QUERY TO CREATE A TABLE AS META-base of this column		
			query_TABLE:='create table DR_CSVFile_Col'||n||' (REFERENCES VARCHAR2(100),OLDVALUES VARCHAR2(1000), SYNTACTICTYPE VARCHAR2(20), COLUMNWIDHT number(5),NUMBEROFWORDS number(2), OBSERVATION VARCHAR2(1000), NEWVALUES VARCHAR2(1000),SEMANTICCATEGORY VARCHAR2(1000) ,SEMANTICSUBCATEGORY VARCHAR2(1000))';
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
			preference := 'CSVfile1_'||replace(sysdate,'/','-')||'_Col'||i;
			--DBMS_OUTPUT.PUT_LINE('prference: '||preference);
			--get the element with index = i , after spliting on ';'
			a:=GET_BY_INDEX_SPLI(c_rec.Col,';',i);	
			COLUMN_width:=LENGTH(a);
			COLUMN_type:=VerifRegExpr(a);
			nbr_words:=regexp_count(a,'[ ^]')+1;
			IF a is NULL then 
				a:='NULL';
				observation:='NULL<?>NULE_VALUES';
				COLUMN_width:=0;
				COLUMN_type:='NULL';
				nbr_words:=0;
			END IF;
			
	
			if i = (columns_size+1) then
				columns_var:=columns_var||'col'||i||') VALUES(';
				columns_val:=columns_val||''''||a||''''||')';
				query_TABLE:='insert into DR_CSVFile_Col'||i||'(REFERENCES, OLDVALUES,SYNTACTICTYPE , COLUMNWIDHT,NUMBEROFWORDS,OBSERVATION)VALUES('''||preference||''','''||a||''','''||COLUMN_type||''','''||COLUMN_width||''','''||nbr_words||''','''||observation||''')';
				observation:=' ';
				--DBMS_OUTPUT.PUT_LINE(query_TABLE);
				Execute immediate query_TABLE;
				commit;
			else 
				columns_var:=columns_var||'col'||i||',';
				columns_val:=columns_val||''''||a||''''||',';
				
				--DBMS_OUTPUT.PUT_LINE(a||' =>: '||type_var);
				query_TABLE:='insert into DR_CSVFile_Col'||i||'(REFERENCES, OLDVALUES,SYNTACTICTYPE, COLUMNWIDHT,NUMBEROFWORDS,OBSERVATION)VALUES('''||preference||''','''||a||''','''||COLUMN_type||''','''||COLUMN_width||''','''||nbr_words||''','''||observation||''')';
				--DBMS_OUTPUT.PUT_LINE(query_TABLE);
				observation:=' ';
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

execute CSV2TAB;
select * from DR_CSVFile_Col4;

--============================================================================================
-- this function give for a column name, the most type 
CREATE OR REPLACE FUNCTION TYPE_OF(COLUMN_NAME VARCHAR2)
RETURN VARCHAR2
iS 
	best_type VARCHAR2(30);
	query VARCHAR2(1000);
BEGIN 
	query := 'SELECT SYNTACTICTYPE FROM (SELECT SYNTACTICTYPE,COUNT(*) as b FROM '||COLUMN_NAME||' GROUP BY SYNTACTICTYPE) where b = (SELECT MAX(a) FROM (SELECT SYNTACTICTYPE,COUNT(*) as a FROM '||COLUMN_NAME||' GROUP BY SYNTACTICTYPE))';

		EXECUTE IMMEDIATE query INTO best_type ;
return best_type;
END;
/
--============================================================================================
-- a procedure just to display for each column , the real type... we're not gonna use it 
CREATE OR REPLACE PROCEDURE validate_type
IS
	best_type VARCHAR2(30);
	cpt_best_type number;
	query VARCHAR2(1000);
	n_columns number;
BEGIN
	n_columns := nbr_columns+1;
	for i in 1..n_columns loop

	--query := 'SELECT TYPE FROM (SELECT TYPE,COUNT(*) as b FROM syntaxCol'||i||' GROUP BY TYPE) where b = (SELECT MAX(a) FROM (SELECT TYPE,COUNT(*) as a FROM syntaxCol'||i||' GROUP BY TYPE))';
		--EXECUTE IMMEDIATE query INTO best_type ;
		best_type:=TYPE_OF('DR_CSVFile_Col'||i);
		DBMS_OUTPUT.PUT_LINE('dominant dans la columns '||i||':'||best_type);


	END LOOP;
END;
/
execute validate_type; 

-- ================================================================================================
-- we create this view just because of some technical problems, because before creating this view, we'd problems when we create i
create or replace view temp as select * from DR_CSVFile_Col5; 
select * from dual;
-- ================================================================================================

/*
--drop table SEMENTICREGULAREXP CASCADE constraints;
drop table DDRE;
CREATE TABLE DDRE (
	CATEGORY VARCHAR2(100), 
	SUBCATEGORY VARCHAR2(100), 
	REGULAREXPRESSION VARCHAR2(1000)
);

-- INSERTION
INSERT INTO DDRE VALUES ('STRING','VARCHAR2', '^[[:alpha:][:digit:][°,-_]+$');
INSERT INTO DDRE VALUES ('DATE','DATA_FR','([0-2][0-9]|3[0-1])-(0[0-9]|1[0-2])-[0-9]{4}');
INSERT INTO DDRE VALUES ('NUMBER','INTEGER' , '^[[:digit:]]+$');
INSERT INTO DDRE VALUES ('MAIL','MAIL','^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
INSERT INTO DDRE VALUES ('TEL','TELFR-I','^(([\+]|[0]{2})([3]{2}))[1-9]([0-9]{8})$');
INSERT INTO DDRE VALUES ('TEL','TELFR','^[0][1-9][0-9]{8}$');
INSERT INTO DDRE VALUES ('TEL','TELBE-I', '^(([\+]|[0]{2})[3][2])[4]([5-9]{1})([0-9]{7})$');
INSERT INTO DDRE VALUES ('TEL','TELBE', '^[0][4]([5-9]{1})([0-9]{7})$');
INSERT INTO DDRE VALUES ('TEL','TELTN-I', '^(([\+]|[0]{2})[2][1][6])[1-9]([0-9]{7})$');
INSERT INTO DDRE VALUES ('TEL', 'TELTN', '^[0][1-9]([0-9]{7})$');
INSERT INTO DDRE VALUES ('CIVILITY', 'CIVILITY_FR', '^(M\.|MME|MLLE|MONSIEUR|MADAME|MADEMOISELLE)$');
INSERT INTO DDRE VALUES ('CIVILITY', 'CIVILITY_EN', '^(M \.|MRS|MS|MISTER|MISS)$');
INSERT INTO DDRE VALUES ('GENDER', 'GENDER_FR', '^(f|m|F|M|MASCULIN|FEMININ|FEMELLE|MALE)$');
INSERT INTO DDRE VALUES ('BLOODGROUP', 'BLOODGROUP', '^(A\+|A-|B\+|B-|AB\+|AB-|O\+|O-)$');
INSERT INTO DDRE VALUES ('TEMPERATURE', 'TEMPERATURE_CELSIUS', '^([\+-]?[0-9]+((\.|,)\d+)?\s?(°C|°CELSIUS|CELSIUS))$');
INSERT INTO DDRE VALUES ('TEMPERATURE', 'TEMPERATURE_FAHRENHEIT', '^([\+-]?[0-9]+((\.|,)\d+)?\s?(°F|°FAHRENHEIT|FAHRENHEIT°))$');
INSERT INTO DDRE VALUES ('TEMPERATURE', 'TEMPERATURE_KELVIN', '^[\+-]?[0-9]+((\.|,)\d+)?\s?((K|KELVIN))$');

-- ================================================================================================

-- SEMENTIC VERIFICATION  --> return category 
CREATE OR REPLACE FUNCTION getSemanticCategory(p_variable IN varchar2)
RETURN VARCHAR2
IS
	CURSOR test is select * from DDRE;
	RESULT varchar2(50);
	REGULAR VARCHAR2(1000);
	cat varchar(100);
BEGIN
		FOR Rec IN test 
		LOOP
			if REGEXP_LIKE (p_variable,Rec.REGULAREXPRESSION) then 
				Result := Rec.CATEGORY;
			end if;

		END LOOP;
	RETURN(RESULT);
	END;
/

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
-- SEMENTIC VERIFICATION  --> return sub category 
CREATE OR REPLACE FUNCTION getSemanticSubCategory(p_variable IN varchar2)
RETURN VARCHAR2
IS
	CURSOR test is select * from DDRE;
	RESULT varchar2(50);
	REGULAR VARCHAR2(1000);
	cat varchar(100);
BEGIN
		FOR Rec IN test 
		LOOP
			if REGEXP_LIKE (p_variable,Rec.REGULAREXPRESSION) then 
				Result := Rec.SUBCATEGORY;
			end if;

		END LOOP;
	RETURN(RESULT);
END;
/
*/
-- =================================================================================================
--drop PROCEDURE UPDATE_BSERVATIONS;
--drop PROCEDURE OBSERVATIONS;

CREATE OR REPLACE PROCEDURE update_observation(COLMUN_NAME VARCHAR)
IS
	CURSOR cr is select * from temp;
	c_rec cr%rowtype;
	OLDVALUES_ VARCHAR2(600);
	type_ VARCHAR2(600);
	query VARCHAR2(1000);
	best_type varchar2(30);
BEGIN	
	best_type:=TYPE_OF(COLMUN_NAME);
	for c_rec in cr loop
		OLDVALUES_:= c_rec.OLDVALUES;
		type_:=c_rec.SYNTACTICTYPE;
		--DBMS_OUTPUT.PUT_LINE(best_type ||' '||type_);
		IF type_ != best_type THEN 
			query:='update '||COLMUN_NAME||' set SEMANTICCATEGORY='NULL',  OBSERVATION='''||OLDVALUES_||'<?>ANOMALY'||''', NEWVALUES='''||OLDVALUES_||'<?>ANOMALY'||''' where SYNTACTICTYPE!='''||best_type||''' AND OLDVALUES='''||OLDVALUES_||'''';
			DBMS_OUTPUT.PUT_LINE(query);

		ELSE	
			query:='update '||COLMUN_NAME||' set  NEWVALUES='''||OLDVALUES_||''' where SYNTACTICTYPE='''||best_type||''' AND OLDVALUES='''||OLDVALUES_||'''';
			--DBMS_OUTPUT.PUT_LINE(query);

		END IF;
		EXECUTE IMMEDIATE query ;
	exit when cr%notfound;
	end loop;

	
END;
/
--execute update_observation('DR_CSVFile_Col5');
--select * from DR_CSVFile_Col5;

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
CREATE OR REPLACE PROCEDURE observation(COLMUN_NAME VARCHAR)
IS
query VARCHAR2(1000);
BEGIN
	query := 'create or replace view temp as SELECT * FROM '||COLMUN_NAME;
	EXECUTE IMMEDIATE query ;
	--DBMS_OUTPUT.PUT_LINE(query);
	commit;
	update_observation(COLMUN_NAME);
END;
/

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
CREATE OR REPLACE PROCEDURE ANNOMALIES
IS
columns_size number;
BEGIN
	columns_size:=nbr_columns;
	for i in 1 .. columns_size + 1 loop
		observation('DR_CSVFile_Col'||i);
	end loop;
	
END;
/

execute ANNOMALIES;

-- ================================================================================================
--execute observation('DR_CSVFile_Col1');
--execute observation('DR_CSVFile_Col2');
--execute observation('DR_CSVFile_Col3');
--execute observation('DR_CSVFile_Col4');
--execute observation('DR_CSVFile_Col5');
--execute observation('DR_CSVFile_Col6');


-- ================================================================================================
--update semantic column SEMANTICCATEGORY

-- ================================================================================================
/*
select * from DR_CSVFile_Col1;
select * from DR_CSVFile_Col2;
select * from DR_CSVFile_Col3;
select * from DR_CSVFile_Col4;
select * from DR_CSVFile_Col5;
select * from DR_CSVFile_Col6;
select * from DDRE;
*/
-- ================================================================================================
