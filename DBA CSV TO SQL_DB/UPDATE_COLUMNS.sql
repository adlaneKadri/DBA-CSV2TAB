-- =========================================================================
-- create a temp table that containt the same information about all tables 
-- =========================================================================

create table DR_CSVFILE_COL (
	REFERENCES VARCHAR2(100),
	OLDVALUES VARCHAR2(1000), 
	SYNTACTICTYPE VARCHAR2(100), 
	COLUMNWIDHT number(5),
	NUMBEROFWORDS number(2), 
	OBSERVATION VARCHAR2(1000), 
	NEWVALUES VARCHAR2(1000),
	SEMANTICCATEGORY VARCHAR2(1000) ,
	SEMANTICSUBCATEGORY VARCHAR2(1000)
);

-- =========================================================================
-- update Copy each DR_CSVFILE_COL<i> in DR_CSVFILE_COL to treat it
-- =========================================================================

CREATE OR REPLACE PROCEDURE update_DR_CSVFILE_COL
AS
    nomber_of_table_created  number:=1;
    query VARCHAR2(2000) :='';
    OBSERVATION varchar2(60):= ' ';
    best_type VARCHAR2(100);
BEGIN
	nomber_of_table_created:=nbr_columns;
	for i in 1 .. nomber_of_table_created + 1 loop
	
		--  insert  le contenu de DR_CSVFILE_COL<i> dans la table DR_CSVFILE_COL pour la traiter
		query := 'insert into DR_CSVFILE_COL (select * from DR_CSVFILE_COL'||i||' )';
		EXECUTE IMMEDIATE query;
		
		best_type:=TYPE_OF('DR_CSVFILE_COL'||i);
		--DBMS_OUTPUT.PUT_LINE('dominant dans la columns '||i||':'||best_type);
		UPDATE_OBSER_NEWVAL_CAT_SUBCAT(best_type);			
		--  vider la table DR_CSVFILE_COL <i>
		query := 'delete from DR_CSVFILE_COL'||i ;
		EXECUTE IMMEDIATE query;
		-- copy DR_CSVFIL_COL on DR_CSVFIL_COL<i>
		query := 'insert into DR_CSVFILE_COL'||i||' (select * from DR_CSVFILE_COL )';
		EXECUTE IMMEDIATE query;

		--  vider la table DR_CSVFILE_COL
		query := 'delete from DR_CSVFILE_COL ';
		EXECUTE IMMEDIATE query;

	end loop;
END;
/




-- =========================================================================
-- update OBSERVATION of each table -> DR_CSVFILE_COL<i>
-- =========================================================================
CREATE or replace PROCEDURE UPDATE_OBSER_NEWVAL_CAT_SUBCAT(best_type varchar2)
as
CURSOR cr is select * from DR_CSVFILE_COL;
SEMANTICCATEGORY_ varchar2(100):='';
SEMANTICSUBCATEGORY_ varchar2(100):='';
BEGIN
	FOR c_rec IN cr 
		LOOP
		--DBMS_OUTPUT.PUT_LINE(' '||c_rec.SYNTACTICTYPE||' ');
		
		--UPDATE CATEGORY AND SUB CATEGORY
		SEMANTICCATEGORY_ 			:=GET_CATEGORY(c_rec.OLDVALUES);
		SEMANTICSUBCATEGORY_		:=GET_SUBCATEGORY(c_rec.OLDVALUES);
		update 	DR_CSVFILE_COL 
					set 	SEMANTICCATEGORY 		= SEMANTICCATEGORY_
					where 	OLDVALUES=c_rec.OLDVALUES 
					and 	SYNTACTICTYPE=c_rec.SYNTACTICTYPE  
					and  	COLUMNWIDHT=c_rec.COLUMNWIDHT 
					and 	NUMBEROFWORDS =c_rec.NUMBEROFWORDS;

		update 	DR_CSVFILE_COL 
					set 	SEMANTICSUBCATEGORY 		= SEMANTICSUBCATEGORY_
					where 	OLDVALUES=c_rec.OLDVALUES 
					and 	SYNTACTICTYPE=c_rec.SYNTACTICTYPE  
					and  	COLUMNWIDHT=c_rec.COLUMNWIDHT 
					and 	NUMBEROFWORDS =c_rec.NUMBEROFWORDS;
		
		if c_rec.SYNTACTICTYPE != best_type then 
			if c_rec.SYNTACTICTYPE != 'NULL' then
				--DBMS_OUTPUT.PUT_LINE(best_type||' < > '||c_rec.SYNTACTICTYPE||' ');
				-- update OBSERVATION
				update 	DR_CSVFILE_COL 
					set 	OBSERVATION = c_rec.OLDVALUES||'<!?!>ANOMALY' 
					where 	OLDVALUES = c_rec.OLDVALUES 
					and 	SYNTACTICTYPE = c_rec.SYNTACTICTYPE 
					and  	COLUMNWIDHT = c_rec.COLUMNWIDHT 
					and 	NUMBEROFWORDS = c_rec.NUMBEROFWORDS  ;
				-- update NEWVALUES
				update 	DR_CSVFILE_COL 
					set 	NEWVALUES = c_rec.OLDVALUES||'<!?!>ANOMALY' 
					where 	OLDVALUES = c_rec.OLDVALUES 
					and 	SYNTACTICTYPE = c_rec.SYNTACTICTYPE  
					and  	COLUMNWIDHT = c_rec.COLUMNWIDHT 
					and 	NUMBEROFWORDS = c_rec.NUMBEROFWORDS ;
				
				
			else 
				--DBMS_OUTPUT.PUT_LINE(c_rec.SYNTACTICTYPE||' rahou vide' );
				-- update NEWVALUES
				update 	DR_CSVFILE_COL 
					set 	NEWVALUES = c_rec.OBSERVATION 
					where 	OLDVALUES = c_rec.OLDVALUES 
					and	SYNTACTICTYPE=c_rec.SYNTACTICTYPE ;
				
				update 	DR_CSVFILE_COL 
					set 	SEMANTICSUBCATEGORY = 'NULL'
					where 	OLDVALUES = c_rec.OLDVALUES 
					and	SYNTACTICTYPE=c_rec.SYNTACTICTYPE ;
				
				update 	DR_CSVFILE_COL 
					set 	SEMANTICCATEGORY = 'NULL'
					where 	OLDVALUES = c_rec.OLDVALUES 
					and	SYNTACTICTYPE=c_rec.SYNTACTICTYPE ;
			end if;
		else 
			--DBMS_OUTPUT.PUT_LINE(best_type||' = '||c_rec.SYNTACTICTYPE||' ');
			-- update NEWVALUES
			update 	DR_CSVFILE_COL 
				set 	NEWVALUES=c_rec.OLDVALUES 
				where 	OLDVALUES=c_rec.OLDVALUES 
				and 	SYNTACTICTYPE=c_rec.SYNTACTICTYPE  
				and  	COLUMNWIDHT=c_rec.COLUMNWIDHT 
				and 	NUMBEROFWORDS =c_rec.NUMBEROFWORDS;
		end if;

		
	END LOOP;
END;
/

EXECUTE update_DR_CSVFILE_COL;