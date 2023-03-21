-- EX2
-- Query to get the customers ordered by cutomer_id

CREATE OR REPLACE FUNCTION retrieveCustomers(startTime INT, endTime INT) RETURNS TABLE (
  customer_id INT,
  first_name VARCHAR(45),
  last_name VARCHAR(45),
  email VARCHAR(50),
  address_id SMALLINT
) AS $$
BEGIN
  IF startTime < 0 OR endTime > 600 OR startTime > endTime THEN
    RAISE EXCEPTION 'Invalid start or end parameters';
  END IF;

  RETURN QUERY SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id
               FROM customer
               ORDER BY customer.address_id
               LIMIT endTime - startTime + 1
               OFFSET startTime - 1;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM retrieveCustomers(10, 40);