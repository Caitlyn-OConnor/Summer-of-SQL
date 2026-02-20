# SQL Data Challenges Repository

## Overview

This repository serves as a comprehensive collection of SQL solutions developed for various data challenges and case studies. It primarily features solutions to weekly Preppin' Data challenges from 2023, alongside case studies from "Data With Danny" and "Foodie-Fi". The SQL scripts demonstrate a wide array of data transformation, analysis, and manipulation techniques, suitable for learning and reference in a data-centric environment.

---

## Features

The solutions within this repository showcase advanced SQL capabilities, including but not limited to:

*   **Preppin' Data 2023 Challenges:** Solutions for a series of weekly challenges covering diverse data scenarios.
*   **Data With Danny Case Studies:** Implementations for specific sections of complex data analysis case studies.
*   **Data Transformation:** Extensive use of Common Table Expressions (CTEs), window functions (e.g., `SUM() OVER()`, `RANK() OVER()`, `LEAD()`), and conditional logic (`CASE WHEN`, `IFF`).
*   **Date and Time Manipulation:** Functions for parsing, truncating, and adding to dates (`TRY_TO_DATE`, `DATE_TRUNC`, `DATEADD`, `MONTHNAME`, `DAYNAME`).
*   **String Operations:** Techniques for splitting, concatenating, and pattern matching (`SPLIT_PART`, `CONCAT`, `REGEXP_SUBSTR`).
*   **Data Aggregation and Summarization:** Grouping data and performing calculations (`SUM`, `COUNT`, `AVG`).
*   **Pivoting and Unpivoting Data:** Transforming data layouts for easier analysis.
*   **Joins and Relational Logic:** Complex multi-table joins to integrate disparate data sources.
*   **Geo-spatial Calculations:** Examples like calculating distances between geographical points (`Week_11`).
*   **Financial Data Processing:** Calculating running balances and analyzing transaction patterns (`Week_9`, `Week_10`, `Data_with_Danny_Section_B`).

---

## Setup

To utilize the SQL scripts in this repository, you will need access to a SQL environment. The queries are written using a dialect often compatible with Snowflake, given the functions used (e.g., `try_to_date`, `split_part`, `monthname`, `iff`, `unpivot`).

1.  **SQL Environment:** Ensure you have access to a database system (e.g., Snowflake, PostgreSQL, MySQL, SQL Server) where you can execute SQL queries. Some functions might be specific to Snowflake and may require minor adjustments for other SQL dialects.
2.  **Data Loading:** The scripts assume the presence of underlying tables (e.g., `pd2023_wk01`, `customer_transactions`, `pd2023_wk07_account_information`). These tables are not included in the repository. To run the solutions, you would need to set up the corresponding source data in your chosen SQL environment, matching the table and column names referenced in the queries.

---

## Usage

Each `.sql` file in this repository contains a self-contained solution to a specific challenge.

1.  **Browse Solutions:** Navigate through the files to find solutions relevant to your interest. Files are named descriptively (e.g., `Preppin_Data_2023_Week_1.sql`, `Data_with_Danny_Section_B.sql`).
2.  **Open a File:** Open any `.sql` file in your preferred text editor or SQL client.
3.  **Execute Queries:** Copy the SQL content and paste it into your SQL client connected to your database. Execute the queries to see the results.
4.  **Adaptation:** The queries can be studied, modified, and adapted for similar data challenges or integrated into larger data pipelines.

---

## Project Structure

The repository is organized to logically group the SQL solutions:

```text
.
├── Case_Study_#3_Foodie-Fi.sql
├── Data_with_Danny_Section_B.sql
├── Preppin_Data_2023_Week_1.sql
├── Preppin_Data_2023_Week_10.sql
├── Preppin_Data_2023_Week_11.sql
├── Preppin_Data_2023_Week_12.sql
├── Preppin_Data_2023_Week_2.sql
├── Preppin_Data_2023_Week_3.sql
├── Preppin_Data_2023_Week_4.sql
├── Preppin_Data_2023_Week_5.sql
├── Preppin_Data_2023_Week_6.sql
├── Preppin_Data_2023_Week_7.sql
├── Preppin_Data_2023_Week_8.sql
├── Preppin_Data_2023_Week_9.sql
└── The Data Bank - Section A/
```

*   `Case_Study_#3_Foodie-Fi.sql`: SQL solution for the "Foodie-Fi" case study.
*   `Data_with_Danny_Section_B.sql`: SQL solution for "Data With Danny" case study, specifically Section B.
*   `Preppin_Data_2023_Week_X.sql`: Individual SQL files containing solutions for each respective week of the "Preppin' Data 2023" challenges.
*   `The Data Bank - Section A/`: A directory intended to hold solutions or related files for "The Data Bank - Section A" challenges.

---

## Notes/Design

The SQL solutions primarily emphasize analytical problem-solving using a declarative approach. Common design patterns observed include:

*   **Modular Queries with CTEs:** Extensive use of Common Table Expressions to break down complex problems into smaller, more manageable, and readable steps.
*   **Window Functions for Contextual Analysis:** Leveraging window functions to perform calculations across related rows without explicit self-joins, enabling sophisticated aggregations, rankings, and running totals.
*   **Data Type Handling:** Frequent use of functions like `TRY_TO_DATE` and explicit casting (`TO_DOUBLE`, `TO_DECIMAL`) to ensure correct data type conversions, especially when dealing with mixed-format source data.
*   **Vendor-Specific Functions:** While aiming for general SQL principles, the snippets indicate a leaning towards Snowflake-specific functions for date, string, and conditional logic. Users of other SQL databases might need to adjust these functions to their respective dialect.
