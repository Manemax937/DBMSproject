-- ===============================
-- QUERIES
-- ===============================

-- JOINS ACCORDING TO THE ER DIAGRAM 

-- 1. Student ---> Membership

USE ieee_student_branch_db;

SELECT
	S.FullName,
    M.MembershipNumber,
    M.MembershipType,
    M.Status
FROM Student AS S
JOIN Membership AS M
	ON S.StudentID = M.StudentID;
    
-- FacultyCoordinator + Chapter 	

SELECT
	F.FacultyName,
    C.ChapterName,
    C.Domain
FROM FacultyCoordinator AS F
JOIN Chapter AS C
	ON F.FacultyID = C.FacultyID;
    
-- Chapter + Event

SELECT
	C.ChapterName,
    C.Domain,
    E.EventTitle,
    E.EventType,
    E.Venue
FROM Chapter AS C
JOIN Event AS E
	ON C.ChapterID = E.ChapterID;
    
-- Student  + Registration + Event

SELECT 
	S.FullName,
	E.EventTitle,
    R.RegistrationDate,
    R.AttendanceStatus
FROM Student AS S
JOIN Registration AS R
	ON S.StudentID = R.StudentID
JOIN Event AS E
	ON R.EventID = E.EventID;
    
    
-- Student + Feedback  + Event

SELECT 
	S.FullName,
    E.EventTitle,
    F.Rating,
    F.Comments
FROM Student AS S
JOIN Feedback AS F
	ON S.StudentID = F.StudentID
JOIN Event AS E
	ON F.EventID = E.EventID;
    
    
    
-- Student + Registration + Event + Chapter

SELECT
	S.FullName,
    E.EventTitle,
    C.ChapterName,
	R.AttendanceStatus
FROM Student AS S
JOIN  Registration AS R
	ON S.StudentID = R.StudentID
JOIN Event AS E
	ON R.EventID = E.EventID
JOIN Chapter as C
	ON C.ChapterID = E.ChapterID;

-- LEFT JOIN

SELECT
    S.StudentID,
    S.FullName,
    M.MembershipNumber,
    M.Status
FROM Student AS S
LEFT JOIN Membership AS M
    ON S.StudentID = M.StudentID;
    
-- Right Join with chapter

SELECT
    F.FacultyName,
    C.ChapterName,
    C.Domain
FROM FacultyCoordinator AS F
RIGHT JOIN Chapter AS C
    ON F.FacultyID = C.FacultyID;
    
    
-- self join 

SELECT
    F1.FacultyName AS Faculty1,
    F2.FacultyName AS Faculty2,
    F1.Department
FROM FacultyCoordinator AS F1
JOIN FacultyCoordinator AS F2
    ON F1.Department = F2.Department
    AND F1.FacultyID < F2.FacultyID;
    
-- Group by and having queries

SELECT
    E.EventID,
    E.EventTitle,
    COUNT(R.RegistrationID) AS TotalRegistrations
FROM Event AS E
JOIN Registration AS R
    ON E.EventID = R.EventID
GROUP BY
    E.EventID,
    E.EventTitle;
    
SELECT
    E.EventID,
    E.EventTitle,
    COUNT(R.RegistrationID) AS TotalRegistrations
FROM Event AS E
JOIN Registration AS R
    ON E.EventID = R.EventID
GROUP BY
    E.EventID,
    E.EventTitle
HAVING COUNT(R.RegistrationID) > 8;

SELECT
    E.EventID,
    E.EventTitle,
    COUNT(R.RegistrationID) AS PresentStudents
FROM Event AS E
JOIN Registration AS R
    ON E.EventID = R.EventID
WHERE R.AttendanceStatus = 'Present'
GROUP BY
    E.EventID,
    E.EventTitle
HAVING COUNT(R.RegistrationID) >= 7;

-- Correlated Subquery — Students with an above-average rating

SELECT 
	S.StudentID,
    S.FullName
FROM Student AS S
WHERE (
	SELECT AVG(F1.Rating)
    FROM Feedback AS F1
    WHERE F1.StudentID = S.StudentID
) > (
	SELECT AVG(F2.Rating)
    FROM Feedback AS F2
);


