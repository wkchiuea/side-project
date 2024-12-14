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
SELECT
    s.surgery_id,
    p.full_name,
    s.total_profit,
    AVG(total_profit) OVER w as avg_total_profit,
    s.total_cost,
    SUM(total_cost) OVER w AS total_surgeon_cost
FROM surgical_encounters s
    LEFT JOIN physicians p ON s.surgeon_id = p.id
WINDOW w AS (PARTITION BY s.surgeon_id);



--
--
-- Section 4 : Advanced JOIN
--
--
-- Cross JOIN : Cartesian Product
SELECT
    h.hospital_name,
    d.department_name
FROM hospitals h
    CROSS JOIN departments d;

-- USING, Natural JOINS
SELECT h.hospital_name, d.department_name
    FROM departments d
    INNER JOIN hospitals h USING (hospital_id);
SELECT h.hospital_name, d.department_name
    FROM departments d
    NATURAL JOIN hospitals h;



--
--
-- Section 5 : Set Operation
--
--
-- UNION: remove duplicate, UNION ALL: keep
SELECT surgery_id
    FROM surgical_encounters
UNION
SELECT surgery_id
    FROM surgical_costs;

SELECT surgery_id
    FROM surgical_encounters
INTERSECT
SELECT surgery_id
    FROM surgical_costs;

SELECT surgery_id
    FROM surgical_encounters
EXCEPT
SELECT surgery_id
    FROM surgical_costs;



--
--
-- Section 6 : Grouping Sets
--
--
SELECT
    state,
    county,
    COUNT(*) AS num_patients
FROM patients
    GROUP BY GROUPING SETS (
        (state),
        (state, county),
        ()
    )
    ORDER BY state DESC, county;

-- CUBE: generate all possible subset
SELECT
    state,
    county,
    COUNT(*) AS num_patients
FROM patients
    GROUP BY CUBE (state, county)
    ORDER BY state DESC, county;

-- ROLLUP: ordered and hierarchical
SELECT
    state,
    county,
    COUNT(*) AS num_patients
FROM patients
    GROUP BY ROLLUP (state, county)
    ORDER BY state DESC, county;

