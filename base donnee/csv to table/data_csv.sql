-- ===============================================================================
-------- UniversitÈ Sorbonne Paris CitÈ, UniversitÈ Paris 13 , Institut GaliÈe
-------- Master 2 (M2 EID2), Informatique, IngÈnieur
-------- Exploration Informatique des DonnÈes et DÈcisionnel
-- ===============================================================================
-------- La Data ; The Data
-------- La DonnÈe est le monde du futur ; Les donnÈes et le monde de l'avenir
-------- The Data is the world of the future ;  The Data and the future's world

-------- DATA -->>> Big Data, Dark Data, Open Data, ... 
-- ===============================================================================
-------- Bases de DonnÈes AvancÈes = Advanced Databases (BDA)
-------- EntrepÙts de DonnÈes = Data Warehouses (DWH, EDON)
-------- Lacs de DonnÈes = Data Lakes (LD, DL)


-------- Directeur :  Dr. M. Faouzi BoufarËs (MFB)
-------- Enseignant-Chercheur Responsable      

-------- Page Web : http://www.lipn.univ-paris13.fr/~boufares

-- ==========================================================================================
-- ======= MFB = From a CSV file TO a TABLE with columns ! ==================================

-- ===================================================
-- Binome numÈro : Bxy
-- NOM1 PrÈnom 1 :
-- NOM2 PrÈnom 2 :
-- ===================================================

-- ==========================================================================================
-- ======= MFB = From a CSV file TO a TABLE with columns ! ==================================

-- >>>>>>>>>> FROM CSV TO Table-Columns
-- >>>>>>>>>> Csv2Tab Csv2Tab Csv2Tab Csv2Tab
-- >>>>>>>>>> A LA DECOUVERTE DES ANOMALIES !
-- >>>>>>>>>> !!!!!!!!!!!!!!!!!!!!!!!!!!!!! !
-- ==========================================================================================

/*

Les donnÈes dans les fichiers CSV peuvent contenir plusieurs anomalies ‡ cause de l'hÈtÈrogÈnÈitÈ des sources et des outils utilisÈs !

Plusieurs types d'anomalies existent dans ces donnÈes!

Plusieurs actions de nettoyages (Data Cleaning) sont nÈcessaires telles que :
- l'homogÈnÈisation et la standardisation
- la dÈtection de certaines anoamlies (intracolonne, intercolonnes et interlignes
- la correction de certaines anoamlies

Afin de mieux nettoyer les donnÈes, il est nÈcessaire de (re)-dÈcouvrir les mÈta-donnÈes et leur sÈmantique :
- le type syntaxique de chaque colonne
- le sens (la sÈmantique) de chaque colonne
 

Les fichiers, au format CSV, sont chargÈs sous forme d'une table composÈe d'une seule colonne de type chaine de caractËres

-- La colonne Col sera dÈcomposÈe en plusieurs colonnes de mÍme type (chaine de caractËres)
-- Chaque colonne devra ensuite Ítre typÈe selon son contenu majoritaire (STRING-CHAR-VARCHAR, NUMBER ou DATE)
-- Etc... A LA DECOUVERTE DES ANOMALIES !

*/

/*
-- ===================================================
-- >>>>>>>>>>>>>>>> EXEMPLE 1 <<<<<<<<<<<<<<<<<<<<<<<<
-- ===================================================

-- >>>>>>>>>>>>>>>> CSVfile1

Adam;Paris;M;19;19-06-2001;38∞C
Eve;Paris;F;23;16-10-1996;37∞C
Gabriel;Paris;m;18;17-09-2002;36,5∞C
Mariam;Paris;F;41;13-08-1978;38Celcius
Nadia;Londres;f;55;10-10-1965;95∞F
InËs;Madrid;F;50;22-11-1969;99,5∞F
Inconnu;77;12-12-2012
Abnomly;Rome;1;88;02-10-2019;38∞C
Anomalies;Tunis;f;99;25-30-2020;x
Adam;Paris;M;19;19-06-2001;38∞C
Eve;Paris;F;23;16-10-1996;37∞C
Marie;Pari;F;41;17-09-1979;38Celcius

*/



CREATE TABLE CSVfile1 (Col VARCHAR2(1000));

