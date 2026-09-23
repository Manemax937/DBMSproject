USE IEEE_Student_Branch_DB;

-- ============================================================
-- QUERY OPTIMIZATION AND INDEXING
-- ============================================================


EXPLAIN
SELECT
    E.EventID,
    E.EventTitle,
    COUNT(R.RegistrationID) AS PresentStudents
FROM Event AS E
JOIN Registration AS R
    ON E.EventID = R.EventID
WHERE R.AttendanceStatus = 'Present'
GROUP BY E.EventID, E.EventTitle
HAVING COUNT(R.RegistrationID) >= 7;


-- INDEX FOR QUERY 1

CREATE INDEX idx_registration_event_attendance
ON Registration(EventID, AttendanceStatus);

EXPLAIN
SELECT
    E.EventID,
    E.EventTitle,
    COUNT(R.RegistrationID) AS PresentStudents
FROM Event AS E
JOIN Registration AS R
    ON E.EventID = R.EventID
WHERE R.AttendanceStatus = 'Present'
GROUP BY E.EventID, E.EventTitle
HAVING COUNT(R.RegistrationID) >= 7;

-- ============================================================
-- QUERY 1: BEFORE vs AFTER INDEX
-- ============================================================
-- BEFORE:
-- Registration used a full table scan (type = ALL)
-- and no index was selected (key = NULL).
--
-- AFTER:
-- MySQL selected idx_registration_event_attendance.
-- The access type changed to index and Extra shows
-- "Using where; Using index".
--
-- Conclusion:
-- The execution plan changed after adding the composite
-- index on (EventID, AttendanceStatus).
-- ============================================================

-- QUERY 2: FEEDBACK ANALYSIS
-- EXPLAIN BEFORE INDEX

EXPLAIN 
SELECT 
	E.EventID,
    E.EventTitle,
    AVG(F.Rating) AS AverageRating,
    COUNT(F.FeedbackID) AS TotalFeedback
FROM Event AS E
JOIN Feedback AS F
	ON E.EventID = F.EventID
WHERE F.Rating  >= 4	
GROUP BY 
	E.EventID,
    E.EventTitle
HAVING COUNT(F.FeedbackID) >= 5;

-- CREATING INDEX

CREATE INDEX idx_feedback_event_rating
ON Feedback(EventID, Rating);


EXPLAIN 
SELECT 
	E.EventID,
    E.EventTitle,
    AVG(F.Rating) AS AverageRating,
    COUNT(F.FeedbackID) AS TotalFeedback
FROM Event AS E
JOIN Feedback AS F
	ON E.EventID = F.EventID
WHERE F.Rating  >= 4	
GROUP BY 
	E.EventID,
    E.EventTitle
HAVING COUNT(F.FeedbackID) >= 5;

-- ============================================================
-- QUERY 2: BEFORE vs AFTER INDEX
-- ============================================================
-- BEFORE:
-- Feedback used a full table scan (type = ALL)
-- and no index was selected (key = NULL).
-- The optimizer estimated 684 rows.
--
-- AFTER:
-- MySQL selected idx_feedback_event_rating.
-- The access type changed to ref and the estimated rows
-- decreased to 5.
--
-- Extra shows "Using where; Using index", indicating that
-- the index is being used while applying the query conditions.
--
-- Conclusion:
-- The composite index on (EventID, Rating) significantly
-- changed the execution plan and reduced the estimated
-- number of rows examined for the Feedback table.
-- ===========================================================




