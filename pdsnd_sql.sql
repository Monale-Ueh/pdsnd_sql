pdsnd_sql
QUESTION SET #1
/* Query1 - rental count for each family-friendly 
category */
SELECT	f.title film_title,
	c.name AS category_name, 
	COUNT(rental_id)
FROM film f
	JOIN film_category fc
	ON f.film_id = fc.film_id
	JOIN category c
	ON c.category_id = fc.category_id
	JOIN inventory i
	ON f.film_id = i.film_id
	JOIN rental r
	ON r.inventory_id = i.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1, 2
ORDER BY 2, 1;


/* Query 2 - maximum rental duration for movies in 
family-friendly categories */
SELECT	name, MAX(rental_duration) AS max_duration
FROM	(SELECT	title, name, rental_duration, 
		NTILE(4) OVER (ORDER BY rental_duration) AS standard_percentile
	FROM film f
		JOIN film_category
		USING (film_id)
		JOIN category c
		USING (category_id)
	WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))sub
GROUP BY 1;


/* Query 3 - count of movies within each combination 
of film category for each corresponding rental 
duration category */
SELECT	name, standard_percentile, COUNT(rental_duration) AS max_duration
FROM	(SELECT	title, name, rental_duration, 
		NTILE(4) OVER (ORDER BY rental_duration) AS standard_percentile
	FROM film f
		JOIN film_category
		USING (film_id)
		JOIN category c
		USING (category_id)
	WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))sub
GROUP BY 1, 2
ORDER BY 1, 2;

/*Query 4 - how the two stores compare in their count of 
rental orders during every month for all the years */
SELECT rental_month, 
	rental_year, 
	store_id, 
	COUNT(inventory_id) AS count_rental
FROM	(SELECT DATE_PART('month', rental_date) AS rental_month, 
		DATE_PART('year', rental_date) AS rental_year, 
		se.store_id, r.inventory_id
	FROM store se
		JOIN staff sf
		ON se.store_id = sf.store_id
		JOIN rental r
		ON r.staff_id = sf.staff_id) sub
GROUP BY 1, 2, 3
ORDER BY 4 DESC