INSERT INTO CSVfile1 VALUES ('Adam;Paris;M;19;19-06-2001;38∞C');
INSERT INTO CSVfile1 VALUES ('Eve;Paris;F;23;16-10-1996;37∞C');
INSERT INTO CSVfile1 VALUES ('Gabriel;Paris;m;18;17-09-2002;36,5∞C');
INSERT INTO CSVfile1 VALUES ('Mariam;Paris;F;41;13-08-1978;38Celcius');
INSERT INTO CSVfile1 VALUES ('Nadia;Londres;f;55;10-10-1965;95∞F');
INSERT INTO CSVfile1 VALUES ('InËs;Madrid;F;50;22-11-1969;99,5∞F');
INSERT INTO CSVfile1 VALUES ('Inconnu;77;12-12-2012');
INSERT INTO CSVfile1 VALUES ('Abnomly;Rome;1;88;02-10-2019;38∞C');
INSERT INTO CSVfile1 VALUES ('Anomalies;Tunis;f;99;25-30-2020;x');
INSERT INTO CSVfile1 VALUES ('Adam;Paris;M;19;19-06-2001;38∞C');
INSERT INTO CSVfile1 VALUES ('Eve;Paris;F;23;16-10-1996;37∞C');
INSERT INTO CSVfile1 VALUES ('Marie;Pari;F;41;17-09-1979;38Celcius');

COMMIT;

