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

create table schools(
  schoolId INT PRIMARY KEY,
  schoolName VARCHAR(255) NOT NULL
);
create table teachers(
  teacherId INT PRIMARY KEY,
  firstName VARCHAR(255) NOT NULL,
  lastName VARCHAR(255) NOT NULL,
  schoolId INT REFERENCES schools(schoolId)
);
create table courses (
  courseId INT PRIMARY KEY,
  courseName VARCHAR(255) NOT NULL,
  teacherId INT REFERENCES teachers(teacherId),
  room VARCHAR(255),
  grade VARCHAR(255)
);
create table publisher(
  publisher_id INT PRIMARY KEY,
  publisherName VARCHAR(255) NOT NULL
);
create table books(
  bookId INT PRIMARY KEY,
  bookName VARCHAR(255) NOT NULL,
  publisher VARCHAR(255) REFERENCES publisher(publisher_id)
);
create table loan(
  id INT PRIMARY KEY,
  bookId INT REFERENCES books(bookId),
  date DATE,
  courseId INT REFERENCES courses(courseId)
);

-- SQL

INSERT INTO schools VALUES (1, 'Horizon Education Institute');
INSERT INTO schools VALUES (2, 'Bright Institution');

INSERT INTO teachers VALUES (1, 'Chad', 'Russell', 1);
INSERT INTO teachers VALUES (2, 'E.F.', 'Codd', 1);
INSERT INTO teachers VALUES (3, 'Jones', 'Smith', 1);
INSERT INTO teachers VALUES (4, 'Adam', 'Baker', 2);

INSERT INTO courses VALUES (1, 'Logical Thinking', 1, '1.A01', '1st grade');
INSERT INTO courses VALUES (2, 'Writing', 1, '1.A01', '1st grade');
INSERT INTO courses VALUES (3, 'Numerical thinking', 1, '1.A01', '1st grade');
INSERT INTO courses VALUES (4, 'Spatial, Temporal and Causal Thinking', 2, '1.B01', '1st grade');
INSERT INTO courses VALUES (5, 'Numerical thinking', 2, '1.B01', '1st grade');
INSERT INTO courses VALUES (6, 'Writing', 3, '1.A01', '2nd grade');
INSERT INTO courses VALUES (7, 'English', 3, '1.A01', '2nd grade');
INSERT INTO courses VALUES (8, 'Logical Thinking', 4, '2.B01', '1st grade');
INSERT INTO courses VALUES (9, 'Numerical Thinking', 4, '2.B01', '1st grade');

INSERT INTO books VALUES (1, 'Learning and teaching in early childhood education', 1);
INSERT INTO books VALUES (2, 'Preschool, N56', 1);
INSERT INTO books VALUES (3, 'Early Childhood Education N9', 2);
INSERT INTO books VALUES (4, 'Know how to educate: guide for Parents and Teachers', 3);
INSERT INTO books VALUES (5, 'Learning and teaching in early childhood education', 1);
INSERT INTO books VALUES (6, 'Know how to educate: guide for Parents and Teachers', 3);
INSERT INTO books VALUES (7, 'Logical Thinking', 1);
INSERT INTO books VALUES (8, 'Writing', 1);
INSERT INTO books VALUES (9, 'Numerical thinking', 1);

INSERT INTO publisher VALUES (1, 'BOA Editions');
INSERT INTO publisher VALUES (2, 'Taylor & Francis Publishing');
INSERT INTO publisher VALUES (3, 'Prentice Hall');
INSERT INTO publisher VALUES (4, 'McGraw Hill');

INSERT INTO loan VALUES (1, 7, '2010-09-09', 1);
INSERT INTO loan VALUES (2, 8, '2010-05-05', 2);
INSERT INTO loan VALUES (3, 9, '2010-05-05', 3);
INSERT INTO loan VALUES (4, 3, '2010-05-06', 5);
INSERT INTO loan VALUES (5, 9, '2010-05-06', 5);
INSERT INTO loan VALUES (6, 8, '2010-09-09', 6);
INSERT INTO loan VALUES (7, 4, '2010-05-05', 7);
INSERT INTO loan VALUES (8, 7, '2010-12-18', 8);
INSERT INTO loan VALUES (9, 9, '2010-05-06', 9);


-- SQL Queries

-- 1. For each publisher find the books, which have been loaned, and in which school it has been done


-- 2. For each school, find the publisher of the book and the book itself that has been on loan the smallest time