
USE IEEE_Student_Branch_DB;

SHOW TRIGGERS FROM IEEE_Student_Branch_DB;


-- ============================================================
-- TRIGGER: trg_feedback_after_attendance
-- ============================================================
-- Purpose:
-- This trigger enforces the business rule that a student
-- can submit feedback for an event only if the student
-- has registered for and attended that event.
--
-- It executes automatically BEFORE a new feedback record
-- is inserted into the Feedback table.
--
-- The trigger checks the Registration table using the
-- StudentID and EventID of the new feedback record.
--
-- If the student is not registered or has not attended,
-- the insertion is rejected using SIGNAL.
--
-- If the student has attended the event, the feedback
-- record is allowed to be inserted.
-- ============================================================

-- DROP TRIGGER IF EXISTS trg_feeback_after_attendance;

-- DELIMITER $$

-- CREATE TRIGGER trg_feedback_after_attendance
-- BEFORE INSERT ON Feedback
-- FOR EACH ROW	
-- BEGIN

-- 	IF NOT EXISTS(
-- 		SELECT 1
--         FROM Registration
--         WHERE StudentID = NEW.StundentID
--         AND EventID = NEW.EventID
--         AND Status = 'Registered'
--         AND AttendanceStatus = 'Present'
-- 	) THEN
-- 		
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'Feedback allowed only after attending the event';
-- 	
--     END IF;

-- END $$

-- DELIMITER ; 


-- -- === USE OF TRIGGER =========

SELECT 
	R.StudentID,
    R.EventID,
    R.AttendanceStatus
FROM Registration AS R
LEFT JOIN Feedback AS F
	ON R.StudentID = F.StudentID
    AND R.EventID = F.EventID
WHERE R.Status = 'Registered'
	AND R.AttendanceStatus = 'Absent'
    AND F.FeedbackID IS NULL
LIMIT 1;

-- -- We have 1029	4002	Absent 
-- -- so


SELECT
    StudentID,
    EventID,
    Status,
    AttendanceStatus
FROM Registration
WHERE StudentID = 1029
  AND EventID = 4002;
  
SHOW TRIGGERS
WHERE `Table` = 'Feedback';

SHOW TRIGGERS;

INSERT INTO Feedback
(FeedbackID, StudentID, EventID, Rating, Comments)
VALUES
(10001, 1029, 4002, 5, 'Excellent event');