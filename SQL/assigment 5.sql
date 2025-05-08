########################## Assignment 5: Sakila SQL Queries ##############################
# Name: Jiayu Zhao 
# Date: 20250507


### 1. List customer’s first and last name where last names are not repeated
SELECT first_name, last_name
FROM sakila.customer
WHERE last_name IN (
    SELECT last_name
    FROM sakila.customer
    GROUP BY last_name
    HAVING COUNT(*) = 1
)
ORDER BY last_name, first_name;


### 2. List each film and the number of actors who are listed for that film
SELECT f.title AS film, COUNT(fa.actor_id) AS actor_count
FROM sakila.film AS f
JOIN sakila.film_actor AS fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;


### 3. List top 5 name of actors by most appearance in the films
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor, COUNT(fa.film_id) AS appearance_count
FROM sakila.actor AS a
JOIN sakila.film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY appearance_count DESC, actor
LIMIT 5;


### 4. List the top 10 customer first and last name and total paid amount by each customer.
#### Note: Combine first name last name together with alias customer.
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer, SUM(p.amount) AS total_paid
FROM sakila.customer AS c
JOIN sakila.payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_paid DESC, customer
LIMIT 10;


### 5. List top 10 cities which generated the most revenue. Order by city name.
SELECT ci.city, SUM(p.amount) AS total_revenue
FROM sakila.payment AS p
JOIN sakila.customer AS c ON p.customer_id = c.customer_id
JOIN sakila.address AS a ON c.address_id = a.address_id
JOIN sakila.city AS ci ON a.city_id = ci.city_id
GROUP BY ci.city_id, ci.city
ORDER BY total_revenue DESC, ci.city
LIMIT 10;