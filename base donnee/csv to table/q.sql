
--============================================================================================
-- creation of table CSV2TABCOLUMNS using the csvfile data table
-- DESC:
--	- CREATE TABLE WITH CSV2TABCOLUMNS NAME 
--	- FOR EACH COLUMN IN THIS TABLE , WE CREATE A TABLE TO INSERT INFORMATION ABOUT THE CONTENT OF THIS COLUMN - NAMED SYNTAXCOL
--	- FOR EACH DATA WE INSERT IN CSV2TABCOLUMNS, WE NEED TO INSERT ITS INFORMATIONS IN TABLE OF SYANXCOL
--============================================================================================
drop table CSV2TABCOLUMNS;
drop table DR_CSVFile_Col1;
drop table DR_CSVFile_Col2;
drop table DR_CSVFile_Col3;
drop table DR_CSVFile_Col4;
drop table DR_CSVFile_Col5;
drop table DR_CSVFile_Col6;

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
    NEWVALUES varchar2(60):= ' ';
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
		execute immediate query_;
		commit;

	--  INSERTING DATA IN ALL TAB_COL
	
	for c_rec in cr loop 
		--columns_size:= regexp_count(c_rec.Col,';') ;
		columns_size:=nbr_columns;
		query_:= 'insert into CSV2TABCOLUMNS(';
		for i in 1 .. columns_size + 1 loop
			--best_type:=TYPE_OF('DR_CSVFile_Col2');
			
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
				NEWVALUES:=observation;
				COLUMN_width:=0;
				COLUMN_type:='NULL';
				nbr_words:=0;
			else  
				NEWVALUES:=a;
		
			END IF;
			
			
			if i = (columns_size+1) then
				columns_var:=columns_var||'col'||i||') VALUES(';
				columns_val:=columns_val||''''||a||''''||')';
				query_TABLE:='insert into DR_CSVFile_Col'||i||'(REFERENCES, OLDVALUES,SYNTACTICTYPE , COLUMNWIDHT,NUMBEROFWORDS)VALUES('''||preference||''','''||a||''','''||COLUMN_type||''','''||COLUMN_width||''','''||nbr_words||''')';
				observation:=' ';
				type_of_column('DR_CSVFile_Col4');
				--DBMS_OUTPUT.PUT_LINE(query_TABLE);
				Execute immediate query_TABLE;
				commit;
			else 
				columns_var:=columns_var||'col'||i||',';
				columns_val:=columns_val||''''||a||''''||',';
				
				--DBMS_OUTPUT.PUT_LINE(a||' =>: '||type_var);
				query_TABLE:='insert into DR_CSVFile_Col'||i||'(REFERENCES, OLDVALUES,SYNTACTICTYPE, COLUMNWIDHT,NUMBEROFWORDS)VALUES('''||preference||''','''||a||''','''||COLUMN_type||''','''||COLUMN_width||''','''||nbr_words||''')';
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
-- EXECUTION AND DISPLAY SOME RESULT - FOR INFORMATIONS
--============================================================================================
execute CSV2TAB;
select * from CSV2TABCOLUMNS;
select * from DR_CSVFile_Col1;
select * from DR_CSVFile_Col2;
select * from DR_CSVFile_Col3;
select * from DR_CSVFile_Col4;
select * from DR_CSVFile_Col5;
select * from DR_CSVFile_Col6;
--===========================================================================================
-- TEST TYPE_OF 
--==========================================================================================
CREATE OR REPLACE PROCEDURE type_of_column(c VARCHAR2)
IS
	best_type VARCHAR2(30);
BEGIN

		best_type:=TYPE_OF(c);
		DBMS_OUTPUT.PUT_LINE('dominant dans la columns : '||best_type);

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
execute type_of_column('DR_CSVFile_Col4');
--============================================================================================
-- OBSERVATION PROCEDURE 
--============================================================================================