/*
-- ===================================================
-- >>>>>>>>>>>>>>>> EXEMPLE 2 <<<<<<<<<<<<<<<<<<<<<<<<
-- ===================================================

-- >>>>>>>>>>>>>>>> CSVfile2

Id01;Eve;PREMIER;19-ao˚t-1988;eve.premier@labas.fr;2;F;40983,3 g;France;Europe;71,279;87.53∞F;638,76 cm
Id02;Claire;SOLEIL;10-fÈvrier-1965;claire.soleil@gmail.com;A-;F;44456,57 g;Itale;;62,623;35;$1
Id03;Rose;PARIS;20-ao˚t-1974;rose.paris@gmail;A+;F;50723,21 g;SÈnÈgal;Afrique;105,304;102.42  ∞F;77
Id04;Mamadou;TROPFOR;10-02-1965;mamadou.tropfor@hotmail.com;1;M;91,11 KG;Qatar;Asie;10;26.93∞C;10,96 m
Id05;Mamadou;DELOIN;19-08-1988;mamadou.deloin@gmail.com;B-;M;58,74 KG;Tunisie;Afrique;46;25;**
Id06;MÈdecin;PLUS BELLE;03-01-1975;mÈdecin.plus belle@gmail.com;A+;M;66,94 KG;Tunisie;Afrique;9;25;0
Id07;Ibrahim;SPORTIF;17-08-1969;ibrahim.sportif@gmail.com;B-;M;86,33 KG;AlgÈrie;Afrique;33;41.44 ∞c;9,22 m
Id08;Kenza;MIGNONNE;18-mai-1960;kenza.mignonne@hotmail.com;2;F;63159,57 g;BrÈsil;AmÈrique;105,158;111.29∞F;736,84 cm
Id09;InËs;TROPFOR;27-novembre-1999;inËs.tropfor@yahoo.fr;X;X;40983,3 g;Espagne;;93,323;91.1∞F;77
Id10;Rayan;FORT;24-06-1995;rayan.fort@hotmail.com;AB;M;88,87 KG;Maroc;Afrique;74;26.26∞C;20,97 m
Id11;Marie;FORT;06-ao˚t-1974;marie.fort@yahoo;1;0;72425,34 g;AlgÈrie;Afrique;60,732;87.53∞F;476,25 cm
Id12;MÈdecin;PLUS BELLE;18-05-1960;mÈdecin.plus belle@hotmail.com;AB+;M;82,68 KG;Tunisie;Afrique;60;20.9∞C;1
Id13;Omar;GRANDE;25-02-1995;omar.grande@yahoo.fr;A+;M;64,63 KG;Itale;;53;26.26∞C;**
Id14;Adam;GRANDE;21-05-1969;adam.grande@hotmail.com;AB;M;66,94 KG;Espagne;;24;41.44 ∞c;13,28 m
Id15;Alain;AIMANT;21-01-1979;alain.aimant@gmail;B+;Y;64,54 KG;Chine;Asie;47;41.44 ∞c;13,28 m
Id16;Rayan;MIGNONNE;10-02-1965;rayan.mignonne@hotmail.com;A+;M;88,87 KG;Qatar;Asie;10;15.67∞C;1
Id17;Faouzi;UNIQUE;27-11-1999;faouzi.unique@gmail.com;AB-;M;0;Belgique;Europe;62;25.32∞Celcius;13,28 m
Id18;Fleurette;PREMIER;21-janvier-1979;fleurette.premier@hotmail.com;2;F;44456,57 g;Allemagne;Europe;135,238;119.05∞F;679,87 cm
Id19;Sabrine;BON;25-fÈvrier-1995;sabrine.bon@gmail.com;2;F;44456,57 g;France;Europe;136,181;114.03∞F;713,41 cm
Id20;Maria;DELOIN;25-fÈvrier-1995;maria.deloin@hotmail.com;AB;F;44456,57 g;Canada;AmÈrique;131,203;102.42  ∞F;638,76 cm
Id21;Faouzi;EXCELLE;03-01-1975;faouzi.excelle@gmail.com;O-;M;93,88 KG;Canada;AmÈrique;57;26.93∞C;14,98 m
Id22;Marie;SPORTIF;20-ao˚t-1974;marie.sportif@gmail.com;AB+;X;48710,39 g;Chine;Asie;41,529;35;644,34 cm
Id23;Eve;PARIS;03-janvier-1975;eve.paris@hotmail.com;X;F;42015,79 g;Tunisie;Afrique;28,967;102.42  ∞F;713,41 cm
Id24;Omar;CLEMENT;14-01-1978;omar.clement@yahoo.fr;AB+;M;64,54 KG;France;Europe;37;41.44 ∞c;12,95 m
Id25;Emna;JOLIE;17-ao˚t-1969;emna.jolie@hotmail.com;B-;F;71214,11g;Itale;;41,249;114.03∞F;713,41 cm
Id26;Ibrahim;PARIS;27-11-1993;ibrahim.paris@hotmail.com;-;M;58,74 KG;Tunisie;Afrique;59;41.44 ∞c;9,22 m
Id27;ClÈment;TOUIL;27-11-1999;clÈment.touil@hotmail.com;AB-;M;58,74 KG;Tunisie;Afrique;34;26.93∞C;1
Id28;Jean;SPORTIF;27-11-1993;jean.sportif@hotmail.com;AB+;M;64,24 KG;France;;69;41.44 ∞c;12,94 m
Id29;Alain;MIGNONNE;10-02-1965;alain.mignonne@ici.tn;B-;M;0;Tunisie;Afrique;10;;1
Id30;MÈdecin;MOUSTAFA;19-08-1988;mÈdecin.moustafa@yahoo.fr;AB;M;64,54 KG;Maroc;Afrique;44;38.05∞C;20,97 m
Id31;ClÈment;MOUSTAFA;27-11-1993;clÈment.moustafa@yahoo.fr;1;M;58,74 KG;France;;60;38.13∞C;20,97 m
Id32;Mamadou;FORT;08-12-1982;mamadou.fort@gmail.com;A-;M;0;Maroc;Afrique;58;25;**
Id33;Emna;FORT;19-ao˚t-1988;emna.fort@gmail.com;A+;F;65850,12 g;Maroc;Afrique;64,365;84.91∞F;$1
Id34;Omar;PARIS;18-05-1960;omar.paris@gmail.com;AB-;M;64,63 KG;Malie;Afrique;73;26.93∞C;**
Id35;Mamadou;CLEMENT;24-06-1995;mamadou.clement@hotmail.com;AB-;M;86,33 KG;Canada;AmÈrique;50;38.05∞C;12,95 m
Id36;Mamadou;SOLEIL;24-06-1995;mamadou.soleil@gmail;A;0;64,24 KG;Espagne;;44;38.05∞C;2,39 m
Id37;Ibrahim;BELLE;08-12-1982;ibrahim.belle@gmail;A-;M;64,63 KG;France;Europe;12;20.9∞C;12,94 m
Id38;Ibrahim;PLUS BELLE;08-09-1960;ibrahim.plus belle@hotmail.com;B+;0;64,24 KG;France;;9;25.04∞C;0
Id39;ClÈment;PRINTEMPS;27-11-1999;clÈment.printemps@gmail.com;O+;M;93,88 KG;AlgÈrie;Afrique;33;20.9∞C;2,39 m
Id40;Claire;SPORTIF;24-juin-1995;claire.sportif@yahoo.fr;B+;F;72425,34 g;Tunisie;Afrique;121,929;119.05∞F;428,03 cm
Id41;Eve;RAHMA;25-fÈvrier-1995;eve.rahma@gmail.com;X;F;63282,34 g;Portugal;Europe;56,813;102.42  ∞F;0
Id42;ClÈmence;SPORTIF;30-avril-2000;clÈmence.sportif@yahoo.fr;B+;F;72425,34 g;Portugal;Europe;135,288;111.29∞F;77
Id43;Jean;INFORME;17-08-1969;jean.informe@ici.tn;O-;Y;86,33 KG;SÈnÈgal;Afrique;71;;0
Id44;Jean;SOLEIL;05-06-1993;jean.soleil@hotmail.com;2;M;1;Canada;AmÈrique;18;26.93∞C;20,97 m
Id45;Ibrahim;TROPFOR;01-03-1967;ibrahim.tropfor@hotmail.com;A+;0;64,54 KG;Itale;;72;20.9∞C;10,96 m
Id46;Faouzi;AIMANT;14-01-1978;faouzi.aimant@ici.tn;AB+;Y;0;Argentine;AmÈrique;12;25.32∞Celcius;2,39 m
Id47;Fleurette;UNIQUE;03-janvier-1975;fleurette.unique@gmail.com;AB+;F;71214,11g;Chine;Asie;146,323;111.29∞F;644,34 cm
Id48;Jean;CLEMENT;25-02-1995;jean.clement@hotmail.com;O+;M;0;AlgÈrie;Afrique;11;25.32∞Celcius;10,96 m
Id49;Ibrahim;FORT;21-05-1969;ibrahim.fort@gmail.com;AB-;M;1;Malie;Afrique;33;25;10,96 m
Id50;Sabrine;EXCELLE;14-fÈvrier-1966;sabrine.excelle@yahoo.fr;B-;F;44456,57 g;Portugal;Europe;64,008;91.1∞F;644,34 cm

*/

