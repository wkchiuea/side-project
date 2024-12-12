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


