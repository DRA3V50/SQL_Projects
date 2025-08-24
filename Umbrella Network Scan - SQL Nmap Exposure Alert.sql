-- [][][][][][][][][][][][][[][][][][][][][][][]
-- SQL ~ 'NMAP'
-- 4 hosts, 3 ports each, total 12 scans (Can add more if you want!)
-- [][][]][][][][][][][][][][][][][][][][][][][]

USE master;
GO
-- Drop old objects if they exist (tables/procedure)
IF OBJECT_ID('TargetHosts','U') IS NOT NULL DROP TABLE TargetHosts; -- hosts table
IF OBJECT_ID('ScanResults','U') IS NOT NULL DROP TABLE ScanResults; -- results table
IF OBJECT_ID('sp_MiniScan','P') IS NOT NULL DROP PROCEDURE sp_MiniScan; -- procedure
GO
-- Table: hosts to scan
CREATE TABLE TargetHosts (
    HostID INT IDENTITY(1,1) PRIMARY KEY, -- unique ID
    HostName NVARCHAR(50),                -- name of host
    IPAddress NVARCHAR(20)                -- IP of host
);
GO
-- Table: store scan results
CREATE TABLE ScanResults (
    ResultID INT IDENTITY(1,1) PRIMARY KEY, -- unique result ID
    HostName NVARCHAR(50),                  -- scanned host
    IPAddress NVARCHAR(20),                 -- scanned IP
    Port INT,                               -- scanned port
    Status NVARCHAR(50)                     -- status or warning
);
GO
-- Insert 4 sample hosts
INSERT INTO TargetHosts (HostName, IPAddress) VALUES
('Laboratory_Router','192.168.1.37'), -- first host
('Server ~ REUCL','192.168.1.50'), -- second host
('EdgeFirewall_REL','192.168.1.28'), -- third host
('MailGateway_UC','192.168.1.9'); -- fourth host
GO
-- Mini scan
CREATE PROCEDURE sp_MiniScan
AS
BEGIN
    DECLARE @Host NVARCHAR(50), @IP NVARCHAR(20); -- host variables
    DECLARE @Port INT, @Status NVARCHAR(50);      -- port variables

    -- Cursor to loop through hosts
    DECLARE host_cursor CURSOR FOR 
    SELECT HostName, IPAddress FROM TargetHosts; -- select hosts
    OPEN host_cursor; -- open cursor
    FETCH NEXT FROM host_cursor INTO @Host, @IP; -- fetch first host

    -- Loop through each host
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Port = 180; -- first port
        WHILE @Port <= 182 -- 3 ports per host
        BEGIN
            -- Randomly decide for port is open or closed
            IF RAND(CHECKSUM(NEWID())) > 0.5
                SET @Status = 'WARNING - OPEN!'; -- exposed port warning
            ELSE
                SET @Status = 'CLOSED'; -- safe port
            -- Log scan result in table
            INSERT INTO ScanResults (HostName, IPAddress, Port, Status)
            VALUES (@Host, @IP, @Port, @Status);
            -- Print dramatic warning if open
            PRINT @IP + ' port ' + CAST(@Port AS NVARCHAR) + ': ' + @Status;

            SET @Port = @Port + 1; -- move to next port
        END
        FETCH NEXT FROM host_cursor INTO @Host, @IP; -- move to next host
    END
    CLOSE host_cursor; -- close cursor
    DEALLOCATE host_cursor; -- release cursor
    PRINT '=== MINI SCAN COMPLETE - 12 SCANS TOTAL ==='; -- final message
END;
GO
-- Execute scan
EXEC sp_MiniScan;
GO
-- View results
SELECT * FROM ScanResults; -- display logged results
GO