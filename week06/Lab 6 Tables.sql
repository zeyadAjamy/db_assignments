-- EX: 1
CREATE TABLE Orders (
  orderId INT PRIMARY KEY,
  customerId INT,
  date DATE,
  FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);
CREATE TABLE OrderItem (
  orderId INT,
  itemId INT,
  quantity INT,
  PRIMARY KEY (orderId, itemId),
  FOREIGN KEY (orderId) REFERENCES Orders(orderId),
  FOREIGN KEY (itemId) REFERENCES Item(itemId)
);
CREATE TABLE Item (
  itemId INT PRIMARY KEY,
  itemName VARCHAR(255),
  price DECIMAL(10, 2)
);
CREATE TABLE Customer (
  customerId INT PRIMARY KEY,
  customerName VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL
);

-- Insert data into the Order table
INSERT INTO Orders (orderId, customerId, date)
VALUES (2301, 101, '2011-02-23'),
  (2302, 107, '2011-02-25'),
  (2303, 110, '2011-02-27');
INSERT INTO Item (itemId, itemName, price)
VALUES (3786, 'Net', 35.00),
  (4011, 'Racket', 65.00),
  (9132, 'Pack-3', 4.75),
  (5794, 'Pack-6', 5.00),
  (3141, 'Cover', 10.00);
INSERT INTO OrderItem (orderId, itemId, quantity)
VALUES (2301, 3786, 3),
  (2301, 4011, 6),
  (2301, 9132, 8),
  (2302, 5794, 4),
  (2303, 4011, 2),
  (2303, 3141, 2);
INSERT INTO Customer (customerId, customerName, city)
VALUES (101, 'Martin', 'Prague'),
  (107, 'Herman', 'Madrid'),
  (110, 'Pedro', 'Moscow');

-- Grant permission to user
grant all privileges on table Orders to zeyad;
grant all privileges on table Item to zeyad;
grant all privileges on table OrderItem to zeyad;
grant all privileges on table Customer to zeyad;


-- SQLS Queries
-- 1. Calculate the total amount to pay for the cheapest order:
SELECT count(quantity * price) as total_amount
from OrderItem
  join Item ON OrderItem.itemId = Item.itemId;
-- 2. Obtain the customer name and city who purchased more items than the others

-- way: 1
select customername,
  city
from OrderItem,
  orders,
  customer
where OrderItem.orderId = orders.orderId
  and orders.customerid = customer.customerid
group by customername,
  city
order by sum(quantity) desc
limit 1;

--way: 2
select customername, city
from (
  select customerid
  from (
      (
        select orderId,
          sum(quantity) as total
        from OrderItem
        group by orderId
        order by total desc
        limit 1
      ) as highest_quantity
      natural join orders
    )
) as rich_customer natural join customer;



-- Exercise 2
CREATE TABLE loan_books (
  school VARCHAR(50),
  teacher VARCHAR(30),
  course VARCHAR(40),
  room VARCHAR(10),
  grade VARCHAR(15),
  book VARCHAR(60),
  publisher VARCHAR(30),
  loanDate DATE,
  PRIMARY KEY (? ? ?)
);
INSERT INTO loan_books
VALUES (
    'Horizon Education Institute',
    'Chad Russell',
    'Logical Thinking',
    '1.A01',
    '1st grade',
    'Learning and teaching in early childhood education',
    'BOA Editions',
    '2010-09-09'
  );
INSERT INTO loan_books
VALUES (
    'Horizon Education Institute',
    'Chad Russell',
    'Writing',
    '1.A01',
    '1st grade',
    'Preschool, N56',
    'Taylor & Francis Publishing',
    '2010-05-05'
  );
INSERT INTO loan_books
VALUES (
    'Horizon Education Institute',
    'Chad Russell',
    'Numerical thinking',
    '1.A01',
    '1st grade',
    'Learning and teaching in early childhood education',
    'BOA Editions',
    2010 -05 -05
  );
INSERT INTO loan_books
VALUES (
    'Horizon Education Institute',
    'E.F.Codd',
    'Spatial, Temporal and Causal Thinking',
    '1.B01',
    '1st grade',
    'Early Childhood Education N9',
    'Prentice Hall',
    '2010-05-06'
  );
INSERT INTO loan_books
VALUES (
    'Horizon Education Institute',
    'E.F.Codd',
    'Numerical thinking',
    '1.B01',
    '1st grade',
    'Learning and teaching in early childhood education',
    'BOA Editions',
    '2010-05-06'
  );
INSERT INTO loan_books
VALUES (
    'Horizon Education Institute',
    'Jones Smith',
    'Writing',
    '1.A01',
    '2nd grade',
    'Learning and teaching in early childhood education',
    'BOA Editions',
    '2010-09-09'
  );
INSERT INTO loan_books
VALUES (
    'Horizon Education Institute',
    'Jones Smith',
    'English',
    '1.A01',
    '2nd grade',
    'Know how to educate: guide for Parents and Teachers',
    'McGraw Hill',
    '2010-05-05'
  );
INSERT INTO loan_books
VALUES (
    'Bright Institution',
    'Adam Baker',
    'Logical Thinking',
    '2.B01',
    '1st grade',
    'Know how to educate: guide for Parents and Teachers',
    'McGraw Hill',
    '2010-12-18'
  );
INSERT INTO loan_books
VALUES (
    'Bright Institution',
    'Adam Baker',
    'Numerical Thinking',
    '2.B01',
    '1st grade',
    'Learning and teaching in early childhood education',
    'BOA Editions',
    '2010-05-06'
  );