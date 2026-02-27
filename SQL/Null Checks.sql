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
    PaymentMethod = TRIM(PaymentMethod),
    TotalCharges = CASE 
        WHEN TotalCharges IS NULL THEN 0 
        ELSE TotalCharges 
    END

SELECT COUNT(*) as total_orders, COUNT(DISTINCT customerID) AS total_customers FROM Customer

SELECT * FROM Customer 

SELECT COUNT(*) 
FROM Customer
WHERE MultipleLines = '' 
   OR OnlineSecurity = ''
   OR OnlineBackup = ''
   OR DeviceProtection = ''
   OR TechSupport = ''
   OR StreamingTV = ''
   OR StreamingMovies = ''

SELECT COUNT(*) 
FROM Customer
WHERE MultipleLines IS NULL 
   OR OnlineSecurity IS NULL
   OR OnlineBackup IS NULL
   OR DeviceProtection IS NULL
   OR TechSupport IS NULL
   OR StreamingTV IS NULL
   OR StreamingMovies IS NULL
--NULL
SELECT 
    SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS customerID_issues,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_issues,
    SUM(CASE WHEN SeniorCitizen IS NULL THEN 1 ELSE 0 END) AS SeniorCitizen_issues,
    SUM(CASE WHEN Partner IS NULL THEN 1 ELSE 0 END) AS Partner_issues,
    SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS Dependents_issues,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS tenure_issues,
    SUM(CASE WHEN PhoneService IS NULL THEN 1 ELSE 0 END) AS PhoneService_issues,
    SUM(CASE WHEN MultipleLines IS NULL THEN 1 ELSE 0 END) AS MultipleLines_issues,
    SUM(CASE WHEN InternetService IS NULL THEN 1 ELSE 0 END) AS InternetService_issues,
    SUM(CASE WHEN OnlineSecurity IS NULL THEN 1 ELSE 0 END) AS OnlineSecurity_issues
FROM Customer

SELECT
    SUM(CASE WHEN OnlineBackup IS NULL THEN 1 ELSE 0 END) AS OnlineBackup_issues,
    SUM(CASE WHEN DeviceProtection IS NULL THEN 1 ELSE 0 END) AS DeviceProtection_issues,
    SUM(CASE WHEN TechSupport IS NULL THEN 1 ELSE 0 END) AS TechSupport_issues,
    SUM(CASE WHEN StreamingTV IS NULL THEN 1 ELSE 0 END) AS StreamingTV_issues,
    SUM(CASE WHEN StreamingMovies IS NULL THEN 1 ELSE 0 END) AS StreamingMovies_issues,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS Contract_issues,
    SUM(CASE WHEN PaperlessBilling IS NULL THEN 1 ELSE 0 END) AS PaperlessBilling_issues,
    SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS PaymentMethod_issues,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS MonthlyCharges_issues,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS TotalCharges_issues,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Churn_issues
FROM Customer
-- SPACE
SELECT 
    SUM(CASE WHEN customerID = '' THEN 1 ELSE 0 END) AS customerID_issues,
    SUM(CASE WHEN gender = '' THEN 1 ELSE 0 END) AS gender_issues,
    SUM(CASE WHEN SeniorCitizen IS NULL THEN 1 ELSE 0 END) AS SeniorCitizen_issues,
    SUM(CASE WHEN Partner = '' THEN 1 ELSE 0 END) AS Partner_issues,
    SUM(CASE WHEN Dependents = '' THEN 1 ELSE 0 END) AS Dependents_issues,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS tenure_issues,
    SUM(CASE WHEN PhoneService = '' THEN 1 ELSE 0 END) AS PhoneService_issues,
    SUM(CASE WHEN MultipleLines = '' THEN 1 ELSE 0 END) AS MultipleLines_issues,
    SUM(CASE WHEN InternetService = '' THEN 1 ELSE 0 END) AS InternetService_issues,
    SUM(CASE WHEN OnlineSecurity = '' THEN 1 ELSE 0 END) AS OnlineSecurity_issues
FROM Customer

SELECT
    SUM(CASE WHEN OnlineBackup = '' THEN 1 ELSE 0 END) AS OnlineBackup_issues,
    SUM(CASE WHEN DeviceProtection = '' THEN 1 ELSE 0 END) AS DeviceProtection_issues,
    SUM(CASE WHEN TechSupport = '' THEN 1 ELSE 0 END) AS TechSupport_issues,
    SUM(CASE WHEN StreamingTV = '' THEN 1 ELSE 0 END) AS StreamingTV_issues,
    SUM(CASE WHEN StreamingMovies = '' THEN 1 ELSE 0 END) AS StreamingMovies_issues,
    SUM(CASE WHEN Contract = '' THEN 1 ELSE 0 END) AS Contract_issues,
    SUM(CASE WHEN PaperlessBilling = '' THEN 1 ELSE 0 END) AS PaperlessBilling_issues,
    SUM(CASE WHEN PaymentMethod = '' THEN 1 ELSE 0 END) AS PaymentMethod_issues,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS MonthlyCharges_issues,
    SUM(CASE WHEN TotalCharges = '' THEN 1 ELSE 0 END) AS TotalCharges_issues,
    SUM(CASE WHEN Churn = '' THEN 1 ELSE 0 END) AS Churn_issues
FROM Customer

SELECT customerID, tenure, MonthlyCharges, TotalCharges, Churn
FROM Customer
WHERE TotalCharges IS NULL OR TotalCharges = ''

SELECT customerID, COUNT(*) AS Count
FROM Customer
GROUP BY customerID
HAVING COUNT(*) > 1

SELECT DISTINCT SeniorCitizen 
FROM Customer

SELECT COUNT(*) AS Negative_Tenure
FROM Customer
WHERE tenure < 0

SELECT COUNT(*) AS Negative_Charges
FROM Customer
WHERE MonthlyCharges < 0 OR TotalCharges < 0

SELECT DISTINCT Churn 
FROM Customer