CREATE TABLE CSVfile2 (Col VARCHAR2(1000));

INSERT INTO CSVFile2 VALUES ('Id01;Eve;PREMIER;19-ao˚t-1988;eve.premier@labas.fr;2;F;40983,3 g;France;Europe;71,279;87.53∞F;638,76 cm');
INSERT INTO CSVFile2 VALUES ('Id02;Claire;SOLEIL;10-fÈvrier-1965;claire.soleil@gmail.com;A-;F;44456,57 g;Itale;;62,623;35;$1');
INSERT INTO CSVFile2 VALUES ('Id03;Rose;PARIS;20-ao˚t-1974;rose.paris@gmail;A+;F;50723,21 g;SÈnÈgal;Afrique;105,304;102.42  ∞F;77');
INSERT INTO CSVFile2 VALUES ('Id04;Mamadou;TROPFOR;10-02-1965;mamadou.tropfor@hotmail.com;1;M;91,11 KG;Qatar;Asie;10;26.93∞C;10,96 m');
INSERT INTO CSVFile2 VALUES ('Id05;Mamadou;DELOIN;19-08-1988;mamadou.deloin@gmail.com;B-;M;58,74 KG;Tunisie;Afrique;46;25;**');
INSERT INTO CSVFile2 VALUES ('Id06;MÈdecin;PLUS BELLE;03-01-1975;mÈdecin.plus belle@gmail.com;A+;M;66,94 KG;Tunisie;Afrique;9;25;0');
INSERT INTO CSVFile2 VALUES ('Id07;Ibrahim;SPORTIF;17-08-1969;ibrahim.sportif@gmail.com;B-;M;86,33 KG;AlgÈrie;Afrique;33;41.44 ∞c;9,22 m');
INSERT INTO CSVFile2 VALUES ('Id08;Kenza;MIGNONNE;18-mai-1960;kenza.mignonne@hotmail.com;2;F;63159,57 g;BrÈsil;AmÈrique;105,158;111.29∞F;736,84 cm');
INSERT INTO CSVFile2 VALUES ('Id09;InËs;TROPFOR;27-novembre-1999;inËs.tropfor@yahoo.fr;X;X;40983,3 g;Espagne;;93,323;91.1∞F;77');
INSERT INTO CSVFile2 VALUES ('Id10;Rayan;FORT;24-06-1995;rayan.fort@hotmail.com;AB;M;88,87 KG;Maroc;Afrique;74;26.26∞C;20,97 m');
INSERT INTO CSVFile2 VALUES ('Id11;Marie;FORT;06-ao˚t-1974;marie.fort@yahoo;1;0;72425,34 g;AlgÈrie;Afrique;60,732;87.53∞F;476,25 cm');
INSERT INTO CSVFile2 VALUES ('Id12;MÈdecin;PLUS BELLE;18-05-1960;mÈdecin.plus belle@hotmail.com;AB+;M;82,68 KG;Tunisie;Afrique;60;20.9∞C;1');
INSERT INTO CSVFile2 VALUES ('Id13;Omar;GRANDE;25-02-1995;omar.grande@yahoo.fr;A+;M;64,63 KG;Itale;;53;26.26∞C;**');
INSERT INTO CSVFile2 VALUES ('Id14;Adam;GRANDE;21-05-1969;adam.grande@hotmail.com;AB;M;66,94 KG;Espagne;;24;41.44 ∞c;13,28 m');
INSERT INTO CSVFile2 VALUES ('Id15;Alain;AIMANT;21-01-1979;alain.aimant@gmail;B+;Y;64,54 KG;Chine;Asie;47;41.44 ∞c;13,28 m');
INSERT INTO CSVFile2 VALUES ('Id16;Rayan;MIGNONNE;10-02-1965;rayan.mignonne@hotmail.com;A+;M;88,87 KG;Qatar;Asie;10;15.67∞C;1');
INSERT INTO CSVFile2 VALUES ('Id17;Faouzi;UNIQUE;27-11-1999;faouzi.unique@gmail.com;AB-;M;0;Belgique;Europe;62;25.32∞Celcius;13,28 m');
INSERT INTO CSVFile2 VALUES ('Id18;Fleurette;PREMIER;21-janvier-1979;fleurette.premier@hotmail.com;2;F;44456,57 g;Allemagne;Europe;135,238;119.05∞F;679,87 cm');
INSERT INTO CSVFile2 VALUES ('Id19;Sabrine;BON;25-fÈvrier-1995;sabrine.bon@gmail.com;2;F;44456,57 g;France;Europe;136,181;114.03∞F;713,41 cm');
INSERT INTO CSVFile2 VALUES ('Id20;Maria;DELOIN;25-fÈvrier-1995;maria.deloin@hotmail.com;AB;F;44456,57 g;Canada;AmÈrique;131,203;102.42  ∞F;638,76 cm');
INSERT INTO CSVFile2 VALUES ('Id21;Faouzi;EXCELLE;03-01-1975;faouzi.excelle@gmail.com;O-;M;93,88 KG;Canada;AmÈrique;57;26.93∞C;14,98 m');
INSERT INTO CSVFile2 VALUES ('Id22;Marie;SPORTIF;20-ao˚t-1974;marie.sportif@gmail.com;AB+;X;48710,39 g;Chine;Asie;41,529;35;644,34 cm');
INSERT INTO CSVFile2 VALUES ('Id23;Eve;PARIS;03-janvier-1975;eve.paris@hotmail.com;X;F;42015,79 g;Tunisie;Afrique;28,967;102.42  ∞F;713,41 cm');
INSERT INTO CSVFile2 VALUES ('Id24;Omar;CLEMENT;14-01-1978;omar.clement@yahoo.fr;AB+;M;64,54 KG;France;Europe;37;41.44 ∞c;12,95 m');
INSERT INTO CSVFile2 VALUES ('Id25;Emna;JOLIE;17-ao˚t-1969;emna.jolie@hotmail.com;B-;F;71214,11g;Itale;;41,249;114.03∞F;713,41 cm');
INSERT INTO CSVFile2 VALUES ('Id26;Ibrahim;PARIS;27-11-1993;ibrahim.paris@hotmail.com;-;M;58,74 KG;Tunisie;Afrique;59;41.44 ∞c;9,22 m');
INSERT INTO CSVFile2 VALUES ('Id27;ClÈment;TOUIL;27-11-1999;clÈment.touil@hotmail.com;AB-;M;58,74 KG;Tunisie;Afrique;34;26.93∞C;1');
INSERT INTO CSVFile2 VALUES ('Id28;Jean;SPORTIF;27-11-1993;jean.sportif@hotmail.com;AB+;M;64,24 KG;France;;69;41.44 ∞c;12,94 m');
INSERT INTO CSVFile2 VALUES ('Id29;Alain;MIGNONNE;10-02-1965;alain.mignonne@ici.tn;B-;M;0;Tunisie;Afrique;10;;1');
INSERT INTO CSVFile2 VALUES ('Id30;MÈdecin;MOUSTAFA;19-08-1988;mÈdecin.moustafa@yahoo.fr;AB;M;64,54 KG;Maroc;Afrique;44;38.05∞C;20,97 m');
INSERT INTO CSVFile2 VALUES ('Id31;ClÈment;MOUSTAFA;27-11-1993;clÈment.moustafa@yahoo.fr;1;M;58,74 KG;France;;60;38.13∞C;20,97 m');
INSERT INTO CSVFile2 VALUES ('Id32;Mamadou;FORT;08-12-1982;mamadou.fort@gmail.com;A-;M;0;Maroc;Afrique;58;25;**');
INSERT INTO CSVFile2 VALUES ('Id33;Emna;FORT;19-ao˚t-1988;emna.fort@gmail.com;A+;F;65850,12 g;Maroc;Afrique;64,365;84.91∞F;$1');
INSERT INTO CSVFile2 VALUES ('Id34;Omar;PARIS;18-05-1960;omar.paris@gmail.com;AB-;M;64,63 KG;Malie;Afrique;73;26.93∞C;**');
INSERT INTO CSVFile2 VALUES ('Id35;Mamadou;CLEMENT;24-06-1995;mamadou.clement@hotmail.com;AB-;M;86,33 KG;Canada;AmÈrique;50;38.05∞C;12,95 m');
INSERT INTO CSVFile2 VALUES ('Id36;Mamadou;SOLEIL;24-06-1995;mamadou.soleil@gmail;A;0;64,24 KG;Espagne;;44;38.05∞C;2,39 m');
INSERT INTO CSVFile2 VALUES ('Id37;Ibrahim;BELLE;08-12-1982;ibrahim.belle@gmail;A-;M;64,63 KG;France;Europe;12;20.9∞C;12,94 m');
INSERT INTO CSVFile2 VALUES ('Id38;Ibrahim;PLUS BELLE;08-09-1960;ibrahim.plus belle@hotmail.com;B+;0;64,24 KG;France;;9;25.04∞C;0');
INSERT INTO CSVFile2 VALUES ('Id39;ClÈment;PRINTEMPS;27-11-1999;clÈment.printemps@gmail.com;O+;M;93,88 KG;AlgÈrie;Afrique;33;20.9∞C;2,39 m');
INSERT INTO CSVFile2 VALUES ('Id40;Claire;SPORTIF;24-juin-1995;claire.sportif@yahoo.fr;B+;F;72425,34 g;Tunisie;Afrique;121,929;119.05∞F;428,03 cm');
INSERT INTO CSVFile2 VALUES ('Id41;Eve;RAHMA;25-fÈvrier-1995;eve.rahma@gmail.com;X;F;63282,34 g;Portugal;Europe;56,813;102.42  ∞F;0');
INSERT INTO CSVFile2 VALUES ('Id42;ClÈmence;SPORTIF;30-avril-2000;clÈmence.sportif@yahoo.fr;B+;F;72425,34 g;Portugal;Europe;135,288;111.29∞F;77');
INSERT INTO CSVFile2 VALUES ('Id43;Jean;INFORME;17-08-1969;jean.informe@ici.tn;O-;Y;86,33 KG;SÈnÈgal;Afrique;71;;0');
INSERT INTO CSVFile2 VALUES ('Id44;Jean;SOLEIL;05-06-1993;jean.soleil@hotmail.com;2;M;1;Canada;AmÈrique;18;26.93∞C;20,97 m');
INSERT INTO CSVFile2 VALUES ('Id45;Ibrahim;TROPFOR;01-03-1967;ibrahim.tropfor@hotmail.com;A+;0;64,54 KG;Itale;;72;20.9∞C;10,96 m');
INSERT INTO CSVFile2 VALUES ('Id46;Faouzi;AIMANT;14-01-1978;faouzi.aimant@ici.tn;AB+;Y;0;Argentine;AmÈrique;12;25.32∞Celcius;2,39 m');
INSERT INTO CSVFile2 VALUES ('Id47;Fleurette;UNIQUE;03-janvier-1975;fleurette.unique@gmail.com;AB+;F;71214,11g;Chine;Asie;146,323;111.29∞F;644,34 cm');
INSERT INTO CSVFile2 VALUES ('Id48;Jean;CLEMENT;25-02-1995;jean.clement@hotmail.com;O+;M;0;AlgÈrie;Afrique;11;25.32∞Celcius;10,96 m');
INSERT INTO CSVFile2 VALUES ('Id49;Ibrahim;FORT;21-05-1969;ibrahim.fort@gmail.com;AB-;M;1;Malie;Afrique;33;25;10,96 m');
INSERT INTO CSVFile2 VALUES ('Id50;Sabrine;EXCELLE;14-fÈvrier-1966;sabrine.excelle@yahoo.fr;B-;F;44456,57 g;Portugal;Europe;64,008;91.1∞F;644,34 cm');

