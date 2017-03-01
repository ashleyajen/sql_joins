-- Which customer placed the orders on the earliest date? What did they order?
SELECT
  r.rental_date,
  f.title
FROM
  inventory i_1 JOIN rentals r ON i_1.inventory_id = r.inventory_id,
  inventory i_2 JOIN films f ON i_2.film_id = f.film_id
ORDER BY
  rental_date ASC
  LIMIT 1;

-- Which product do we have the most of? Find the order ids and customer names for all orders for that item.
WITH most_product AS
  (SELECT
    film_id,
    count(inventory.film_id) AS inventory_count
  FROM
    inventory
  GROUP BY
    film_id
  ORDER BY
    inventory_count DESC
    LIMIT 1)

SELECT
  customers.first_name,
  films.title
FROM
 customers JOIN
 rentals USING (customer_id) JOIN
 inventory USING (inventory_id) JOIN
 films USING (film_id) JOIN
 most_product USING (film_id)
GROUP BY
  film_id,
  first_name;
-- What orders have there been from Texas? In June?

SELECT
  rentals.rental_id,
  adresses.district,
  rentals.rental_date
FROM
  adresses JOIN
  customers USING (address_id) JOIN
  rentals USING (customer_id) JOIN
  payments USING (rental_id)
WHERE
  district = 'Texas'
  AND
  to_char(rental_date, 'MM')  = '06';

-- How many orders have we had for sci-fi films? From Texas?
SELECT
  count(rentals.rental_id) AS rental_count,
  category.name,
  adresses.district
FROM
  category JOIN
  film_categories USING (category_id) JOIN
  inventory USING (film_id) JOIN
  rentals USING (inventory_id) JOIN
  customers USING (customer_id) JOIN
  adresses USING (address_id)
WHERE
  name = 'Sci-Fi'
  AND
  district = 'Texas'
GROUP BY
  category.name,
  adresses.district;
