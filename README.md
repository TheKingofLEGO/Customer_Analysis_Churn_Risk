# Customer Churn Analysis

## Overview
Analysis of 7,043 telecom customers to identify what drives churn and which customer segments are most at risk. Built using SQL Server for data cleaning and analysis, and Power BI for a two-page interactive executive dashboard.

---

## Data Source
- **Dataset:** WA_Fn-UseC_-Telco-Customer-Churn
- **Source:** Kaggle — [Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
- **Size:** 7,043 customers
- **Fields include:** Customer demographics, account information, services subscribed, contract type, tenure, monthly charges, and churn status

---

## Data Cleaning Process
Before analysis the data was fully validated and cleaned in SQL Server.

**Issues found and fixed:**

**1. Bit column identification**
Several columns (Partner, Dependents, PhoneService, PaperlessBilling, SeniorCitizen, Churn) were stored as bit type (0/1) instead of text. This required special handling in both SQL queries and Power BI DAX measures using TRUE()/FALSE() instead of text comparisons.

**2. NULL TotalCharges — 11 customers**
11 customers had NULL values in TotalCharges. Investigation revealed all 11 had a tenure of 0 — meaning they were brand new customers with no billing history yet. Replaced NULLs with 0 rather than excluding them:
```sql
UPDATE Customer
SET TotalCharges = CASE 
    WHEN TotalCharges IS NULL THEN 0 
    ELSE TotalCharges 
END
```

**3. Leading and trailing whitespace**
Text columns contained extra spaces from the CSV import which would cause WHERE clause filters to fail silently. Fixed using TRIM across all nvarchar columns:
```sql
UPDATE Customer
SET 
    customerID = TRIM(customerID),
    gender = TRIM(gender),
    MultipleLines = TRIM(MultipleLines),
    InternetService = TRIM(InternetService),
    OnlineSecurity = TRIM(OnlineSecurity),
    OnlineBackup = TRIM(OnlineBackup),
    DeviceProtection = TRIM(DeviceProtection),
    TechSupport = TRIM(TechSupport),
    StreamingTV = TRIM(StreamingTV),
    StreamingMovies = TRIM(StreamingMovies),
    Contract = TRIM(Contract),
    PaymentMethod = TRIM(PaymentMethod)
```

**4. Full null and duplicate check**
Ran complete null checks across all 21 columns and duplicate customer ID check before proceeding. No duplicates found. No additional nulls beyond TotalCharges.

---

## SQL Analysis

### KPIs
**Question:** What are the overall churn metrics for the business?
```sql
SELECT
    COUNT(customerID) AS total_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct,
    ROUND(AVG(MonthlyCharges), 2) AS avg_charge,
    ROUND(SUM(MonthlyCharges), 2) AS total_charge,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churn_customers
FROM Customer
```
**Finding:** 26.54% overall churn rate — 1,869 out of 7,043 customers churned.

---

### Query 1 — Churn Rate by Contract Type
**Question:** What % of customers churned? Break it down by contract type.
```sql
SELECT
    Contract,
    COUNT(customerID) AS total_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct
FROM Customer
GROUP BY Contract
ORDER BY Churn_Rate_Pct DESC
```
**Finding:** Month-to-month customers churn at 42.71% vs only 2.83% for two-year contracts — contract type is the single strongest predictor of churn.

---

### Query 2 — Service Analysis
**Question:** Which services are most associated with churn?
```sql
SELECT 'PhoneService' AS Service, 
    CASE WHEN PhoneService = 1 THEN 'Yes' ELSE 'No' END AS Service_Value,
    COUNT(customerID) AS Total_Customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct
FROM Customer GROUP BY PhoneService
UNION ALL
SELECT 'InternetService', InternetService,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY InternetService
UNION ALL
SELECT 'OnlineSecurity', OnlineSecurity,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY OnlineSecurity
UNION ALL
SELECT 'TechSupport', TechSupport,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY TechSupport
UNION ALL
SELECT 'OnlineBackup', OnlineBackup,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY OnlineBackup
UNION ALL
SELECT 'DeviceProtection', DeviceProtection,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY DeviceProtection
ORDER BY Service, Churn_Rate_Pct DESC
```
**Finding:** Fiber optic internet has the highest churn rate at 41.89%. Customers without OnlineSecurity churn at 41.8% — nearly 3x higher than those with it (14.6%).

---

### Query 3 — Financial Impact
**Question:** What is the average monthly charge for churned vs retained customers?
```sql
SELECT
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_charge,
    COUNT(customerID) AS total_customers,
    ROUND(SUM(MonthlyCharges), 2) AS total_charge
FROM Customer
GROUP BY Churn
```
**Finding:** Churned customers pay $74.44/month on average vs $61.27 for retained customers — churned customers are paying more yet still leaving.

---

### Query 4 — Demographics
**Question:** Do senior citizens churn more? What about customers without dependents or partners?
```sql
SELECT 'SeniorCitizen' AS Demographic,
    CASE WHEN SeniorCitizen = 1 THEN 'Yes' ELSE 'No' END AS Demographic_Value,
    COUNT(customerID) AS Total_Customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct
FROM Customer GROUP BY SeniorCitizen
UNION ALL
SELECT 'Dependents',
    CASE WHEN Dependents = 1 THEN 'Yes' ELSE 'No' END,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY Dependents
UNION ALL
SELECT 'Partner',
    CASE WHEN Partner = 1 THEN 'Yes' ELSE 'No' END,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY Partner
ORDER BY Demographic, Churn_Rate_Pct DESC
```
**Finding:** Senior citizens churn at 41.7% vs 23.6% for non-seniors. Customers without partners churn at 33% vs 19.7% with partners.

---

### Query 5 — Tenure Patterns
**Question:** Do newer customers churn more than long term customers?
```sql
SELECT
    CASE
        WHEN tenure BETWEEN 1 AND 12 THEN 'New Customer (1-12 months)'
        WHEN tenure BETWEEN 13 AND 24 THEN '1-2 Years (13-24 months)'
        WHEN tenure BETWEEN 25 AND 36 THEN '2-3 Years (25-36 months)'
        WHEN tenure BETWEEN 37 AND 48 THEN '3-4 Years (37-48 months)'
        WHEN tenure BETWEEN 49 AND 60 THEN '4-5 Years (49-60 months)'
        ELSE 'Over 6 years'
    END AS tenure_age,
    COUNT(customerID) AS total_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct
FROM Customer
GROUP BY
    CASE
        WHEN tenure BETWEEN 1 AND 12 THEN 'New Customer (1-12 months)'
        WHEN tenure BETWEEN 13 AND 24 THEN '1-2 Years (13-24 months)'
        WHEN tenure BETWEEN 25 AND 36 THEN '2-3 Years (25-36 months)'
        WHEN tenure BETWEEN 37 AND 48 THEN '3-4 Years (37-48 months)'
        WHEN tenure BETWEEN 49 AND 60 THEN '4-5 Years (49-60 months)'
        ELSE 'Over 6 years'
    END
ORDER BY Churn_Rate_Pct DESC
```
**Finding:** New customers (1-12 months) churn at 47.68% — nearly half leave within the first year. Customers over 6 years churn at only 6.56%.

---

## Dashboard
Built in Power BI across two pages with cross-filtering slicers for Contract, SeniorCitizen, and InternetService.

**Page 1 — Customer Churn Analysis**
![Customer Analysis](Customer_Analysis.png)
- 5 KPI cards: Total Customers, Churn Rate %, Total Churned, Avg Monthly Charge Churned, Avg Monthly Charge Retained
- Churn Rate by Contract Type — horizontal bar chart
- Churn Rate by Tenure Age Range — column chart with red to green gradient
- Churn Rate by SeniorCitizen, Partner, and Dependents — individual bar charts
- Key Insights box

**Page 2 — Service Analysis**
![Service Analysis](Service_Analysis.png)
- Churn Rate by InternetService
- Churn Rate by OnlineSecurity
- Churn Rate by TechSupport
- Churn Rate by DeviceProtection
- Churn Rate by PhoneService
- Churn Rate by OnlineBackup

---

## Key Findings
| Finding | Detail |
|---|---|
| Overall Churn Rate | 26.54% — 1,869 out of 7,043 customers |
| Highest Risk Segment | Month-to-month contracts at 42.71% — 15x higher than two-year (2.83%) |
| New Customer Risk | 47.68% churn in first 12 months — drops to 6.56% after 6 years |
| Financial Paradox | Churned customers pay $74.44/month vs $61.27 retained — leaving despite higher bills |
| Highest Risk Service | Fiber optic internet at 41.89% churn rate |
| Senior Citizen Risk | 41.7% churn vs 23.6% for non-seniors |
| Protection Services | Customers without OnlineSecurity churn at 41.8% vs 14.6% with it |

## Files
- `churn_analysis.sql` — all SQL queries used in the analysis
- `Customer_Analysis.png` — Page 1 dashboard screenshot
- `Service_Analysis.png` — Page 2 dashboard screenshot
