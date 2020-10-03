-- =========================================================================
-- update Category and sub_CATEGORY of each table -> DR_CSVFILE_COL<i>
-- =========================================================================
CREATE or replace PROCEDURE UPDATE_SEMANTIC_CAT_SUBCAT
as
CURSOR cr is select * from DR_CSVFILE_COL;
SEMANTICCATEGORY_ varchar2(2000):='';
SEMANTICSUBCATEGORY_ varchar2(2000):='';
BEGIN
	FOR c_rec IN cr 
		LOOP
			SEMANTICCATEGORY_ 			:=GET_CATEGORY(c_rec.OLDVALUES);
			SEMANTICSUBCATEGORY_		:=GET_SUBCATEGORY(c_rec.OLDVALUES);

			update 	DR_CSVFILE_COL 
				set 	SEMANTICCATEGORY 		= GET_CATEGORY(c_rec.OLDVALUES);
				where 	OLDVALUES=c_rec.OLDVALUES 
				and 	SYNTACTICTYPE=c_rec.SYNTACTICTYPE  
				and  	COLUMNWIDHT=c_rec.COLUMNWIDHT 
				and 	NUMBEROFWORDS =c_rec.NUMBEROFWORDS;

			update 	DR_CSVFILE_COL 
				set 	SEMANTICSUBCATEGORY 		= GET_SUBCATEGORY(c_rec.OLDVALUES);
				where 	OLDVALUES=c_rec.OLDVALUES 
				and 	SYNTACTICTYPE=c_rec.SYNTACTICTYPE  
				and  	COLUMNWIDHT=c_rec.COLUMNWIDHT 
				and 	NUMBEROFWORDS =c_rec.NUMBEROFWORDS;
	END LOOP;
END;
/




