# 🏥 Hospital Management & Healthcare Analytics Case Study (SQL)

A MySQL case study analyzing operational data from a fictional hospital — City General Hospital — covering patients, doctors, appointments, treatments, and billing, to uncover insights into healthcare operations.

## 📌 Project Overview

This case study simulates a real-world healthcare analytics task: given raw relational data from a hospital's day-to-day operations, write SQL queries to answer key business questions — patient trends, doctor workload, treatment patterns, and billing performance. The project focuses on practical, query-driven analysis using MySQL Workbench.

## 🎯 Objectives

- Set up and structure a relational database from 5 raw CSV datasets
- Write SQL queries to analyze patient demographics and visit patterns
- Examine doctor and appointment data to understand workload distribution
- Analyze treatments and billing to surface revenue and cost insights
- Practice joins, aggregations, and filtering across multiple related tables

## 🛠️ Tools & Techniques Used

| Tool / Technique | Purpose |
|---|---|
| MySQL | Database creation and query execution |
| MySQL Workbench | Writing, running, and testing SQL queries |
| JOINs (INNER/LEFT) | Combining data across patients, doctors, appointments, treatments, and billing |
| Aggregate Functions | COUNT, SUM, AVG for summarizing operational metrics |
| GROUP BY / HAVING | Category-level and conditional summarization |
| Subqueries | Answering multi-step analytical questions |

## 🗂️ Dataset Structure

The database (`case_study`) is built from 5 related tables:

- **Patients** — demographic and registration details
- **Doctors** — specialization and staffing information
- **Appointments** — scheduling and visit records
- **Treatments** — procedures and treatment details linked to appointments
- **Billing** — charges and payment records

## 📈 What's Inside

- Full `.sql` file with database setup and analysis queries
- Queries covering patient trends, doctor workload, appointment patterns, treatment analysis, and billing insights
- Verified data integrity across all 5 imported tables before analysis

## 💡 Key Learnings

- Structuring and verifying a multi-table relational database before running analysis
- Writing multi-table JOIN queries to answer real operational questions
- Using aggregation and grouping to turn raw hospital records into actionable metrics

## 🚀 How to Use

1. Download the `.sql` file from this repository
2. Import it into MySQL Workbench (or your preferred MySQL client)
3. Run the setup script to create the `case_study` database and tables
4. Execute the analysis queries to explore patient, doctor, appointment, treatment, and billing insights

## 👤 Author

**Chitturi Gangadhar**
B.Tech AI & ML student | Aspiring Data Analyst
📫 [LinkedIn](https://linkedin.com/in/chitturi-gangadhar-14b750260) · [GitHub](https://github.com/Gangadharsai8)
