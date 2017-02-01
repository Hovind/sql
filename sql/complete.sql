-- création de la base

DROP TABLE PRESC;
DROP TABLE ACHAT;
DROP TABLE MED;
DROP TABLE FOURN;
DROP TABLE LOGINS;

CREATE TABLE MED (
	id_med number(5) Constraint PK_MED PRIMARY KEY,
	type_med char(20) Constraint TYPE_MED_N_NULL NOT NULL,
	nom_med char(20) Constraint NOM_MED_N_NULL NOT NULL
);

CREATE TABLE FOURN (
	id_fourn number(5) Constraint PK_FOURN PRIMARY KEY,
	nom_fourn char(30) Constraint NOM_FOURN_N_NULL NOT NULL
);

CREATE TABLE PRESC (
	id_presc number(5) Constraint PK_PRESC PRIMARY KEY,
	qte_p number(5) Constraint QTE_P_N_NULL NOT NULL,
	id_med number(5) Constraint PRESC_REF_MED REFERENCES MED
);

CREATE TABLE ACHAT (
	id_achat number(5) Constraint PK_ACHAT PRIMARY KEY,
	qte_a number(5) Constraint QTE_A_N_NULL NOT NULL,
	id_med number(5) Constraint ACHAT_REF_MED REFERENCES MED,
	id_fourn number(5) Constraint ACHAT_REF_FOURN REFERENCES FOURN,
	date_achat date
);

CREATE TABLE LOGINS (
	login char(50) Constraint LOGIN_N_NULL NOT NULL,
	password char(50) Constraint PW_N_NULL NOT NULL
);

-- insértion des données

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
INSERT INTO PRESC VALUES(7, 60, 5);

INSERT INTO LOGINS VALUES('gabriel', 'petry');
INSERT INTO LOGINS VALUES('oystein', 'hovind');
INSERT INTO LOGINS VALUES('admin', 'admin');

commit;

-- Requêtes

-- Q1
PROMPT Question 1:;
SELECT nom_med FROM MED  WHERE type_med='antibiotique' ORDER BY nom_med ASC;

-- Q2
PROMPT Question 2:;
SELECT distinct nom_med FROM MED, ACHAT, FOURN WHERE MED.id_med = ACHAT.id_med AND FOURN.id_fourn = ACHAT.id_fourn AND FOURN.nom_fourn = 'Alpha';

-- Q3
PROMPT Question 3:;
SELECT id_achat, nom_med, date_achat  FROM MED, ACHAT, FOURN WHERE MED.id_med = ACHAT.id_med AND FOURN.id_fourn = ACHAT.id_fourn AND FOURN.nom_fourn = 'Beta' ORDER BY date_achat ASC;

-- Q4
PROMPT Question 4:;
SELECT nom_med FROM MED WHERE MED.id_med NOT IN (SELECT id_med FROM PRESC);

-- Q5
PROMPT Question 5:;
SELECT nom_med, sum(qte_p) as qte_prescrit FROM MED, PRESC WHERE MED.id_med = PRESC.id_med GROUP BY nom_med; 

-- Q6 
PROMPT Question 6:;
SELECT nom1, qte_achetee, qte_prescrit FROM (SELECT nom_med as nom1, sum(PRESC.qte_p) as qte_prescrit FROM MED, PRESC WHERE MED.id_med = PRESC.id_med GROUP BY nom_med), (SELECT nom_med as nom2, sum(ACHAT.qte_a) as qte_achetee FROM MED, ACHAT WHERE MED.id_med = ACHAT.id_med GROUP BY nom_med)  WHERE nom1 = nom2 AND qte_achetee < (qte_prescrit + 100);
