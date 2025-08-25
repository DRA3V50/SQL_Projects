-- ======================================================
-- Umbrella Network Scan: SQL Nmap Exposure Alert
-- 4 hosts, 3 ports each, total 12 scans
-- ======================================================
USE master;
GO
-- Drop old objects if they exist
IF OBJECT_ID('TargetHosts','U') IS NOT NULL DROP TABLE TargetHosts;   -- hosts table
IF OBJECT_ID('ScanResults','U') IS NOT NULL DROP TABLE ScanResults;   -- results table
IF OBJECT_ID('sp_MiniScan','P') IS NOT NULL DROP PROCEDURE sp_Scan; -- procedure
GO
-- Table: hosts to scan
CREATE TABLE TargetHosts (
    HostID INT IDENTITY(1,1) PRIMARY KEY, -- unique ID
    HostName NVARCHAR(50),                -- host name
    IPAddress NVARCHAR(20)                -- host IP
);
GO
-- Table: store scan results
CREATE TABLE ScanResults (
    ResultID INT IDENTITY(1,1) PRIMARY KEY, -- unique result ID
    HostName NVARCHAR(50),                  -- scanned host
    IPAddress NVARCHAR(20),                 -- scanned IP
    Port INT,                               -- scanned port
    Status NVARCHAR(50)                     -- port status
);
GO
-- Insert 4 sample hosts
INSERT INTO TargetHosts (HostName, IPAddress) VALUES
('Laboratory_Router','192.168.1.37'),
('Server_REUCL','192.168.1.50'),
('EdgeFirewall_REL','192.168.1.28'),
('MailGateway_UC','192.168.1.9');
GO
-- Stored procedure: mini scan simulation
CREATE PROCEDURE sp_Scan
AS
BEGIN
    DECLARE @Host NVARCHAR(50), @IP NVARCHAR(20);    -- host variables
    DECLARE @Port INT, @Status NVARCHAR(50);         -- port variables
    -- Cursor to loop through hosts
    DECLARE host_cursor CURSOR FOR 
    SELECT HostName, IPAddress FROM TargetHosts;
    OPEN host_cursor; 
    FETCH NEXT FROM host_cursor INTO @Host, @IP;
    -- Loop through each host
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Port = 180; -- first port
        WHILE @Port <= 182 -- 3 ports per host
        BEGIN
            -- Randomly determine port status
            IF RAND(CHECKSUM(NEWID())) > 0.5
                SET @Status = 'WARNING - OPEN!'; -- exposed port
            ELSE
                SET @Status = 'CLOSED';          -- closed port
            -- Log result
            INSERT INTO ScanResults (HostName, IPAddress, Port, Status)
            VALUES (@Host, @IP, @Port, @Status);
            -- Print warning
            PRINT @IP + ' port ' + CAST(@Port AS NVARCHAR) + ': ' + @Status;
            SET @Port = @Port + 1; -- next port
        END
        FETCH NEXT FROM host_cursor INTO @Host, @IP; -- next host
    END
    CLOSE host_cursor; 
    DEALLOCATE host_cursor; 
    PRINT '=== MINI SCAN COMPLETE - 12 SCANS TOTAL ==='; -- final message
END;
GO
-- Execute scan
EXEC sp_MiniScan;
GO
-- View results
SELECT * FROM ScanResults; -- show logged results
GO
