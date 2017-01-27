Drop TABLE PRESC;
Drop TABLE ACHAT;
Drop TABLE MED;
Drop TABLE FOURN;

CREATE TABLE FOURN(
  fourn_id number(5) Constraint PK_FOURN PRIMARY KEY, 
  nom char(20));

CREATE TABLE MED(
  med_id number(5) Constraint PK_MED PRIMARY KEY,
  nom char(20));

CREATE TABLE PRESC(
  presc_id number(5) Constraint PK_PRESC PRIMARY KEY, 
  med_id number(5) Constraint PRESC_REF_MED REFERENCES MED,
  quant number(5));

CREATE TABLE ACHAT(
  achat_id number(5) Constraint PK_ACHAT PRIMARY KEY, 
  med_id number(5) Constraint ACHAT_REF_MED REFERENCES MED,
  fourn_id number(5) Constraint ACHAT_REF_FOURN REFERENCES FOURN,
  quant number(5));
 
