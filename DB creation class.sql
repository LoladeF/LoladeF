/*STEPS
    1) Create DB if required
    2) Import Flat File (Install SQL Server Import extension)
    3) Create tables from most Independent to dependent: Except StudentSubject table
    4) Check Uniqueness of Data from dbo.SchoolFlatDb Table and update where required
    5) Insert values into tables from most independent to dependent: Intro to Joins
    6) Create StudentSubject table using INSERT INTO
    7) Lets Recreate the original table by Joining Class, Student, Subject and StudentSubjects tables
    8) Lets Create a View (vw_DchoolFlatDB) to hold our query so we can DROP the SchoolFlatDB Table
    9) Lets INSERT a new Class with No students in it to show the different types of Joins (LEFT/RIGHT and INNER JOINS)
    10) Lets say the school aquired another school with a similar Db and you area sked to merge the records (UNION, UNION ALL, INTERSECT, EXCEPT)
   
*/

--1)
SELECT * FROM sys.databases
---or
SELECT NAME FROM sys.databases WHERE name = 'SchoolFlatDB03'
---or
IF NOT EXISTS(SELECT NAME FROM sys.databases WHERE name = 'SchoolFlatDB03')
CREATE DATABASE SchoolFlatDB03

--2
SELECT *
FROM SchoolFlatDB

--3 ColumnName Datatype Constraint
CREATE TABLE Class(
    ClassId INT PRIMARY KEY IDENTITY(10,1),
    ClassName NVARCHAR(250) NOT NULL
    )

SELECT * FROM Class


CREATE TABLE Subject(
    SubjectID INT PRIMARY KEY IDENTITY(100,1), 
    SubjectName NVARCHAR(250) NOT NULL
    )

SELECT * FROM Subject

CREATE TABLE Student(
    StudentId INT PRIMARY KEY IDENTITY (1,1), 
    StudentName NVARCHAR(250) NOT NULL, 
ClassID INT FOREIGN KEY REFERENCES Class(ClassID) ON DELETE SET NULL
)

SELECT * FROM Student

--4)
---View our source table
SELECT * FROM SchoolFlatDB

---STUDENT
SELECT DISTINCT STUDENT 
FROM SchoolFlatDB

---SUBJECT
SELECT DISTINCT Subject 
FROM SchoolFlatDB

--Intro to update statements
UPDATE SchoolFlatDB
SET Subject = 'maths'
WHERE Subject LIKE 'math%'

---CLASS
SELECT DISTINCT Class
FROM SchoolFlatDB

---5)
--Class Insert
INSERT INTO CLASS(CLASSNAME)
SELECT DISTINCT Class
FROM SchoolFlatDB
---Verify
SELECT * FROM Class

--Subject Insert
INSERT INTO SUBJECT(SUBJECTNAME)
SELECT DISTINCT Subject 
FROM SchoolFlatDB
---Verify
SELECT * FROM SUBJECT

---Student Insert

INSERT INTO Student(StudentName, ClassID)

---Before Join
SELECT Distinct Student, Class
FROM SchoolFlatDB

SELECT ClassId, ClassName
FROM Class

---simple join
SELECT Distinct Student, Class, classid, classname
FROM SchoolFlatDB,Class
Where classname = class

--SELECT ClassID, ClassName
---FROM Class

---- another cool join
SELECT DISTINCT Student, Class,ClassId, ClassName
FROM SchoolFlatDB
JOIN Class
ON SchoolFlatDB.Class = Class.ClassName

---- even coller when you use aliases
SELECT DISTINCT s.Student, s.Class, c.ClassId, c.ClassName
FROM SchoolFlatDB s
JOIN Class c
ON s.Class = c.ClassName


---- finally we insert
INSERT INTO Student(StudentName, ClassId)
SELECT DISTINCT Student, ClassId
FROM SchoolFlatDB,Class
WHERE ClassName = class

SELECT * FROM Student

--6)
-- generate a select for studentSubject
SELECT * From SchoolFlatDB
SELECT * FROM Subject
SELECT * FROM Student

SELECT s.StudentId, j.SubjectId, d.Grade
--INTO StudentSubject
FROm SchoolFlatDB d
JOIN Student s ON d.Student = s.StudentName
JOIN Subject j ON d.Subject = j.SubjectName
---- or
SELECT StudentId, SubjectId, Grade
--INTO StudentSubject
FROm SchoolFlatDB
JOIN Student ON SchoolFlatDB.Student = Student.StudentName
JOIN Subject ON SchoolFlatDb.Subject = [Subject].SubjectName

----verify
SELECT * FROM SchoolflatDB

--8)

SELECT * FROM Student
SELECT * FROM Class
SELECT * FROM Subject
SELECT * FROM StudentSubject
--
SELECT * FROM SchoolflatDB
--
--CREATE VIEW vw_SchoolFlatDB AS
SELECT StudentName AS Student, ClassName AS Class, SubjectName AS Subject, Grade
FROM StudentSubject ss
JOIN Student st ON ss.StudentId = st.studentId
JOIN Subject su ON ss.SubjectId = su.SubjectId
JOIN Class cl ON st.ClassId = cl.ClassId

SELECT * FROM vw_SchoolFlatDB

--9)

-- Insert from external values
INSERT INTO Class(ClassName)
VALUES('5C')

SELECT * FROM Class
SELECT * FROM Student

---- Inner Join: return only what you can find in both tables
SELECT *
FROM Class c
INNER JOIN Student s
ON c.ClassId = s.ClassId

---- Left outer Join: return all on the left/first table even when there is no relation on the right
SELECT *
FROM Class c
LEFT OUTER JOIN Student s
ON c.ClassId = s.ClassId
WHERE StudentId IS NULL

--10)
SELECT * FROM Class
SELECT * FROM ClassNew
-- UPDATE ClassNew SET Classname = '5E' WHERE ClassId = 10
---- UNION: Merges rows taking out duplicates
SELECT ClassName FROM Class
UNION
SELECT Classname FROM ClassNew

---- UNION ALL: Merges rows including duplicates
SELECT ClassName FROM Class
UNION ALL
SELECT Classname FROM ClassNew

---- INTERSECT: Merges rows taking taking only values found in both tables/Columns
SELECT ClassName FROM Class
INTERSECT
SELECT Classname FROM ClassNew

---- EXCEPT: Merges rows taking found only in the top tables
SELECT ClassName FROM Class
EXCEPT
SELECT Classname FROM ClassNew

