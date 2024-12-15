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



--
--
-- Section 7 : Schema Structures and Table Relationships
--
--
-- Information Schema
SELECT * FROM information_schema.tables WHERE table_schema = 'general_hospital';

-- COMMENT
COMMENT ON TABLE general_hospital.vitals IS 'Patient Vital sign data';
COMMENT ON COLUMN general_hospital.vitals.bmi IS 'BMI';
SELECT COL_DESCRIPTION('general_hospital.accounts'::regclass, 1);



--
--
-- Section 8 : Transactions
--
--
BEGIN TRANSACTION;
UPDATE physicians
    SET first_name = 'Bill',
        full_name = CONCAT(last_name, ', Bill')
    WHERE id = 1;
-- ROLLBACK;
END TRANSACTION; -- or COMMIT TRANSACTION


BEGIN TRANSACTION;
UPDATE vitals
    SET bp_diastolic = 120
    WHERE patient_encounter_id = 2570046;
SAVEPOINT vitals_updated;

UPDATE accounts
    SET total_account_balance = 1000
    WHERE account_id = 111111;
ROLLBACK TO vitals_updated;
RELEASE SAVEPOINT vitals_updated;
COMMIT TRANSACTION;

-- Database Lock
BEGIN;
LOCK TABLE physicians;

END;



--
--
-- Section 9 : Table Inheritance and Partitioning
--
--
-- Range Partitioning
CREATE TABLE surgical_encounters_partitioned (
    surgery_id INTEGER NOT NULL,
    master_patient_id INTEGER NOT NULL,
    surgical_admission_date DATE NOT NULL,
    surgical_discharge_date DATE
) PARTITION BY RANGE(surgical_admission_date);
CREATE TABLE surgical_encounters_y2016
    PARTITION OF surgical_encounters_partitioned
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');
CREATE TABLE surgical_encounters_y2017
    PARTITION OF surgical_encounters_partitioned
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');
CREATE TABLE surgical_encounters_default
    PARTITION OF surgical_encounters_partitioned
    DEFAULT;

-- List Partitioning
CREATE TABLE departments_partitioned (
    hospital_id INTEGER NOT NULL,
    department_id INTEGER NOT NULL,
    department_name TEXT,
    specialty_description TEXT
) PARTITION BY LIST(hospital_id);
CREATE TABLE departments_h111000
    PARTITION OF departments_partitioned
    FOR VALUES IN (111000);
CREATE TABLE departments_h112000
    PARTITION OF departments_partitioned
    FOR VALUES IN (112000);
CREATE TABLE departments_default
    PARTITION OF departments_partitioned
    DEFAULT;

-- Hash Partitioning
CREATE TABLE orders_procedures_partitioned (
    order_procedure_id INT NOT NULL,
    patient_encounter_id INT NOT NULL,
    ordering_provider_id INT REFERENCES physicians(id),
    order_cd TEXT,
    order_procedure_description TEXT
) PARTITION BY HASH(order_procedure_id, patient_encounter_id);
CREATE TABLE orders_procedure_hash0
    PARTITION OF orders_procedures_partitioned
    FOR VALUES WITH (MODULUS 3, REMAINDER 0);
CREATE TABLE orders_procedure_hash1
    PARTITION OF orders_procedures_partitioned
    FOR VALUES WITH (MODULUS 3, REMAINDER 1);
CREATE TABLE orders_procedure_hash2
    PARTITION OF orders_procedures_partitioned
    FOR VALUES WITH (MODULUS 3, REMAINDER 2);

-- Table Inheritance
CREATE TABLE visit (
    id SERIAL NOT NULL PRIMARY KEY,
    start_datetime TIMESTAMP,
    end_datetime TIMESTAMP
);
CREATE TABLE emergency_visit (
    emergency_department_id INT NOT NULL,
    triage_level INT,
    triage_datetime TIMESTAMP
) INHERITS (visit);

INSERT INTO emergency_visit VALUES
    (DEFAULT, '2022-01-01 12:00:00', NULL, 12, 3, NULL);
INSERT INTO visit VALUES
    (DEFAULT, '2022-03-01 12:00:00', NULL);
