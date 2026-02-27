/* SQL Task:
1) Churn Rate Overview — What % of customers churned overall? Break it down by contract type.
2) Service Analysis — Which services are most associated with churn?
3) Financial Impact — What's the average monthly charge for churned vs retained customers?
4) Demographics — Do senior citizens churn more? What about customers without dependents or partners?
5) Tenure Patterns — Do newer customers churn more than long term customers?
*/

--SELECT * FROM Customer

--kpi's
SELECT
    COUNT(customerID) AS total_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct,
    ROUND(AVG(MonthlyCharges),2) AS avg_charge,
    ROUND(SUM(MonthlyCharges),2) AS total_charge,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churn_customers
FROM Customer

--1) Churn Rate Overview — What % of customers churned overall? Break it down by contract type.
SELECT
    Contract,
    COUNT(customerID) AS total_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct
FROM Customer
GROUP BY Contract
ORDER BY Churn_Rate_Pct DESC

--2) Service Analysis — Which services are most associated with churn?
SELECT 'PhoneService' AS Service, 
    CASE WHEN PhoneService = 1 THEN 'Yes' ELSE 'No' END AS Service_Value,
    COUNT(customerID) AS Total_Customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct
FROM Customer GROUP BY PhoneService

UNION ALL

SELECT 'MultipleLines', MultipleLines,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY MultipleLines

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

SELECT 'OnlineBackup', OnlineBackup,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY OnlineBackup

UNION ALL

SELECT 'DeviceProtection', DeviceProtection,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY DeviceProtection

UNION ALL

SELECT 'TechSupport', TechSupport,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY TechSupport

UNION ALL

SELECT 'StreamingTV', StreamingTV,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY StreamingTV

UNION ALL

SELECT 'StreamingMovies', StreamingMovies,
    COUNT(customerID),
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2))
FROM Customer GROUP BY StreamingMovies

ORDER BY Service, Churn_Rate_Pct DESC

--3) Financial Impact — What's the average monthly charge for churned vs retained customers?
SELECT
    Churn,
    ROUND(AVG(MonthlyCharges),2) AS avg_charge,
    COUNT(customerID) AS total_customers,
    ROUND(SUM(MonthlyCharges),2) AS total_charge
FROM Customer
GROUP BY Churn

--4) Demographics — Do senior citizens churn more? What about customers without dependents or partners?
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

--5) Tenure Patterns — Do newer customers churn more than long term customers?
SELECT
    CASE
        WHEN Tenure BETWEEN 1 AND 12 THEN 'New Customer (1-12 months)'
        WHEN Tenure BETWEEN 13 AND 24 THEN '1-2 Years (13-24 months)'
        WHEN Tenure BETWEEN 25 AND 36 THEN '2-3 Years (25-36 months)'
        WHEN Tenure BETWEEN 37 AND 48 THEN '3-4 Years (37-48 months)'
        WHEN Tenure BETWEEN 49 AND 60 THEN '4-5 Years (49-60 months)'
        ELSE 'Over 6 years'
    END AS tenure_age,
    COUNT(customerID) AS total_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(customerID), 2) AS DECIMAL(5,2)) AS Churn_Rate_Pct
FROM Customer
GROUP BY CASE
        WHEN Tenure BETWEEN 1 AND 12 THEN 'New Customer (1-12 months)'
        WHEN Tenure BETWEEN 13 AND 24 THEN '1-2 Years (13-24 months)'
        WHEN Tenure BETWEEN 25 AND 36 THEN '2-3 Years (25-36 months)'
        WHEN Tenure BETWEEN 37 AND 48 THEN '3-4 Years (37-48 months)'
        WHEN Tenure BETWEEN 49 AND 60 THEN '4-5 Years (49-60 months)'
        ELSE 'Over 6 years'
    END
ORDER BY Churn_Rate_Pct DESC

