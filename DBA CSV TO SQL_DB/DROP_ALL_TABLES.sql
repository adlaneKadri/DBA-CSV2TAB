-- pour supprimier toutes les tables crée

CREATE OR REPLACE PROCEDURE drop_All_tables
AS
    nomber_of_table_created  number:=1;
    query VARCHAR2(2000) :='';
BEGIN
	nomber_of_table_created:=nbr_columns;
	for i in 1 .. nomber_of_table_created + 1 loop
		query := 'drop table DR_CSVFILE_COL'||i;
		EXECUTE IMMEDIATE query;			
	end loop;

	query :='drop table CSV2TABCOLUMNS';
	EXECUTE IMMEDIATE query;

	query :='drop table DR_CSVFILE_COL';
	EXECUTE IMMEDIATE query;
END;
/

EXECUTE drop_All_tables