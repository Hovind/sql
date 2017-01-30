-- Requêtes

-- Q1
SELECT nom_med FROM MED  WHERE type_med='antibiotique' ORDER BY nom_med ASC;

-- Q2
SELECT distinct nom_med FROM MED, ACHAT, FOURN WHERE MED.id_med = ACHAT.id_med AND FOURN.id_fourn = ACHAT.id_fourn AND FOURN.nom_fourn = 'Alpha';

-- Q3
SELECT id_achat, nom_med, date_achat  FROM MED, ACHAT, FOURN WHERE MED.id_med = ACHAT.id_med AND FOURN.id_fourn = ACHAT.id_fourn AND FOURN.nom_fourn = 'Beta' ORDER BY date_achat ASC;

-- Q4
SELECT nom_med FROM MED WHERE MED.id_med NOT IN (SELECT id_med FROM PRESC);

-- Q5
SELECT nom_med, sum(qte_p) as qte_prescrit FROM MED, PRESC WHERE MED.id_med = PRESC.id_med GROUP BY nom_med; 

-- Q6 
SELECT nom_med, qte_achetee, qte_prescrit FROM (SELECT nom_med, sum(PRESC.qte_p) as qte_prescrit, sum(ACHAT.qte_a) as qte_achetee FROM MED, PRESC, ACHAT WHERE MED.id_med = PRESC.id_med AND MED.id_med = ACHAT.id_med GROUP BY nom_med) WHERE qte_achetee < (qte_prescrit + 100);
