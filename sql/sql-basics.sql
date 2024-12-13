--
--
-- Section 2 : SQL Statement Fundamentals
--
--
SELECT first_name, last_name, email FROM customer;
SELECT DISTINCT rating FROM film;
SELECT COUNT(DISTINCT(rating)) FROM film;

SELECT email FROM customer
    WHERE first_name = 'Nancy' AND last_name = 'Thomas';
SELECT * FROM payment
    WHERE amount != 0.0
    ORDER BY payment_date DESC, payment_id ASC
    LIMIT 10;
SELECT * FROM payment
    WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15';
SELECT * FROM payment
    WHERE amount NOT BETWEEN 8 AND 9;

SELECT * FROM payment
    WHERE amount IN (0.99, 1.98);
SELECT * FROM customer
    WHERE first_name LIKE '_her%';
SELECT * FROM customer
    WHERE first_name ILIKE '___her';

-- Challenge
SELECT COUNT(0) FROM payment WHERE amount > 5;
SELECT COUNT(0) FROM actor WHERE first_name LIKE 'P%';
SELECT COUNT(DISTINCT district) FROM address;
SELECT DISTINCT district FROM address;
SELECT COUNT(0) FROM film WHERE rating = 'R' AND replacement_cost BETWEEN 5 AND 15;
SELECT COUNT(0) FROM film WHERE title LIKE '%Truman%';



--
--
-- Section 3 : Group By
--
--
SELECT MIN(replacement_cost),
       MAX(replacement_cost),
       ROUND(AVG(replacement_cost), 2),
       SUM(replacement_cost),
       COUNT(*)
    FROM film;

SELECT customer_id, SUM(amount) FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount);
SELECT staff_id, customer_id, SUM(amount) FROM payment
    GROUP BY staff_id, customer_id
    HAVING SUM(amount) > 100;
SELECT DATE(payment_date) FROM payment;

-- Challenge
SELECT staff_id, COUNT(*) FROM payment
    GROUP BY staff_id;
SELECT rating, AVG(replacement_cost) FROM film
    GROUP BY rating;
SELECT customer_id, SUM(amount) FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 5;



--
--
-- Section 4 : Assessment Test 1
--
--
SELECT customer_id, SUM(amount) FROM payment
    WHERE staff_id = 2
    GROUP BY customer_id
    HAVING SUM(amount) >= 110;
SELECT COUNT(0) FROM film
    WHERE title LIKE 'J%';
SELECT * FROM customer
    WHERE first_name LIKE 'E%' AND address_id < 500
    ORDER BY customer_id DESC
    LIMIT 1;



--
--
-- Section 5 : JOINS
--
--
SELECT customer_id, SUM(amount) AS total_spent FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) > 100;

SELECT * FROM payment
    INNER JOIN customer ON payment.customer_id = customer.customer_id;
SELECT * FROM payment
    FULL OUTER JOIN customer ON payment.customer_id = customer.customer_id
    WHERE customer.customer_id IS null OR payment.payment_id IS null;

SELECT film.film_id, film.title, inventory.inventory_id FROM film
    LEFT JOIN inventory ON inventory.film_id = film.film_id;
SELECT film.film_id, film.title, inventory.inventory_id FROM film
    LEFT JOIN inventory ON inventory.film_id = film.film_id
    WHERE inventory.film_id IS null;
SELECT film.film_id, film.title, inventory.inventory_id FROM film
    RIGHT JOIN inventory ON inventory.film_id = film.film_id;

-- Challenge
SELECT first_name, last_name, district, email FROM customer
    INNER JOIN address ON address.address_id = customer.address_id
    WHERE district = 'California';
SELECT title, first_name, last_name FROM actor
    INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
    INNER JOIN film ON film.film_id = film_actor.film_id
    WHERE first_name = 'Nick' AND last_name = 'Wahlberg';


SELECT * FROM address;
SELECT * FROM customer;
SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM film_actor;



--
--
-- Section 6 : Advanced SQL
--
--
SHOW ALL;

-- Time
SHOW TIMEZONE;
SELECT NOW();
SELECT TIMEOFDAY();
SELECT CURRENT_TIME;
SELECT CURRENT_DATE;

SELECT EXTRACT(YEAR FROM payment_date) AS myyear FROM payment; -- MONTH, QUARTER
SELECT AGE(payment_date) FROM payment;
SELECT TO_CHAR(payment_date, 'MONTH-YYYY') FROM payment; -- https://www.postgresql.org/docs/12/functions-formatting.html

-- Time Challenge
SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')) FROM payment;
SELECT COUNT(0) FROM payment WHERE TO_CHAR(payment_date, 'D') = '2';
SELECT COUNT(0) FROM payment WHERE EXTRACT(dow FROM payment_date) = 1;

