-- ==========================================
-- IEEE Student Branch operation and event management;
-- TAE-2 
-- ==========================================

CREATE DATABASE IF NOT EXISTS ieee_student_branch_db;
USE ieee_student_branch_db;

-- STUDENT TABLE

CREATE TABLE Student (
	StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Year INT NOT NULL,
		CHECK(Year BETWEEN 1 AND 4)
) ENGINE = InnoDB;

-- FACULTY COORDINATOR TABLE

CREATE TABLE FacultyCoordinator(
	FacultyID INT PRIMARY KEY,
    FacutyName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
	Department VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

ALTER TABLE FacultyCoordinator
RENAME COLUMN FacutyName TO FacultyName;



-- MEMBERSHIP TABLE

CREATE TABLE Membership(
	MembershipID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    MembershipNumber VARCHAR(30) NOT NULL UNIQUE,
    MembershipType VARCHAR(30) NOT NULL DEFAULT 'Student',
    StartDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    
    CONSTRAINT fk_membership_student
		FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CHECK (ExpiryDate >= StartDate),
    CHECK (MembershipType IN ('Student' , 'Professional')),
    CHECK (Status IN ('Active', 'Expired'))
) ENGINE = InnoDB;



-- CHAPTER TABLE

CREATE TABLE CHAPTER (
	ChapterID INT PRIMARY KEY,
    ChapterName VARCHAR(100) NOT NULL,
    Domain VARCHAR(50) NOT NULL,
    FacultyID INT NOT NULL,

	CONSTRAINT fk_chapter_faculty
		FOREIGN KEY (FacultyID)
        REFERENCES FacultyCoordinator(FacultyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- EVENT TABLE


CREATE TABLE Event (
    EventID INT PRIMARY KEY,
    ChapterID INT NOT NULL,
    EventTitle VARCHAR(150) NOT NULL,
    EventType VARCHAR(50) NOT NULL,
    Venue VARCHAR(100) NOT NULL,
    EventDate DATE NOT NULL,
    Capacity INT NOT NULL,

    CONSTRAINT fk_event_chapter
        FOREIGN KEY (ChapterID)
        REFERENCES Chapter(ChapterID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (Capacity > 0)
) ENGINE = InnoDB;



-- REGISTRATON TABLE

CREATE TABLE Registration (
	RegistrationID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    EventID INT NOT NULL,
    RegistrationDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    Status VARCHAR(20) NOT NULL DEFAULT 'Registered',
    AttendanceStatus VARCHAR(20) NOT NULL DEFAULT 'Absent',
    
	CONSTRAINT fk_registration_student
		FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CHECK (Status IN ('Registered', 'Cancelled')),
    CHECK(AttendanceStatus IN ('Present', 'Absent'))
 ) ENGINE = InnoDB;
 
 
-- FEEDBACK TABLE

CREATE TABLE Feedback (
	FeedbackID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    EventID INT NOT NULL,
    Rating INT NOT NULL,
    Comments TEXT,
    
    CONSTRAINT fk_feedback_student
		FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_feedback_event
		FOREIGN KEY (EventID)
        REFERENCES Event(EventID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	
     CHECK (Rating BETWEEN 1 AND 5)
) ENGINE = InnoDB;


