-- EX1
-- The function that retrieves all addresses contains the number 11 and city_id between 400 and 600

CREATE OR REPLACE FUNCTION get_addresses()
RETURNS TABLE (
  address_id INT,
  address VARCHAR,
  city_id SMALLINT
) AS $$
BEGIN
  RETURN QUERY SELECT address.address_id, address.address, address.city_id
  FROM address
  WHERE address.address LIKE '%11%'
  AND address.city_id BETWEEN 400 AND 600;
END;
$$ LANGUAGE plpgsql;

select latitude, longitude
from address
where longitude is not null
and latitude is not null;

