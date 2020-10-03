
-- =========================================================================
-- update OBSERVATION of each table -> DR_CSVFILE_COL<i>
-- =========================================================================
CREATE or replace PROCEDURE UPDATE_OBSERVATION_NEWVALUES(best_type varchar2)
as
CURSOR cr is select * from DR_CSVFILE_COL;
BEGIN
	FOR c_rec IN cr 
		LOOP
		--DBMS_OUTPUT.PUT_LINE(' '||c_rec.SYNTACTICTYPE||' ');
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



