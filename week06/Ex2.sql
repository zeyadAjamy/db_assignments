-- Tables
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
  publisher INT REFERENCES publisher(publisher_id)
);
create table loan(
  id INT PRIMARY KEY,
  bookId INT REFERENCES books(bookId),
  date DATE,
  courseId INT REFERENCES courses(courseId)
);

-- Insert data into the Order table
INSERT INTO schools
VALUES (1, 'Horizon Education Institute');
INSERT INTO schools
VALUES (2, 'Bright Institution');
INSERT INTO teachers
VALUES (1, 'Chad', 'Russell', 1);
INSERT INTO teachers
VALUES (2, 'E.F.', 'Codd', 1);
INSERT INTO teachers
VALUES (3, 'Jones', 'Smith', 1);
INSERT INTO teachers
VALUES (4, 'Adam', 'Baker', 2);
INSERT INTO courses
VALUES (1, 'Logical Thinking', 1, '1.A01', '1st grade');
INSERT INTO courses
VALUES (2, 'Writing', 1, '1.A01', '1st grade');
INSERT INTO courses
VALUES (
    3,
    'Numerical Thinking ',
    1,
    '1.A01',
    '1st grade'
  );
INSERT INTO courses
VALUES (
    4,
    'Spatial, Temporal and Causal Thinking',
    2,
    '1.B01',
    '1st grade'
  );
INSERT INTO courses
VALUES (5, 'Numerical Thinking', 3, '1.B01', '1st grade');
INSERT INTO courses
VALUES (6, 'Writing', 3, '1.A01', '2nd grade');
INSERT INTO courses
VALUES (7, 'English', 3, '1.A01', '2nd grade');
INSERT INTO courses
VALUES (8, 'Logical Thinking', 4, '2.B01', '1st grade');
INSERT INTO courses
VALUES (
    9,
    'Numerical Thinking ',
    4,
    '2.B01',
    '1st grade'
  );
INSERT INTO publisher
VALUES (1, 'BOA Editions');
INSERT INTO publisher
VALUES (2, 'Taylor & Francis Publishing');
INSERT INTO publisher
VALUES (3, 'Prentice Hall');
INSERT INTO publisher
VALUES (4, 'McGraw Hill ');
INSERT INTO books
VALUES (
    1,
    'Learning and teaching in early childhood education',
    1
  );
INSERT INTO books
VALUES (2, 'Preschool N56', 2);
INSERT INTO books
VALUES (3, 'Early Childhood Education N9', 3);
INSERT INTO books
VALUES (
    4,
    'Know how to educate: guide for Parents and Teachers',
    4
  );
INSERT INTO loan
VALUES (1, 1, '2010-09-09', 1);
INSERT INTO loan
VALUES (2, 2, '2010-05-05', 2);
INSERT INTO loan
VALUES (3, 1, '2010-05-05', 3);
INSERT INTO loan
VALUES (4, 3, '2010-05-06', 4);
INSERT INTO loan
VALUES (5, 1, '2010-05-06', 5);
INSERT INTO loan
VALUES (6, 1, '2010-09-09', 6);
INSERT INTO loan
VALUES (7, 4, '2010-05-05', 7);
INSERT INTO loan
VALUES (8, 4, '2010-12-18', 8);
INSERT INTO loan
VALUES (9, 1, '2010-05-06', 9);

-- Grant permission to user
grant all privileges on table schools to zeyad;
grant all privileges on table teachers to zeyad;
grant all privileges on table courses to zeyad;
grant all privileges on table books to zeyad;
grant all privileges on table publisher to zeyad;
grant all privileges on table loan to zeyad;
-- SQL Queries
--------------
-- 1. For each publisher find the books, which have been loaned, and in which school it has been done
-----------------------------------------------------------------------------------------------------
-- way 1
SELECT b.bookName,
  s.schoolName
FROM loan l
  JOIN books b ON l.bookId = b.bookId
  JOIN courses c ON l.courseId = c.courseId
  JOIN teachers t ON c.teacherId = t.teacherId
  JOIN schools s ON t.schoolId = s.schoolId
GROUP BY b.bookName,
  s.schoolName;
-- way 2
select schoolName,
  bookName
from schools
  natural join (
    select bookName,
      schoolId
    from teachers
      natural join (
        select bookName,
          teacherId
        from (
            select courseId,
              bookName
            from loan,
              books
            where loan.bookId = books.bookId
          ) as loan_cources
          natural join courses
      ) as teacher_book
  ) as book_school
group by bookName,
  schoolName;

-- 2. For each school, find the publisher of the book and the book itself that has been on loan the smallest time
-----------------------------------------------------------------------------------------------------------------
create view school_books_numbered as
SELECT s.schoolName, b.bookName, MIN(n.date) AS min_loan_date,
	 ROW_NUMBER() OVER (PARTITION BY s.schoolId ORDER BY MIN(n.date)) AS row_num
FROM loan n
JOIN books b ON n.bookId = b.bookId
JOIN courses c ON c.courseId = n.courseId
JOIN teachers t ON c.teacherId = t.teacherId
JOIN schools s ON t.schoolId = s.schoolId
GROUP BY s.schoolName, b.bookName, s.schoolId;

select schoolname, bookname, min_loan_date from school_books_numbered where row_num = 1;