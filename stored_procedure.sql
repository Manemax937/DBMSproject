USE ieee_student_branch_db;

USE IEEE_Student_Branch_DB;

-- ============================================================
-- STORED PROCEDURE: RegisterStudentForEvent
-- ============================================================
-- Description:
-- This stored procedure automates the process of registering
-- a student for an IEEE event.
--
-- It accepts StudentID and EventID as input parameters.
-- The procedure checks the event capacity and counts the
-- number of students who are already registered.
--
-- If the event is full, the procedure generates an error.
-- Otherwise, a new registration is created automatically
-- with the current date and default attendance status.
--
-- This procedure implements an operational transaction
-- for the IEEE Student Branch Event Management System.
-- ============================================================

DELIMITER $$

CREATE PROCEDURE RegisterStudentForEvent(
	IN p_StudentID INT,
    IN p_EventID INT
)
BEGIN
	DECLARE v_Capacity INT;
    DECLARE v_CurrentRegistration INT;
    
    SELECT Capacity
    INTO v_Capacity
    FROM Event
    WHERE EventID = p_EventID;
    
    SELECT COUNT(*)
    INTO v_CurrentRegistration
    FROM Registration
    WHERE EventID = p_EventID
		AND Status = 'Registered';
        
	IF v_CurrentRegistration >= v_Capacity THEN
		
        SIGNAL SQLSTATE  '45000'
        SET MESSAGE_TEXT = 'Event Capacity is full';
	
    ELSE 
    
		INSERT INTO Registration
        (
			StudentID,
            EventID,
            RegistrationDate,
            Status,
            AttendanceStatus
		)
		VALUES
        (
			p_StudentID,
            p_EventID,
            CURRENT_DATE,
            'Registered',
            'Absent'
		);
    
    END IF;

END $$

DELIMITER ;


-- USE OF STORED PROCEDURE

SELECT 
	S.StudentID,
    S.FullName,
    E.EventID,
    E.EventTitle
FROM Student AS S
CROSS JOIN Event AS E
LEFT JOIN Registration AS R	
	ON R.StudentID = S.StudentID
    AND R.EventID = E.EventID
WHERE R.RegistrationID IS NULL
LIMIT 1;

CALL RegisterStudentForEvent(1120, 4001);

SELECT *
FROM Registration
WHERE StudentID = 1120
  AND EventID = 4001;