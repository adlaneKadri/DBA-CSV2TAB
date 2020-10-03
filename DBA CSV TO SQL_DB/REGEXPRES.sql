--============================================================================================
-- CREATE A TABLE TO SAVE ALL REGEXP :  it contain only  3 type 
--		- DATA
--		- NUMBER
--		- VARCHAR
--============================================================================================

drop table REGULAREXP CASCADE constraints;
CREATE TABLE REGULAREXP(
CATEGORY 			VARCHAR2(20), 
REGULAREXPRESSION 			VARCHAR2(200),
CONSTRAINT PK_REGULAREXP	PRIMARY KEY(CATEGORY),
CONSTRAINT CK_REGULAREXP_CATEGORY	CHECK(CATEGORY = UPPER(CATEGORY))
);

--============================================================================================
-- insert some regexpress 							    <- DDRE ->  
-- PS: there a lot of reg we can use, but we decide to start with this 
--============================================================================================

INSERT INTO REGULAREXP VALUES
('VARCHAR2', '^[[:alpha:][:digit:][°,-_+]+$');
INSERT INTO REGULAREXP VALUES
('DATE', '([0-2][0-9]|3[0-1])-(0[0-9]|1[0-2])-[0-9]{4}');
INSERT INTO REGULAREXP VALUES
('NUMBER', '^[[:digit:]]+$');

--============================================================================================
-- give a variable and we return the type -> here we treat only 3 type (date, number, string)
-- VerifRegExpr  return the category (type) of the variable 'p_variable'  
--============================================================================================


CREATE OR REPLACE FUNCTION VerifRegExpr(p_variable IN varchar2)
RETURN VARCHAR2
IS
	CURSOR test is select * from REGULAREXP;
	RESULT varchar2(50):='UNKNOWN';
	REGULAR VARCHAR2(1000);
	cat varchar(100);
BEGIN
		FOR Rec IN test 
		LOOP
			--DBMS_OUTPUT.PUT_LINE(Rec);
			if REGEXP_LIKE (UPPER(p_variable),Rec.REGULAREXPRESSION) 
			then 
				Result := Rec.CATEGORY;
			end if;

		END LOOP;
		RETURN(RESULT);
END;
/

--============================================================================================
-- CREATION OF TABLE REG EXPRESSION + insertion
--============================================================================================
@ddre

--============================================================================================
-- give a variable and we return the CATEGORY -> USING ALL DATA IN DDRE
--============================================================================================

CREATE OR REPLACE FUNCTION GET_CATEGORY(p_variable IN varchar2)
RETURN VARCHAR2
IS
	CURSOR test is select * from DDRE;
	RESULT varchar2(100):='UNKNOWN';
	REGULAR VARCHAR2(1000);
	cat varchar(100);
BEGIN
		FOR Rec IN test 
		LOOP

			--DBMS_OUTPUT.PUT_LINE(Rec);
			if REGEXP_LIKE (UPPER(p_variable),Rec.REGULAREXPRESSION) 
			then 
				Result := Rec.CATEGORY;
			end if;

		END LOOP;
		RETURN(RESULT);
END;
/

--============================================================================================
-- give a variable and we return the SUBCATEGORY -> USING ALL DATA IN DDRE
--============================================================================================
CREATE OR REPLACE FUNCTION GET_SUBCATEGORY(p_variable IN varchar2)
RETURN VARCHAR2
IS
	CURSOR test is select * from DDRE;
	RESULT varchar2(100):='UNKNOWN';
	REGULAR VARCHAR2(1000);
	cat varchar(100);
BEGIN
		FOR Rec IN test 
		LOOP

			--DBMS_OUTPUT.PUT_LINE(Rec);
			if REGEXP_LIKE (UPPER(p_variable),Rec.REGULAREXPRESSION) 
			then 
				Result := Rec.SUBCATEGORY;
			end if;

		END LOOP;
		RETURN(RESULT);
END;
/
