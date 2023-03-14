select * from customer;
-- [output]: 100 record
-- 1000 records each record with id, name, and address

-- Lets capture the time to fetch the data using explain analyze
explain analyze select * from customer;
-- [output]:
-- "Seq Scan on customer  (cost=0.00..41.00 rows=1000 width=211) (actual time=0.002..0.077 rows=1000 loops=1)"
-- "Planning Time: 0.013 ms"
-- "Execution Time: 0.107 ms"

-- Lets create indexes for the name and address
CREATE INDEX customer_name_idx ON customer (Name);
CREATE INDEX customer_address_idx ON customer (Address);

explain analyze select * from customer;
-- [output]:
-- "Seq Scan on customer  (cost=0.00..41.00 rows=1000 width=211) (actual time=0.001..0.067 rows=1000 loops=1)"
-- "Planning Time: 0.010 ms"
-- "Execution Time: 0.097 ms"