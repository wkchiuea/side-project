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

-- Assessment Test 1
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


