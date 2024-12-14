--
--
-- Section 2 : Subqueries and Common Table Expression CTEs
--
--
-- Subqueries
SELECT * FROM (
    SELECT * FROM patients
        WHERE date_of_birth >= '2000-01-01'
        ORDER BY master_patient_id
    ) p
WHERE p.name ILIKE 'm%';

SELECT se.* FROM (
    SELECT * FROM surgical_encounters
        WHERE surgical_admission_date BETWEEN '2016-11-01' AND '2016-11-30'
    ) se
INNER JOIN (
    SELECT master_patient_id FROM patients
        WHERE date_of_birth >= '1990-01-01'
    ) p ON se.master_patient_id = p.master_patient_id;

-- CTEs
WITH young_patients AS (
    SELECT * FROM patients
             WHERE date_of_birth >= '2000-01-01'
)
SELECT * FROM young_patients
    WHERE name ILIKE 'm%';

-- IN, NOT IN
SELECT * FROM patients
    WHERE master_patient_id IN (
        SELECT DISTINCT master_patient_id FROM surgical_encounters
        )
    ORDER BY master_patient_id;

-- ANY, ALL
SELECT * FROM surgical_encounters
    WHERE total_profit > ALL(
        SELECT avg(total_cost) FROM surgical_encounters
                               GROUP BY diagnosis_description
        );

-- EXISTS
SELECT e.* FROM encounters e
    WHERE EXISTS(SELECT 1 FROM orders_procedures o WHERE e.patient_encounter_id = o.patient_encounter_id);

-- Recursive CTEs
WITH RECURSIVE fibonacci AS (
    SELECT 1 AS a, 1 AS b
    UNION ALL
    SELECT b, a+b
    FROM fibonacci
)
SELECT a, b FROM fibonacci LIMIT 10;



--
--
-- Section 3 : Window Functions
--
--