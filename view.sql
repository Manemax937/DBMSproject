USE IEEE_Student_Branch_DB;

-- ============================================================
-- VIEW 1: Event Registration Summary
-- ============================================================
-- Purpose:
-- Provides a reusable report showing the number of
-- registrations and attendees for each IEEE event.
-- ============================================================

CREATE OR REPLACE VIEW vw_EventRegistrationSummary AS
SELECT
    E.EventID,
    E.EventTitle,
    C.ChapterName,
    COUNT(R.RegistrationID) AS TotalRegistrations,
    SUM(
        CASE
            WHEN R.AttendanceStatus = 'Present' THEN 1
            ELSE 0
        END
    ) AS PresentStudents
FROM Event AS E
JOIN Chapter AS C
    ON E.ChapterID = C.ChapterID
LEFT JOIN Registration AS R
    ON E.EventID = R.EventID
    AND R.Status = 'Registered'
GROUP BY
    E.EventID,
    E.EventTitle,
    C.ChapterName;
    
SELECT *
FROM vw_EventRegistrationSummary;

-- ============================================================
-- VIEW 2: Chapter Performance Report
-- ============================================================
-- Purpose:
-- Provides a reusable report showing chapter activity,
-- registrations, and average feedback rating.
-- ============================================================

CREATE OR REPLACE VIEW vw_ChapterPerformance AS
SELECT
    C.ChapterID,
    C.ChapterName,
    F.FacultyName,
    COUNT(DISTINCT E.EventID) AS TotalEvents,
    COUNT(DISTINCT R.RegistrationID) AS TotalRegistrations,
    ROUND(AVG(FB.Rating), 2) AS AverageRating
FROM Chapter AS C
JOIN FacultyCoordinator AS F
    ON C.FacultyID = F.FacultyID
LEFT JOIN Event AS E
    ON C.ChapterID = E.ChapterID
LEFT JOIN Registration AS R
    ON E.EventID = R.EventID
    AND R.Status = 'Registered'
LEFT JOIN Feedback AS FB
    ON E.EventID = FB.EventID
GROUP BY
    C.ChapterID,
    C.ChapterName,
    F.FacultyName;
    
SELECT *
FROM vw_ChapterPerformance;