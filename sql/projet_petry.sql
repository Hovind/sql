/*création de la base*/

DROP TABLE PRESC;
DROP TABLE ACHAT;
DROP TABLE MED;
DROP TABLE FOURN;

CREATE TABLE MED(
id_med number(5) Constraint PK_MED PRIMARY KEY,
type_med char(20),
nom_med char(20));

CREATE TABLE FOURN(
id_fourn number(5) Constraint PK_FOURN PRIMARY KEY,
nom_fourn char(30));

CREATE TABLE PRESC(
id_presc number(5) Constraint PK_PRESC PRIMARY KEY,
qte_p number(5),
id_med number(5) Constraint PRESC_REF_MED REFERENCES MED);

CREATE TABLE ACHAT(
id_achat number(5) Constraint PK_ACHAT PRIMARY KEY,
qte_a number(5),
id_med number(5) Constraint ACHAT_REF_MED REFERENCES MED,
id_fourn number(5) Constraint ACHAT_REF_FOURN REFERENCES FOURN,
date_achat date);

/*insértion des données*/

INSERT INTO MED VALUES(1,'antibiotique','peniciline');
INSERT INTO MED VALUES(2,'antibiotique','amoxiciline');
INSERT INTO MED VALUES(3,'antibiotique','cefalexine');
INSERT INTO MED VALUES(4,'antibiotique','ampiciline');
INSERT INTO MED VALUES(5,'analgesiques','paracetamol');
INSERT INTO MED VALUES(6,'analgesiques','aspirine');
INSERT INTO MED VALUES(7,'analgesiques','ibuprofene');

INSERT INTO FOURN VALUES(1,'Alpha');
INSERT INTO FOURN VALUES(2,'Beta');

INSERT INTO ACHAT VALUES(1, 100, 1, 1, '14-APR-16');
INSERT INTO ACHAT VALUES(2, 200, 1, 1, '20-MAY-16'); 
INSERT INTO ACHAT VALUES(3, 150, 5, 2, '10-JAN-17'); 
INSERT INTO ACHAT VALUES(4, 300, 2, 2, '15-JUL-15'); 
INSERT INTO ACHAT VALUES(5, 200, 4, 2, '27-SEP-16'); 
INSERT INTO ACHAT VALUES(6, 150, 7, 1, '04-DEC-15'); 

INSERT INTO PRESC VALUES(1, 50, 1);
INSERT INTO PRESC VALUES(2, 60, 5);
INSERT INTO PRESC VALUES(3, 100, 2);
INSERT INTO PRESC VALUES(4, 50, 4);
INSERT INTO PRESC VALUES(5, 20, 7);
INSERT INTO PRESC VALUES(6, 50, 1);

/*Requêtes*/ 

SELECT nom_med FROM MED  WHERE type_med='antibiotique' ORDER BY nom_med ASC;

SELECT distinct nom_med FROM MED, ACHAT, FOURN WHERE MED.id_med = ACHAT.id_med AND FOURN.id_fourn = ACHAT.id_fourn AND FOURN.nom_fourn = 'Alpha';

SELECT id_achat, nom_med, date_achat  FROM MED, ACHAT, FOURN WHERE MED.id_med = ACHAT.id_med AND FOURN.id_fourn = ACHAT.id_fourn AND FOURN.nom_fourn = 'Beta' ORDER BY date_achat ASC;

SELECT nom_med FROM MED WHERE MED.id_med NOT IN (SELECT id_med FROM PRESC);

SELECT nom_med, sum(qte_p) as qte_presc FROM MED, PRESC WHERE MED.id_med = PRESC.id_med GROUP BY nom_med; 

CREATE TABLE SUM_A (nom_med char(20), qte_achat number);
INSERT INTO SUM_A SELECT nom_med, sum(qte_p) FROM MED, PRESC WHERE MED.id_med = PRESC.id_med GROUP BY nom_med;

CREATE TABLE SUM_A (nom_med char(20), qte_achat number);
INSERT INTO SUM_A SELECT nom_med, sum(qte_p) FROM MED, PRESC WHERE MED.id_med = PRESC.id_med GROUP BY nom_med;


/
