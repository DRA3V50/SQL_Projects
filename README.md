# SQL Projects

A collection of SQL projects focused on **database security, evidence management, and secure reporting systems**, including simulations for SQL injection prevention and network scanning.

## **1. SQL Blackmail Reporting System**

This project provides a set of SQL scripts to manage blackmail reports and associated evidence. It allows you to:

- Store reports with details such as reporter, incident description, and timestamp  
- Track whether evidence is attached to each report  
- Automatically update report status when evidence is added  
- Keep certain reports anonymous, if needed  

Example queries demonstrate how to retrieve open reports or reports with evidence.

**How to Use:**  
To run this project, open the SQL scripts in your SQL Server environment. Use the example queries to explore the data, add new reports, and attach evidence as needed.

## **2. Umbrella Network Scan: SQL Nmap Exposure Alert**

This project simulates a SQL-based Nmap network scan for lab practice. It includes four networking hosts, each with three ports, for a total of twelve simulated scans. The project outputs warning messages for exposed ports and provides a stored procedure named sp_Scan to run the scan in a safe, contained environment.

**How to Use:**  
Open the file named Umbrella_Network_Scan_SQL_Nmap_Exposure_Alert.sql in SQL Server Management Studio or Azure Data Studio. Execute the script to create the required tables and stored procedure. Run the scan to view simulated results.  

**Important Notes:**  
Use this simulation responsibly and only in your lab environment. All scan results are randomly generated for educational purposes and will not affect any real networks or systems.

## **3. Automated Metrics Logging System**

This project is a simple SQL automation tool that simulates real-time logging, severity detection, and readable output formatting. It collects task metrics, evaluates their severity levels, and outputs logs using red coloring for critical entries and symbolic markers for medium and normal levels. This project demonstrates data monitoring, automated evaluation, and logging behavior similar to realistic analytics workflows.

**Key Features:**  
- Stores metric name, value, and status which can be Normal, Warning, or Critical  
- Critical messages are displayed in red using RAISERROR  
- Medium and normal messages use symbols and text markers for clarity  
- Supports adding new metrics to simulate real-time monitoring  
- Demonstrates automated data collection and workflow monitoring  

**How to Use:**  
Open the SQL script in SQL Server Management Studio. Run the script to create the metrics table and insert sample data. Execute the logging section to view outputs with red critical logs and symbolic markers for other severity levels. Add or modify metric rows as needed to simulate different conditions.
