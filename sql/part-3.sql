-- Q1
PROMPT Question 1:;
SELECT nom_med
FROM MED
WHERE type_med='antibiotique'
ORDER BY nom_med ASC;

-- Q2
PROMPT Question 2:;
SELECT distinct nom_med
FROM MED, ACHAT, FOURN
WHERE MED.id_med = ACHAT.id_med
AND FOURN.id_fourn = ACHAT.id_fourn
AND FOURN.nom_fourn = 'Alpha';

-- Q3
PROMPT Question 3:;
SELECT id_achat, nom_med, date_achat
FROM MED, ACHAT, FOURN
WHERE MED.id_med = ACHAT.id_med
AND FOURN.id_fourn = ACHAT.id_fourn
AND FOURN.nom_fourn = 'Beta'
ORDER BY date_achat ASC;

-- Q4
PROMPT Question 4:;
SELECT nom_med
FROM MED
WHERE MED.id_med
NOT IN (SELECT id_med
	FROM PRESC);

-- Q5
PROMPT Question 5:;
SELECT nom_med, sum(qte_p) as qte_prescrit
FROM MED, PRESC
WHERE MED.id_med = PRESC.id_med
GROUP BY nom_med;

-- Q6
PROMPT Question 6:;
SELECT nom1, qte_achetee, qte_prescrit
FROM (SELECT nom_med as nom1, sum(PRESC.qte_p) as qte_prescrit
	FROM MED, PRESC
	WHERE MED.id_med = PRESC.id_med
	GROUP BY nom_med),
     (SELECT nom_med as nom2, sum(ACHAT.qte_a) as qte_achetee
	FROM MED, ACHAT
	WHERE MED.id_med = ACHAT.id_med
	GROUP BY nom_med)
WHERE nom1 = nom2 AND qte_achetee < (qte_prescrit + 100);

