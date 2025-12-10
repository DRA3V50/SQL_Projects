-- Create table if it doesn't exist
IF OBJECT_ID('dbo.metrics','U') IS NULL
CREATE TABLE dbo.metrics(
    task NVARCHAR(50),         -- metric name
    value INT,                 -- metric value
    status NVARCHAR(10)        -- Normal / Warning / Critical
);
-- Insert sample metrics
INSERT INTO dbo.metrics(task,value,status)
VALUES 
('Task1',45,'Normal'),       -- normal metric
('Task2',65,'Warning'),      -- medium metric
('Task3',90,'Critical');     -- critical metric
-- Declare variables to hold metric values
DECLARE @task NVARCHAR(50), @value INT, @status NVARCHAR(10), @msg NVARCHAR(200);

-- Loop through all metrics
DECLARE data_cursor CURSOR FOR SELECT task,value,status FROM dbo.metrics; -- select all rows
OPEN data_cursor                                   -- open the cursor
FETCH NEXT FROM data_cursor INTO @task,@value,@status; -- fetch first row

WHILE @@FETCH_STATUS = 0                           -- loop through all rows
BEGIN
    SET @msg = @task + ': ' + CAST(@value AS NVARCHAR); -- create message text
    IF @status='Critical'                            -- if metric is critical
        RAISERROR('*** %s *** CRITICAL',16,1,@msg) WITH NOWAIT; -- print red with symbols
    ELSE IF @status='Warning'                        -- if metric is warning
        PRINT('<> ' + @msg + ' <> MEDIUM');          -- print symbols + word
    ELSE                                             -- if metric is normal
        PRINT('-- ' + @msg + ' -- NORMAL');          -- print symbols + word
    FETCH NEXT FROM data_cursor INTO @task,@value,@status; -- move to next row
END
CLOSE data_cursor; DEALLOCATE data_cursor;           -- clean up cursor