COMMIT;


/*
-- ===================================================
-- >>>>>>>>>>>>>>>> EXEMPLE 3 <<<<<<<<<<<<<<<<<<<<<<<<
-- ===================================================

-- >>>>>>>>>>>>>>>> CSVfile3

M. Adam SAITOUT;M;A+;Paris;France
Mme Eve LABELLE;F;B+;Paris;Franc
M. Adam TRAIFOR;M;A+;Paris;France
M. Gabriel ANGE;M;B+;Paris;
M. Ines ETINCELLE;F;B+;Paris;Fr
Mme Clemence JOLIE;F;B+;Pari;France
M. Clement LEGRAND;M;AB+;Londres;RU
M. Clement LEGRAND;M;AB+;London;United-Kingdom
M. Adam SAITOUT;M;A+;Paris;France
M. Adam BEN TRAIFOR ;M;A+;Paris;France
Mme Linda BEN SALEM;F;A+;Paris;

*/

CREATE TABLE CSVfile3 (Col VARCHAR2(1000));

INSERT INTO CSVFile3 VALUES ('M. Adam SAITOUT;M;A+;Paris;France');
INSERT INTO CSVFile3 VALUES ('Mme Eve LABELLE;F;B+;Paris;Franc');
INSERT INTO CSVFile3 VALUES ('M. Adam TRAIFOR;M;A+;Paris;France');
INSERT INTO CSVFile3 VALUES ('M. Gabriel ANGE;M;B+;Paris;');
INSERT INTO CSVFile3 VALUES ('M. Ines ETINCELLE;F;B+;Paris;Fr');
INSERT INTO CSVFile3 VALUES ('Mme Clemence JOLIE;F;B+;Pari;France');
INSERT INTO CSVFile3 VALUES ('M. Clement LEGRAND;M;AB+;Londres;RU');
INSERT INTO CSVFile3 VALUES ('M. Clement LEGRAND;M;AB+;London;United-Kingdom');
INSERT INTO CSVFile3 VALUES ('M. Adam SAITOUT;M;A+;Paris;France');
INSERT INTO CSVFile3 VALUES ('M. Clement LEGRAND;M;AB+;London;United-Kingdom');
INSERT INTO CSVFile3 VALUES ('M. Adam BEN TRAIFOR ;M;A+;Paris;France');
INSERT INTO CSVFile3 VALUES ('Mme Linda BEN SALEM;F;A+;Paris');

