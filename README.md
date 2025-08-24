# SQL Projects

A collection of SQL projects focused on **database security, evidence management, and secure reporting systems**, including simulations for SQL injection prevention and network scanning.

----------------

## **1. SQL Blackmail Reporting System**

This project provides a set of SQL scripts to manage blackmail reports and associated evidence. It allows you to:

- Store reports with details such as reporter, incident description, and timestamp  
- Track whether evidence is attached to each report  
- Automatically update report status when evidence is added  
- Keep certain reports anonymous, if needed  

Example queries demonstrate how to retrieve open reports or reports with evidence.

**How to Use:**  
1. Run the SQL scripts in your SQL Server environment  
2. Use the example queries to explore and interact with the data  
3. Modify or add reports and evidence as needed  

----------------

## **2. Umbrella Network Scan: SQL Nmap Exposure Alert**

This project simulates a **SQL-based Nmap network scan** for lab practice. It includes:

- **Four networking hosts**, each with three ports (12 scans total)  
- **“WARNING - OPEN!”** messages for exposed ports  
- A stored procedure (`sp_Scan`) to run the scan  
- Safe, contained network scanning simulation  

**How to Use:**  
1. Open `Umbrella_Network_Scan_SQL_Nmap_Exposure_Alert.sql` in SSMS or Azure Data Studio  
2. Execute the script to create the necessary tables and stored procedure  
3. Run the scan with:  

EXEC sp_Scan;
-- ****************************************************************************
-- ⚠️ WARNING: This is a safe, educational simulation.
-- The scan results are randomly generated in SQL and do NOT affect real networks.
-- You can safely run this in your lab environment.
-- ****************************************************************************
