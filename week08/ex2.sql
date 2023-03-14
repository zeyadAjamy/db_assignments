-- The list of movies that have not been rented yet by the clients, whose rating is R or PG-13 and its category is Horror or Sci-fi
SELECT film.title, film.rating, category.name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE film.film_id NOT IN (
  SELECT inventory.film_id
  FROM rental
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
)
AND (film.rating = 'R' OR film.rating = 'PG-13')
AND (category.name = 'Horror' OR category.name = 'Sci-Fi');
-- [output]:
-- "Commandments Express"	"R"			"Horror"
-- "Crowds Telemark"		"R"			"Sci-Fi"
-- "Treasure Command"		"PG-13"		"Horror"

-- The list of the stores that have made a greater number of sales in terms of money during the last month recorded.
SELECT c.city, s.store_id, SUM(p.amount) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
WHERE DATE_TRUNC('month', p.payment_date) = '2007-05-01'
GROUP BY c.city, s.store_id
ORDER BY c.city, total_sales DESC;
-- [output:]
-- city             store    total_sales 
-- "Lethbridge"	    1	     243.10
-- "Woodridge"   	2	     271.08


-- Lets use explain 
EXPLAIN SELECT film.title, film.rating, category.name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE film.film_id NOT IN (
  SELECT inventory.film_id
  FROM rental
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
)
AND (film.rating = 'R' OR film.rating = 'PG-13')
AND (category.name = 'Horror' OR category.name = 'Sci-Fi');

--[Output]:
-- "Hash Join  (cost=542.92..615.36 rows=23 width=87)"
-- "Hash Cond: (film.film_id = film_category.film_id)"
-- "  ->  Seq Scan on film  (cost=520.78..592.28 rows=187 width=23)"
-- "        Filter: ((NOT (hashed SubPlan 1)) AND ((rating = 'R'::mpaa_rating) OR (rating = 'PG-13'::mpaa_rating)))"
-- "        SubPlan 1"
-- "          ->  Hash Join  (cost=128.07..480.67 rows=16044 width=2)"
-- "                Hash Cond: (rental.inventory_id = inventory.inventory_id)"
-- "                ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=4)"
-- "                ->  Hash  (cost=70.81..70.81 rows=4581 width=6)"
-- "                      ->  Seq Scan on inventory  (cost=0.00..70.81 rows=4581 width=6)"
-- "  ->  Hash  (cost=20.58..20.58 rows=125 width=70)"
-- "        ->  Hash Join  (cost=1.26..20.58 rows=125 width=70)"
-- "              Hash Cond: (film_category.category_id = category.category_id)"
-- "              ->  Seq Scan on film_category  (cost=0.00..16.00 rows=1000 width=4)"
-- "              ->  Hash  (cost=1.24..1.24 rows=2 width=72)"
-- "                    ->  Seq Scan on category  (cost=0.00..1.24 rows=2 width=72)"
-- "                          Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Sci-Fi'::text))"

-- Lets use explain 
EXPLAIN SELECT c.city, s.store_id, SUM(p.amount) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
WHERE DATE_TRUNC('month', p.payment_date) = '2007-05-01'
GROUP BY c.city, s.store_id
ORDER BY c.city, total_sales DESC;

--[Output]:
-- "Sort  (cost=798.07..798.25 rows=73 width=45)"
-- "  Sort Key: c.city, (sum(p.amount)) DESC"
-- "  ->  GroupAggregate  (cost=794.17..795.81 rows=73 width=45)"
-- "        Group Key: c.city, s.store_id"
-- "        ->  Sort  (cost=794.17..794.35 rows=73 width=19)"
-- "              Sort Key: c.city, s.store_id"
-- "              ->  Nested Loop  (cost=1.89..791.91 rows=73 width=19)"
-- "                    Join Filter: (i.store_id = s.store_id)"
-- "                    ->  Nested Loop  (cost=0.57..771.65 rows=73 width=8)"
-- "                          ->  Nested Loop  (cost=0.29..749.02 rows=73 width=10)"
-- "                                ->  Seq Scan on payment p  (cost=0.00..326.94 rows=73 width=10)"
-- "                                      Filter: (date_trunc('month'::text, payment_date) = '2007-05-01 00:00:00'::timestamp without time zone)"
-- "                                ->  Index Scan using rental_pkey on rental r  (cost=0.29..5.78 rows=1 width=8)"
-- "                                      Index Cond: (rental_id = p.rental_id)"
-- "                          ->  Index Scan using inventory_pkey on inventory i  (cost=0.28..0.31 rows=1 width=6)"
-- "                                Index Cond: (inventory_id = r.inventory_id)"
-- "                    ->  Materialize  (cost=1.32..18.07 rows=2 width=13)"
-- "                          ->  Nested Loop  (cost=1.32..18.06 rows=2 width=13)"
-- "                                ->  Hash Join  (cost=1.04..17.36 rows=2 width=6)"
-- "                                      Hash Cond: (a.address_id = s.address_id)"
-- "                                      ->  Seq Scan on address a  (cost=0.00..14.03 rows=603 width=6)"
-- "                                      ->  Hash  (cost=1.02..1.02 rows=2 width=6)"
-- "                                            ->  Seq Scan on store s  (cost=0.00..1.02 rows=2 width=6)"
-- "                                ->  Index Scan using city_pkey on city c  (cost=0.28..0.35 rows=1 width=13)"
-- "                                      Index Cond: (city_id = a.city_id)"

CREATE INDEX idx_film_rating ON film(rating);
CREATE INDEX idx_film_category ON film_category(film_id, category_id);
CREATE INDEX idx_inventory_film_id ON inventory(film_id);
CREATE INDEX idx_rental_inventory_id ON rental(inventory_id);
CREATE INDEX idx_category_name ON category(name);