COMMIT;

/*
-- ===================================================
-- >>>>>>>>>>>>>>>> EXEMPLE 4 <<<<<<<<<<<<<<<<<<<<<<<<
-- ===================================================

-- >>>>>>>>>>>>>>>> CSVfile4

Mme;Anne MARTIN;M;12-05-1985;A+;a.martin@hotmail.fr;;PARIS;FRANCE;EUROPE
MME;ANNE MARTIN;M;12-05-1985;A+;A.MARTIN@HOTMAIL.FR;;PARIS;FRANCE;EUROPE
Mme;Karine LEBON;F;NULL;AB+;kl@@cnam.fr;;PARIS;FRANCE;EUROPE
M;Robert FORT;M;03-12-1990;O+;rl@yahoo.fr;;NICE;FRANCE;EUROPE
M;Robert DUPONT;M;12-04-1987;B-; nn.pn@yahoo.com;;P…êKIN;CHINE;ASIE
M;Simon GENEREUX;M;10-16-1996;NULL;sg@gmail.com;;LONDRES;ROYAUME-UNI;EUROPE
M;Simon GENEREUX@;M;16-october-1996;O-;;3313007085013;LONDON;UNITED-KINGDOM;EUROPE
Mme;Katia BON;F;26-november-1957;X;;3313007085022;BEIJING;CHINA;ASIA
M;Adem LE BON;M;05-june-2000;A+;;3313007085012;TUNIS;TUNISIA;AFRICA
M;Adem LE BON;M;05-june-2000;NULL;;3363007085012;TUNIS;TUNISIA;AFRICA
M;Robert LEBON;M;12-december-1980;B+;;3313007085052;PARIS;FRANCE;EUROPE


*/
CREATE TABLE CSVFILE4 (Col VARCHAR2(1000));

