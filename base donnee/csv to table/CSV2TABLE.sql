-- --============================================================================================
--			 Master 2 EID2 - Promotion 2019-2020 
	
-- 			Groupe de Travail N° B21 : 
-- 				KADRI ADLAN   
--				M2EID_21
--============================================================================================


--     			          S  T  A  R  T 


--============================================================================================
-- CREATION OF TABLE CSVfile1 + insertion
--============================================================================================
drop table CSVfile1;
CREATE TABLE CSVfile1(
	Col VARCHAR2(1000)
);

INSERT INTO CSVfile1 VALUES ('Adam;Paris;M;19;19-06-2001;38°C');
INSERT INTO CSVfile1 VALUES ('Eve;Paris;F;23;16-10-1996;37°C');
INSERT INTO CSVfile1 VALUES ('Gabriel;Paris;m;18;17-09-2002;36,5°C');
INSERT INTO CSVfile1 VALUES ('Mariam;Paris;F;41;13-08-1978;38Celcius');
INSERT INTO CSVfile1 VALUES ('Nadia;Londres;f;55;10-10-1965;95°F');
INSERT INTO CSVfile1 VALUES ('Inès;Madrid;F;50;22-11-1969;99,5°F');
INSERT INTO CSVfile1 VALUES ('Inconnu;77;12-12-2012');
INSERT INTO CSVfile1 VALUES ('Abnomly;Rome;1;88;02-10-2019;38°C');
INSERT INTO CSVfile1 VALUES ('Anomalies;Tunis;f;99;25-30-2020;x');
INSERT INTO CSVfile1 VALUES ('Adam;Paris;M;19;19-06-2001;38°C');
INSERT INTO CSVfile1 VALUES ('Eve;Paris;F;23;16-10-1996;37°C');
INSERT INTO CSVfile1 VALUES ('Marie;Pari;F;41;17-09-1979;38Celcius');

COMMIT;
--============================================================================================
-- some configuration of sqlplus -- A SWEET DISPLAY xD
--============================================================================================
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
COLUMN SUBCATEGORY FORMAT A20



COLUMN CSVFILE FORMAT A30
COLUMN DR_CSVFile_Col1  FORMAT A10
COLUMN DR_CSVFile_Col2 FORMAT A10
COLUMN DR_CSVFile_Col3 FORMAT A10
COLUMN DR_CSVFile_Col4 FORMAT A10
COLUMN DR_CSVFile_Col5 FORMAT A10
COLUMN DR_CSVFile_Col6 FORMAT A10
--============================================================================================
-- DROP MENTIONED TABLE
--============================================================================================
drop table CSV2TABCOLUMNS;
drop table DR_CSVFile_Col1;
drop table DR_CSVFile_Col2;
drop table DR_CSVFile_Col3;
drop table DR_CSVFile_Col4;
drop table DR_CSVFile_Col5;
drop table DR_CSVFile_Col6;

select table_name  from user_tables;
--============================================================================================
-- CREATE A TABLE TO SAVE ALL REGEXP :  it contain only  3 type 
--		- DATA
--		- NUMBER
--		- VARCHAR
--============================================================================================

drop table REGULAREXP CASCADE constraints;
CREATE TABLE REGULAREXP(
CATEGORY 			VARCHAR2(20), 
REGULAREXPR 			VARCHAR2(200),
CONSTRAINT PK_REGULAREXP	PRIMARY KEY(CATEGORY),
CONSTRAINT CK_REGULAREXP_CATEGORY	CHECK(CATEGORY = UPPER(CATEGORY))
);

--============================================================================================
-- insert some regexpress 							    <- DDRE ->  
--============================================================================================

INSERT INTO REGULAREXP VALUES
('VARCHAR2', '^[[:alpha:][:digit:][°,-_]+$');
INSERT INTO REGULAREXP VALUES
('DATE', '([0-2][0-9]|3[0-1])-(0[0-9]|1[0-2])-[0-9]{4}');
INSERT INTO REGULAREXP VALUES
('NUMBER', '^[[:digit:]]+$');

--============================================================================================
-- give a variable and we return the type -> here we treat only 3 type (date, number, string)
--============================================================================================
CREATE OR REPLACE FUNCTION VerifRegExpr(p_variable IN varchar2)
RETURN VARCHAR2
IS
	CURSOR test is select * from REGULAREXP;
	RESULT varchar2(50);
	REGULAR VARCHAR2(1000);
	cat varchar(100);
BEGIN
		FOR Rec IN test 
		LOOP

			--DBMS_OUTPUT.PUT_LINE(Rec);
			if REGEXP_LIKE (p_variable,Rec.REGULAREXPR) 
			then 
				Result := Rec.CATEGORY;
			end if;

		END LOOP;
	RETURN(RESULT);
	END;
/
--============================================================================================
-- GET THE NUMBER OF COLUMNS OF CSVFILE TABLE
--============================================================================================
CREATE OR REPLACE FUNCTION nbr_columns
RETURN NUMBER
as 
	CURSOR cr is select * from CSVfile1; 
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

--============================================================================================
-- EXECUTION AND DISPLAY SOME RESULT - FOR INFORMATIONS
--============================================================================================
execute CSV2TAB;
show errors;
select * from CSV2TABCOLUMNS;
select * from DR_CSVFile_Col4;

--============================================================================================
-- this function give for a column name, the most type 
--============================================================================================
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
--============================================================================================
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
--============================================================================================
-- EXECUTE VALIDATE_TYPE TO SEE THE BEST TIME IN EACH COLUMN
--============================================================================================
execute validate_type; 

--============================================================================================
-- 
--============================================================================================


