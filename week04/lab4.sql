CREATE TABLE University (
    name varchar(255) PRIMARY KEY,
    location varchar(255)
);

CREATE TABLE Student (
    id int PRIMARY KEY,
    university_name varchar(255),
    name varchar(255),
    native_language varchar(255),
    FOREIGN KEY (university_name) REFERENCES University(name)
);

CREATE TABLE Course (
    name varchar(255) PRIMARY KEY,
    credits int,
    university_name varchar(255),
    FOREIGN KEY (university_name) REFERENCES University(name)
);

CREATE TABLE Enrollment (
    std_id int,
    course_name varchar(255),
    FOREIGN KEY (std_id) REFERENCES Student(id),
    FOREIGN KEY (course_name) REFERENCES Course(name)
);


INSERT INTO University VALUES ("Innopolis University", "Russia");
INSERT INTO University VALUES ("MIPT", "russia");
INSERT INTO University VALUES ("IIT", "India");
INSERT INTO University VALUES ("BUET", "Bangladesh");
INSERT INTO University VALUES ("KFU", "Russia");
INSERT INTO University VALUES ("Cairo University", "Egypt");


INSERT INTO Student (name, native_language, university_name) VALUES ("Rafeed", "Bangla", "Innopolis University");
INSERT INTO Student (name, native_language, university_name) VALUES ("Zeyad", "Arabic", "Innopolis University");
INSERT INTO Student (name, native_language, university_name) VALUES ("Ahmed", "Arabic", "MIPT");
INSERT INTO Student (name, native_language, university_name) VALUES ("Arman", "Bangla", "BUET");
INSERT INTO Student (name, native_language, university_name) VALUES ("Leonid", "Russian", "Innopolis University");
INSERT INTO Student (name, native_language, university_name) VALUES ("Tanmay", "Hindi", "IIT");
INSERT INTO Student (name, native_language, university_name) VALUES ("Ivan", "Russian", "BUET");
INSERT INTO Student (name, native_language, university_name) VALUES ("Ivan", "Russian", "Cairo University");
INSERT INTO Student (name, native_language, university_name) VALUES ("Drake", "English", "IIT");

INSERT INTO Course VALUES("Computer Science", 7, "Innopolis Univeristy");
INSERT INTO Course VALUES("Psychology", 3, "MIPT");
INSERT INTO Course VALUES("Anthropology", 6, "Cairo University");
INSERT INTO Course VALUES("Physics", 6, "BUET");
INSERT INTO Course VALUES("English", 2, "IIT");

-- point a
SELECT name FROM University WHERE location = 'Russia';

-- point b
SELECT DISTINCT location FROM University 
WHERE location <> 'Russia' 
AND name IN (
    SELECT university_name FROM Student 
    WHERE native_language = 'Russian'
);

-- point c

SELECT id FROM Student WHERE university_name = 'Innopolis University';

-- point d

SELECT Course.name, University.name 
FROM Course 
JOIN University ON Course.university_name = University.name 
WHERE Course.credits > 5;


-- point e

SELECT name FROM University 
WHERE name IN (
    SELECT university_name FROM Student 
    WHERE native_language = 'English'
);