INSERT INTO CSVFILE4 VALUES ('Mme;Anne MARTIN;M;12-05-1985;A+;a.martin@hotmail.fr;;PARIS;FRANCE;EUROPE');
INSERT INTO CSVFILE4 VALUES ('MME;ANNE MARTIN;M;12-05-1985;A+;A.MARTIN@HOTMAIL.FR;;PARIS;FRANCE;EUROPE');
INSERT INTO CSVFILE4 VALUES ('Mme;Karine LEBON;F;NULL;AB+;kl@@cnam.fr;;PARIS;FRANCE;EUROPE');
INSERT INTO CSVFILE4 VALUES ('M;Robert FORT;M;03-12-1990;O+;rl@yahoo.fr;;NICE;FRANCE;EUROPE');
INSERT INTO CSVFILE4 VALUES ('M;Robert DUPONT;M;12-04-1987;B-; nn.pn@yahoo.com;;P…êKIN;CHINE;ASIE');
INSERT INTO CSVFILE4 VALUES ('M;Simon GENEREUX;M;10-16-1996;NULL;sg@gmail.com;;LONDRES;ROYAUME-UNI;EUROPE');
INSERT INTO CSVFILE4 VALUES ('M;Simon GENEREUX@;M;16-october-1996;O-;;3313007085013;LONDON;UNITED-KINGDOM;EUROPE');
INSERT INTO CSVFILE4 VALUES ('Mme;Katia BON;F;26-november-1957;X;;3313007085022;BEIJING;CHINA;ASIA');
INSERT INTO CSVFILE4 VALUES ('M;Adem LE BON;M;05-june-2000;A+;;3313007085012;TUNIS;TUNISIA;AFRICA');
INSERT INTO CSVFILE4 VALUES ('M;Adem LE BON;M;05-june-2000;NULL;;3363007085012;TUNIS;TUNISIA;AFRICA');
INSERT INTO CSVFILE4 VALUES ('M;Robert LEBON;M;12-december-1980;B+;;3313007085052;PARIS;FRANCE;EUROPE');