-- Math
SELECT rental_rate/replacement_cost FROM film;

-- String
SELECT LENGTH(first_name), upper(first_name) || ' ' || last_name AS full_name FROM customer;
SELECT LOWER(LEFT(first_name, 1) || last_name) || '@gmail.com' FROM customer;

-- SubQuery
SELECT title, rental_rate FROM film
    WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

SELECT film_id, title FROM film
    WHERE film_id IN (
        SELECT inventory.film_id FROM rental
            INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
            WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30'
);

SELECT first_name, last_name FROM customer AS c
    WHERE EXISTS (SELECT * FROM payment as p WHERE p.customer_id = c.customer_id AND amount > 11)
    ORDER BY c.customer_id;
SELECT first_name, last_name FROM customer
    INNER JOIN payment ON payment.customer_id = customer.customer_id
    WHERE amount > 11
    ORDER BY customer.customer_id;

-- Self Join
SELECT f1.title, f2.title, f1.length FROM film AS f1
    INNER JOIN film AS f2 ON f1.film_id != f2.film_id AND f1.length = f2.length;



--
--
-- Section 7 : Assessment Test 2
--
--
\c exercises;
SET search_path TO cd;

SELECT * FROM facilities;
SELECT name, membercost FROM facilities;
SELECT * FROM facilities WHERE membercost > 0;
SELECT facid, name, membercost, monthlymaintenance FROM facilities
    WHERE membercost > 0 AND membercost < monthlymaintenance / 50;
SELECT * FROM facilities WHERE name LIKE '%Tennis%';
SELECT * FROM facilities WHERE facid IN (1, 5);

SELECT * FROM members;
SELECT * FROM members WHERE joindate >= '2012-09-01';
SELECT DISTINCT surname FROM members ORDER BY surname LIMIT 10;
SELECT MAX(joindate) FROM members;
SELECT COUNT(0) FROM facilities WHERE guestcost >= 10;

SELECT * FROM bookings;
SELECT facid, SUM(slots) FROM bookings
    WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
    GROUP BY facid
    ORDER BY SUM(slots);
SELECT facid, SUM(slots) FROM bookings
    GROUP BY facid
    HAVING SUM(slots) > 1000
    ORDER BY facid;
SELECT bookings.starttime, facilities.name FROM bookings
    INNER JOIN facilities ON facilities.facid = bookings.facid
    WHERE name ILIKE '%tennis court%' AND starttime::date='2012-09-21'
    ORDER BY starttime;

SELECT starttime FROM members
    INNER JOIN bookings ON bookings.memid = members.memid
    WHERE firstname || ' ' || surname = 'David Farrell';



--
--
-- Section 8 : Create DB and tables
--
--
CREATE DATABASE learning;

CREATE TABLE account (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(250) UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP
);

CREATE TABLE job (
    job_id SERIAL PRIMARY KEY,
    job_name VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE account_job(
    user_id INTEGER REFERENCES account(user_id),
    job_id INTEGER REFERENCES job(job_id),
    hire_date TIMESTAMP
);

-- INSERT INTO tableA(xx, yy) SELECT col1, col2 FROM tableB WHERE condition;
INSERT INTO account(username, password, email, created_on)
    VALUES ('Haha', 'password', 'haha@gmail.com', CURRENT_TIMESTAMP);
SELECT * FROM account;

INSERT INTO job(job_name)
    VALUES ('Astronaut'), ('President');
SELECT * FROM job;

INSERT INTO account_job(user_id, job_id, hire_date)
    VALUES (1, 1, CURRENT_TIMESTAMP);
SELECT * FROM account_job;

-- UPDATE tableA SET original_col = tableB.new_col
--      FROM tableB WHERE tableA.id = tableB.id;
UPDATE account
    SET last_login = created_on
    WHERE user_id = 1
    RETURNING user_id, last_login;
UPDATE account_job
    SET hire_date = account.created_on
    FROM account
    WHERE account_job.user_id = account.user_id;

DELETE FROM job
    WHERE job_name = 'Cowboy';
-- DELETE FROM job
--     USING tableB
--     WHERE job.job_id = tableB.id

ALTER TABLE job
    RENAME TO new_info; -- RENAME COLUMN person TO perople
ALTER TABLE job
    ADD COLUMN new_col INT;
ALTER TABLE job
    DROP COLUMN new_col;
ALTER TABLE job
    ALTER COLUMN job_name SET DEFAULT 'HAHA'; -- SET NOT NULL, DROP DEFAULT, ADD CONSTRAINT constraint_name

-- DROP will not remove those from views, triggers, stored procedures -> use CASCADE
ALTER TABLE account
    DROP COLUMN IF EXISTS email;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    birthday DATE CHECK(birthday > '1900-01-01'),
    hiredate DATE CHECK(hiredate > employees.birthday)
);




