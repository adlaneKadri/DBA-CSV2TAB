DROP TABLE EtudIUTV;
DROP TABLE EtudIG;
DROP TABLE T;

-- create etudIUTV table
CREATE TABLE EtudIUTV (
    id          VARCHAR2(20),
    Nom         VARCHAR2(30),
    Prenom      VARCHAR2(30),
    DateN       DATE,
    Ville       VARCHAR2(30),
    Pays        VARCHAR2(30)
);

--  create EtudIG table
CREATE TABLE EtudIG (
    NumE            VARCHAR2(20),
    NomE            VARCHAR2(30),
    PrenE           VARCHAR2(30),
    DN              DATE,
    Vil             VARCHAR2(30),
    Pay             VARCHAR2(30)
);

-- insertion
INSERT INTO EtudIUTV VALUES('i1', 'LE BON', 'Adam', '19/6/2001', 'Epinay sur seine', 'France');
INSERT INTO EtudIUTV VALUES('i2', 'BELLE', 'Clemence', '16/10/1996', 'Nice', 'France');
INSERT INTO EtudIUTV VALUES('i3', 'BELLE', 'C.', '16/10/1996', 'Nice', 'France');
INSERT INTO EtudIG VALUES('g1', 'LE BON', 'Adam', '19/6/2001', 'Epinay-sur-seine', 'France');
INSERT INTO EtudIG VALUES('g2', 'LEBON', 'Adams', '19/6/2001', 'Epinay-sur-seine', 'France');

-- CREATE AN UNION OF THE 2 TABLES 
CREATE TABLE T AS (
    SELECT * FROM EtudIUTV UNION SELECT * FROM EtudIG
    );


SELECT * FROM T;    
SELECT * FROM T ORDER BY ID;
SELECT DISTINCT * FROM T order by id ;


UPDATE T SET Nom = UPPER(Nom);
UPDATE T SET Prenom = UPPER(Prenom);
UPDATE T SET Ville = UPPER(Ville);
UPDATE T SET Pays = UPPER(Pays);


SELECT * FROM T;
SELECT UTL_MATCH.jaro_winkler_similarity(SOUNDEX(ville),SOUNDEX(Pays)) as prononce FROM 
T;





drop table t_join;
create table t_JOIN as 
(
    select  a.ID as id_1 ,a.NOM as nom_1 ,a.PRENOM as prenom_1 ,a.DATEN as date_1 ,a.VILLE as ville_1,
            b.ID as id_2 ,b.NOM as nom_2 ,b.PRENOM as prenom_2 ,b.DATEN as date_2 ,b.VILLE as ville_2,
            (   
            UTL_MATCH.jaro_winkler_similarity(SOUNDEX(a.nom),SOUNDEX(b.nom)) 
            + 
            UTL_MATCH.jaro_winkler_similarity(SOUNDEX(a.nom),SOUNDEX(b.nom))
            + 
            UTL_MATCH.jaro_winkler_similarity(SOUNDEX(a.PRENOM),SOUNDEX(b.PRENOM))
            +  
            UTL_MATCH.jaro_winkler_similarity(SOUNDEX(a.DATEN),SOUNDEX(b.DATEN))   
            + 
            UTL_MATCH.jaro_winkler_similarity(SOUNDEX(a.ID),SOUNDEX(b.ID))
            )/ 4 as dist 
from t  a, t  b
where 1=1
);


--display the new table , cross join of t with t 
select  id_1 , nom_1 , prenom_1 , date_1 , ville_1,id_2 , nom_2 , prenom_2 , date_2 , ville_2, dist from t_join;

--delete the row where it is the same row was joined 
delete from t_join where dist = 100;

--to display the content
select * from t_join;


--procedure to delete duplicate element

select * from EtudIUTV ; 
select * from EtudIG;

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
show errors;

