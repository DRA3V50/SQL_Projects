IF NOT EXISTS(SELECT * FROM sys.databases WHERE name='BM_BTC_System')  -- Check if database exists; create if it doesn't
    CREATE DATABASE BM_BTC_System;           -- Create database BM_BTC_System  
GO  
USE BM_BTC_System;                           -- Switch context to BM_BTC_System  
GO  

-- Drop Evidence table if it already exists  
IF OBJECT_ID('Evidence','U') IS NOT NULL DROP TABLE Evidence;  
-- Drop BlackmailReports table if it already exists  
IF OBJECT_ID('BlackmailReports','U') IS NOT NULL DROP TABLE BlackmailReports;  
GO  

-- Create BlackmailReports table to store reports  
CREATE TABLE BlackmailReports (  
    report_id INT IDENTITY PRIMARY KEY,      -- Unique ID for each report, auto-incremented  
    reporter_name NVARCHAR(100) NULL,        -- Name of reporter, NULL if anonymous  
    report_text NVARCHAR(MAX) NOT NULL,      -- Description of the blackmail incident  
    incident_date DATE NOT NULL,              -- Date when incident happened  
    btc_threat DECIMAL(6,3) NULL,            -- Bitcoin ransom demanded (nullable)  
    status NVARCHAR(20)                      -- Current status of the report  
        CHECK(status IN ('Open','Has Evidence','Resolved')) DEFAULT 'Open', -- Allowed statuses  
    created_at DATETIME DEFAULT GETDATE()    -- Timestamp when report was created  
);  
GO  

-- Create Evidence table to store proof linked to reports  
CREATE TABLE Evidence (  
    evidence_id INT IDENTITY PRIMARY KEY,    -- Unique ID for each evidence item, auto-incremented  
    report_id INT NOT NULL FOREIGN KEY REFERENCES BlackmailReports(report_id), -- Foreign key to link evidence to report  
    evidence_type NVARCHAR(50),               -- Type of evidence (e.g., screenshot, GIF)  
    evidence_url NVARCHAR(MAX),                -- URL or path to evidence file  
    uploaded_at DATETIME DEFAULT GETDATE()    -- Timestamp when evidence was uploaded  
);  
GO  

-- Trigger to automatically update report status when new evidence is added  
CREATE TRIGGER trg_UpdateStatusOnEvidence ON Evidence AFTER INSERT AS  
BEGIN  
    UPDATE r SET status='Has Evidence'        -- Update status to 'Has Evidence'  
    FROM BlackmailReports r  
    JOIN inserted i ON r.report_id = i.report_id -- Join with newly inserted evidence  
    WHERE r.status = 'Open';                   -- Only update reports currently marked as 'Open'  
END;  
GO  

-- Insert sample blackmail report #1 (anonymous) with BTC ransom threat  
INSERT INTO BlackmailReports (reporter_name, report_text, incident_date, btc_threat) VALUES  
(NULL, 'Pay 500 BTC now or your secrets go viral.', '2025-07-25', 0.5),  

-- Insert sample blackmail report #2 (named) with BTC ransom threat  
('*Unknown*', '500 BTC ransom demanded to avoid exploit!', '2025-07-24', 1.2);  

-- Insert evidence linked to the first report  
INSERT INTO Evidence (report_id, evidence_type, evidence_url) VALUES  
(1, 'ANONYMOUS', 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExeTkyNXQ5NjYxMjh5Mnd2eWd2djM0dzIzMG9yMXhtMTRndW9vZjd5dSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/DqiMTFxiXx0VaVZQbF/giphy.gif');  
GO  

-- Query to retrieve all open blackmail cases  
SELECT * FROM BlackmailReports WHERE status = 'Open';  

-- Query to retrieve reports that have evidence attached  
SELECT r.report_id, r.reporter_name, r.btc_threat, e.evidence_type, e.evidence_url  
FROM BlackmailReports r  
JOIN Evidence e ON r.report_id = e.report_id;  
GO  