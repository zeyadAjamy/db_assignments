-- #1
SELECT title
FROM course
WHERE dept_name = 'Comp. Sci.'
    AND credits = 3;
-- #2
SELECT course.course_id,
    course.title
FROM student
    JOIN takes ON student.ID = takes.ID
    JOIN course ON takes.course_id = course.course_id
WHERE student.ID = '12345';
-- #3
SELECT SUM(course.credits)
FROM student
    JOIN takes ON student.ID = takes.ID
    JOIN course ON takes.course_id = course.course_id
WHERE student.ID = '12345';
-- #4
SELECT student.ID,
    SUM(course.credits)
FROM student
    JOIN takes ON student.ID = takes.ID
    JOIN course ON takes.course_id = course.course_id
GROUP BY student.ID;
-- #5
SELECT DISTINCT student.name
FROM student
    JOIN takes ON student.ID = takes.ID
    JOIN course ON takes.course_id = course.course_id
WHERE course.dept_name = 'Comp. Sci.';
-- #6
SELECT instructor.ID
FROM instructor
    LEFT JOIN teaches ON instructor.ID = teaches.ID
WHERE teaches.ID IS NULL;
-- #7
SELECT instructor.ID,
    instructor.name
FROM instructor
    LEFT JOIN teaches ON instructor.ID = teaches.ID
WHERE teaches.ID IS NULL;