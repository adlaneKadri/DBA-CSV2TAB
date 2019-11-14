--USER 		: M1INFO_10 
--PASSWORD	: M1INFO_10
DROP TABLE NEW_T_JOIN;
DROP TABLE T;
DROP TABLE NEW_T;
DROP TABLE EtudIG;
DROP TABLE EtudIUTV;
COLUMN id  FORMAT A20;
COLUMN Nom  FORMAT A30;
COLUMN Prenom  FORMAT A30;
COLUMN DateN  FORMAT A10;
COLUMN Ville  FORMAT A30;
COLUMN Pays FORMAT A20;
COLUMN NumE FORMAT A20;
COLUMN NomE FORMAT A30;
COLUMN PrenE FORMAT A30;
COLUMN DN FORMAT A10;
COLUMN Vil FORMAT A30;
COLUMN Pay FORMAT A20;
set line 1000;
set pages 200;

CREATE TABLE EtudIUTV (
    id          VARCHAR2(20),
    Nom         VARCHAR2(30),
    Prenom      VARCHAR2(30),
    DateN       DATE,
    Ville       VARCHAR2(30),
    Pays        VARCHAR2(30)
);

CREATE TABLE EtudIG (
    NumE            VARCHAR2(20),
    NomE            VARCHAR2(30),
    PrenE           VARCHAR2(30),
    DN              DATE,
    Vil             VARCHAR2(30),
    Pay             VARCHAR2(30)
);

INSERT INTO EtudIUTV VALUES('i1', 'LE BON', 'Adam', '19/6/2001', 'Epinay sur seine', 'France');
INSERT INTO EtudIUTV VALUES('i2', 'BELLE', 'Clemence', '16/10/1996', 'Nice', 'France');
INSERT INTO EtudIUTV VALUES('i3', 'BELLE', 'C.', '16/10/1996', 'Nice', 'France');
INSERT INTO EtudIG VALUES('g1', 'LE BON', 'Adam', '19/6/2001', 'Epinay-sur-seine', 'France');
INSERT INTO EtudIG VALUES('g2', 'LEBON', 'Adams', '19/6/2001', 'Epinay-sur-seine', 'France');
--=========================================================================================
--  JOIN ALL TABLES IN ONLY ONE TABLE
--=========================================================================================
CREATE TABLE T AS (
    SELECT * FROM EtudIUTV UNION SELECT * FROM EtudIG
    );

SELECT * FROM T;    
--=================================================================================
--  CHAGE TO UPPER ALL VARIAVLES CONTENT
--=================================================================================
UPDATE T SET ID = UPPER(ID);
UPDATE T SET Nom = UPPER(Nom);
UPDATE T SET Prenom = UPPER(Prenom);
UPDATE T SET Ville = UPPER(Ville);
UPDATE T SET Pays = UPPER(Pays);

SELECT * FROM T;    
/*
--=================================================================================
--procedure to delete duplicate element
--=================================================================================
CREATE OR REPLACE PROCEDURE delete_duplicate(seuil IN NUMBER) IS
    CURSOR cr IS  select * from t_join;
    exist           NUMBER(4) := 0;
    BEGIN
        FOR cr_row IN cr LOOP
            --DBMS_OUTPUT.put_line('id : '||cr_row.id_2||' Nom: '||cr_row.nom_2||' prenom: '||cr_row.prenom_2);
            if cr_row.dist >= seuil then
                --DBMS_OUTPUT.put_line('id : '||cr_row.id_2||' Nom: '||cr_row.nom_2||' prenom: '||cr_row.prenom_2);
                DBMS_OUTPUT.put_line(cr_row.id_1);
                select count(*) into exist from EtudIG t where UPPER(t.nume) =UPPER(cr_row.id_1) and UPPER(t.NOME) = UPPER(cr_row.nom_1) and UPPER(t.PRENE) = UPPER(cr_row.prenom_1);
                --and t.nome=cr_row.nom_1 and t.prene =cr_row.prenom_1 and t.DN = cr_row.date_1 and t.VIL = cr_row.ville_1 and t.PAY = cr_row.pays_1;
                if exist > 0 then
                    DBMS_OUTPUT.put_line('id : '||cr_row.id_2||' Nom: '||cr_row.nom_2||' prenom: '||cr_row.prenom_2);
                end if;
            end if;
        end loop;
    end;
    /
execute DELETE_DUPLICATE(97);

set SERVEROUTPUT on;
--show errors;
*/

--======================================================================== 
-- PROCEDURE TO CREATE A JOIN OF TWO TABLE 
--========================================================================
select * from T; 
CREATE OR REPLACE PROCEDURE TABLE_JOIN(table_name VARCHAR, similarity_function VARCHAR)
as 
query_ VARCHAR(1000);
begin 
    query_ :='
    create table T_JOIN as (
        select  a.ID as id_1 ,a.NOM as nom_1 ,a.PRENOM as prenom_1 ,a.DATEN as date_1 ,a.VILLE as ville_1, a.PAYS as pays_1,
                b.ID as id_2 ,b.NOM as nom_2 ,b.PRENOM as prenom_2 ,b.DATEN as date_2 ,b.VILLE as ville_2, b.PAYS as pays_2,
                (   
                UTL_MATCH.'||similarity_function||'(SOUNDEX(a.nom),SOUNDEX(b.nom))
                + 
                UTL_MATCH.'||similarity_function||'(SOUNDEX(a.PRENOM),SOUNDEX(b.PRENOM))
                +  
                UTL_MATCH.'||similarity_function||'(a.DATEN,b.DATEN)   
                + 
                UTL_MATCH.'||similarity_function||'(SOUNDEX(a.ID),SOUNDEX(b.ID))
                )/ 4 as dist 
        from '||table_name||'  a, '||table_name||'  b
        where 1=1
        )';
    EXECUTE IMMEDIATE query_; 
end; 
/
--=======================================================================
--   EXECUTE THE JOIN OF TABLE T 
--=======================================================================
execute TABLE_JOIN('T', 'jaro_winkler_similarity');
select * from t_join;
--=======================================================================
--   PROCEDURE  TO DELETE DUPLICATE and create NEW_T_JOIN Table
--=======================================================================
CREATE OR REPLACE PROCEDURE DELETE_DUPLICATE(seuil number)
as
query_ VARCHAR(1000);
begin
    delete from t_join where dist>=seuil;
    query_:='CREATE table new_t_join as (
        select ID_1,NOM_1,PRENOM_1,DATE_1,VILLE_1, PAYS_1 FROM t_join 
    )';
    EXECUTE IMMEDIATE query_;
end;
/

select * from t_join; 
EXECUTE DELETE_DUPLICATE(75);
select * from t_join; 
-- new table with only valide rows , but a duplicate valid rows
select * from new_t_join;


--=================================
--DELETE DUPLICATE ROWS
--================================
DELETE from new_t_join 
where  (select
        ROW_NUMBER() OVER (
            PARTITION BY 
                ID_1,NOM_1,PRENOM_1,DATE_1,VILLE_1, PAYS_1
            ORDER BY 
                ID_1,NOM_1,PRENOM_1,DATE_1,VILLE_1, PAYS_1
        ) as row_values )>1
;