COMMIT;



--==================================================================================================
CREATE TABLE DR_CSVFile_Col_i  -- Col_i le nom/numero de la colonne en question
(
REFERENCES VARCHAR2(100),--NomDuFichier CSV_ DateSystËme_ColiOLDVALUESVARCHAR2(1000),
SYNTACTICTYPE VARCHAR2(20),
SYNTACTICSUBTYPE VARCHAR2(20),
COLUMNWIDHT NUMBER(5),
NUMBEROFWORDS NUMBER(2),
OBSERVATION VARCHAR2(100),
NEWVALUES VARCHAR2(1000),
SEMANTICCATEGORY VARCHAR2(1000),
SEMANTICSUBCATEGORY VARCHAR2(1000)
);


-- Data Dictionnary for Regular Expressions for syntactic types
-- Creation of data structure
CREATE TABLE DDRE_SYNTACTICTYPES (SYNTACTICTYPE VARCHAR2(100), SYNTACTICSUBTYPE VARCHAR2(100), REGULAREXPRESSION VARCHAR2(1000));
-- Creation of regular expressions

INSERT INTO DDRE_SYNTACTICTYPES VALUES ('STRING', 'ALPHABETICUPPER', 'expr...');--Alphabetical letters in uppercase
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('STRING', 'ALPHABETICLOWER', 'expr...');--Alphabetical letters in lowercase.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('STRING', 'ALPHABETICUPPLOW', 'expr...');--Alphabetical letters in lower and upper case.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('STRING', 'ALPHANUMERICUPPER', 'expr...');--Alphanumeric characters in upper case.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('STRING', 'ALPHANUMERICLOWER', 'expr...');--Alphanumeric characters in lowercase.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('STRING', 'ALPHANUMERICSPECIALCHAR', 'expr...');--Alphanumeric characters (special).

INSERT INTO DDRE_SYNTACTICTYPES VALUES ('DATE', 'FRENCH', 'expr...');--French date.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('DATE', 'ENGLISH', 'expr...');--English date.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('TIME', 'TIMEH24', 'expr...');--Time format H24.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('TIME', 'TIMEH12', 'expr...');--Time format H12.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('DATETIME', 'DATETIMEH24', 'expr...');--French date-Time H24.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('DATETIME', 'DATETIMEH12', 'expr...');--English date-Time H12.

INSERT INTO DDRE_SYNTACTICTYPES VALUES ('NUMBER', 'INTEGER', 'expr...');--Integer Numbers.
INSERT INTO DDRE_SYNTACTICTYPES VALUES ('NUMBER', 'REAL', 'expr...');--Real Numbers.

-- Ci-dessous des exemples d'expressions rÈguliËres. Le reste est ‡ trouver par vos soins!

-- Date franÁaise : '^(([0-2][0-9]|3[0-1])/(0[0-9]|1[0-2])/[0-9]{4})$'
-- Date anglaise : 'DATEAM', '^((0[0-9]|1[0-2])/([0-2][0-9]|3[0-1])/[0-9]{4})$'
-- AlphabÈtique : 'ALPHABETIQUE', '^[[:alpha:] ]+$'                           ?? -- ^[A-Za-z]
-- NumÈrique : 'NUMERIQUE', '^[[:digit:]]+$'                                  ?? -- ^[0-9] et le + et le - ...