SELECT * FROM ONLY visit;



--
--
-- Section 10 : Views
--
--
CREATE OR REPLACE VIEW v_monthly_surgery_stats AS
    SELECT
        TO_CHAR(surgical_admission_date, 'YYYY-MM') AS year_month,
        COUNT(surgery_id) AS num_surgeries,
        SUM(total_cost) AS total_cost
    FROM surgical_encounters
    GROUP BY 1
    ORDER BY 1;

-- updatable view
CREATE VIEW v_encounters_department_22100005 AS
    SELECT
        patient_encounter_id,
        admitting_provider_id,
        department_id,
        patient_in_icu_flag
    FROM encounters
    WHERE department_id = '22100005';
    --WITH CHECK OPTION;

-- Materialized View
CREATE MATERIALIZED VIEW v_monthly_surgery_stats AS
    SELECT
        TO_CHAR(surgical_admission_date, 'YYYY-MM') AS year_month,
        COUNT(surgery_id) AS num_surgeries,
        SUM(total_cost) AS total_cost
    FROM surgical_encounters
    GROUP BY 1
    ORDER BY 1
    WITH NO DATA;

REFRESH MATERIALIZED VIEW CONCURRENTLY v_monthly_surgery_stats;

-- Recursive View
CREATE RECURSIVE VIEW v_fibonacci(a, b) AS
    SELECT 1 AS a, 1 AS b
    UNION ALL
    SELECT b, a+b
    FROM v_fibonacci
    WHERE b < 200;



--
--
-- Section 11 : Functions
--
--
CREATE FUNCTION f_test_function(a INT, b INT)
    RETURNS INT
    LANGUAGE sql
    AS
    'SELECT $1 + $2;';
SELECT f_test_function(1, 2);

CREATE FUNCTION f_plpgsql_function(a INT, b INT)
    RETURNS INT
    AS
    $$
    BEGIN
        RETURN a + b;
    END;
    $$
    LANGUAGE plpgsql;
SELECT f_plpgsql_function(a=>1, b=>2);

SELECT * FROM information_schema.routines WHERE routine_schema = 'general_hospital';



--
--
-- Section 12 : Stored Procedures
--
--
CREATE PROCEDURE sp_test_procedure()
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DROP TABLE IF EXISTS general_hospital.test_table;
        CREATE TABLE general_hospital.test_table (
            id INT
        );
        COMMIT;
    END
    $$;
CALL sp_test_procedure();
SELECT * FROM information_schema.routines WHERE routine_schema = 'general_hospital' AND routine_type = 'PROCEDURE';
SELECT routine_definition FROM information_schema.routines WHERE routine_schema = 'general_hospital' AND routine_type = 'PROCEDURE';



--
--
-- Section 13 : Trigger
--
--
-- kicked off by other operations - INSERT, UPDATE, DELETE, TRUNCATE
CREATE FUNCTION f_trigger_function()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.last_name IS NULL OR NEW.first_name IS NULL THEN
            RAISE EXCEPTION 'Name cannot be null';
        ELSE
            NEW.first_name = TRIM(NEW.first_name);
            NEW.last_name = TRIM(NEW.last_name);
            return NEW;
        END IF;
    END;
    $$;

CREATE TRIGGER tr_clean_physician_name
    BEFORE INSERT
    ON physicians
    FOR EACH ROW
        EXECUTE PROCEDURE f_trigger_function();
ALTER TABLE physicians
    DISABLE TRIGGER tr_clean_physician_name;
ALTER TABLE physicians
    ENABLE TRIGGER ALL;



--
--
-- Section 14 : Useful Methods
--
--
-- EXPLAIN / EXPLAIN ANALYZE
EXPLAIN ANALYZE
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

-- TRUNCATE
BEGIN;
TRUNCATE test_table;
ROLLBACK;
END;

-- EXPORT, IMPORT Data
COPY physicians TO '/tmp/physicians.csv'
    WITH DELIMITER ',' CSV HEADER;
COPY test_table FROM '/tmp/physicians.csv'
    WITH DELIMITER ',' CSV HEADER;