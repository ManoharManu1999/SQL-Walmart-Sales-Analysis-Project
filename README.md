![Walmart Sales Analysis Banner](Walmart%20Project%20Banner.png)

# 🛒 Walmart Sales Data Analysis – SQL Project

## 📌 Project Overview
This project is an **end-to-end data analysis solution** designed to extract critical business insights from Walmart sales data. We utilize **SQL Server** to process raw transactional data, employing advanced techniques like **ETL (Extract, Transform, Load)**, **Feature Engineering**, and **Exploratory Data Analysis (EDA)**.

The goal is to identify high-performing branches, analyze sales patterns, and decipher customer behavior to support data-driven decision-making.

**Key Competencies Demonstrated:**
* **Advanced SQL:** CTEs, Window Functions, Aggregate Functions, Stored Procedures.
* **ETL Processes:** Data cleaning, validation, and BULK INSERT operations.
* **Business Intelligence:** Translating data into actionable insights regarding revenue, inventory, and customer segmentation.

---

## 🛠️ Tech Stack
* **Database:** Microsoft SQL Server
* **Language:** T-SQL
* **Tools:** SQL Server Management Studio (SSMS)
* **Techniques:** Data Cleaning, Feature Engineering, Window Functions, CTEs

---

## 📂 Project Structure
```text
SQL-Walmart-Sales-Analysis
│
├── ddl.sql                 # Database schema and table creation
├── load_proc.sql           # Stored procedures for bulk data loading
├── eda_sales_analysis.sql  # Exploratory Data Analysis & Business Questions
├── datasets/               # Raw CSV data files
├── README.md               # Project documentation
└── project_report.pdf      # Detailed project report
```
---
## 📊 Business Questions Solved
The analysis is structured around three major pillars: **Product**, **Sales**, and **Customer**.

The analysis queries (`eda_sales_analysis.sql`) are structured to answer key business questions across multiple dimensions.

---

## 1️⃣ Generic & Geographic Analysis

- **City Coverage:**  
  How many unique cities and branches does the dataset include?

- **Branch Location Mapping:**  
  In which city is each branch located?

---

## 2️⃣ Product Analysis

Focused on identifying revenue drivers and underperforming product categories.

- **Unique Product Lines:**  
  How many unique product categories exist in the dataset?

- **Top Sellers:**  
  Which product line has the highest sales quantity?

- **Revenue Contribution:**  
  Which product line generates the highest total revenue?

- **Taxation Analysis:**  
  Which product category incurs the highest VAT (Value Added Tax)?

- **Profitability Indicator:**  
  Which product line has the highest average customer rating?

---

## 3️⃣ Sales Analysis

- **Temporal Trends:**  
  Which time of day (Morning / Afternoon / Evening) records the highest sales?

- **Customer Type Performance:**  
  Which customer segment (Member vs Normal) generates more revenue?

- **City Performance:**  
  Which city contributes the highest VAT percentage?

- **Payment Behavior:**  
  What is the most frequently used payment method?

---

## 4️⃣ Customer Analysis

- **Demographics:**  
  What is the gender distribution across different branches?

- **Customer Ratings:**  
  Which time of day receives the highest customer ratings?

- **Spending Patterns:**  
  Which day of the week has the best average customer ratings?

---

## ⚙️ Engineering Process

### 1️⃣ Database Design & Schema

A **star-schema-inspired design** was implemented to support analytical querying and reporting use cases.
Data integrity was maintained using **Primary Keys** and **NOT NULL constraints**.



| Column | Type | Description |
|------|------|-------------|
| invoice_id | VARCHAR(50) | PK – Unique transaction ID |
| branch | VARCHAR(5) | Store branch (A, B, C) |
| city | VARCHAR(30) | Store location |
| customer_type | VARCHAR(30) | Member / Normal |
| gender | VARCHAR(10) | Customer gender |
| product_line | VARCHAR(100) | Product category |
| unit_price | DECIMAL(10,2) | Price per unit |
| quantity | INT | Number of units sold |
| tax | DECIMAL(10,2) | 5% tax amount |
| total | DECIMAL(10,2) | Final transaction value |
| date | DATE | Transaction date |
| time | TIME | Transaction time |
| rating | DECIMAL(2,1) | Customer rating (1–10) |

---

## 2️⃣ Feature Engineering

To enable deeper analysis, I engineered the following columns directly in SQL:

- `time_of_day` → Categorized using CASE statements (Morning, Afternoon, Evening).
- `day_name` → Derived from date to analyze weekly footfall.
- `month_name` → Derived from date to track seasonal performance.

These features allow deeper insights into sales trends and customer behavior.

---

## 3️⃣ Data Wrangling (ETL)

- Cleaned missing and inconsistent values  
- Standardized numeric and categorical fields  
- Loaded large datasets using `BULK INSERT`  
- Ensured data consistency and integrity  


---

## 💻 Sample Advanced SQL Query

Demonstrating the use of **CTEs** and **Window Functions** to identify the top-performing branch for each product line:

```sql
WITH BranchSales AS (
    SELECT 
        branch,
        product_line,
        SUM(total) AS total_revenue,
        RANK() OVER (PARTITION BY product_line ORDER BY SUM(total) DESC) AS rank
    FROM sales
    GROUP BY branch, product_line
)
SELECT 
    branch,
    product_line,
    total_revenue
FROM BranchSales
WHERE rank = 1;
```
## 🎯 Why This Project Matters

### This project demonstrates:
This project simulates how SQL is used in real business environments to support reporting, performance analysis, and decision-making.

- Strong SQL fundamentals
- Business-oriented data analysis
- Real-world ETL concepts
- Analytical thinking
- Clean project structuring
---
## 🚀 How to Run the Project

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/ManoharManu1999/SQL-Walmart-Analysis.git
```

### 2️⃣ Initialize Database

- Open `ddl.sql` in SQL Server Management Studio (SSMS)
- Execute the script to create the required tables

### 3️⃣ Load Data

- Run `load_proc.sql` to import the CSV files into the database

### 4️⃣ Execute Analysis

- Open and run queries from `eda_sales_analysis.sql` to perform analysis

## 👤 About Me

I built this project to strengthen my understanding of SQL, data analysis, and analytical problem-solving.

I enjoy working with data to uncover patterns, solve business problems, and deliver actionable insights.

I’m actively exploring opportunities in:

- Data Analytics
- SQL Development
- Business Intelligence
- Analytics Engineering

## 📬 Let’s Connect

🔗 [LinkedIn](https://www.linkedin.com/in/manohark1999)
📧 [Email](https://www.manoharmanu.k1999@gmail.com)

## ⭐ Final Note

If you found this project useful or interesting, feel free to ⭐ star the repository.
Feedback and suggestions are always welcome!