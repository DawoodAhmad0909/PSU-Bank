# PSU Bank
## Overview
## Objectives
## Database Creation
``` sql
CREATE DATABASE PSU_Bank_db;
USE PSU_Bank_db;
```
## Tables Creation
### Table:customers
``` sql
CREATE TABLE customers(
    customer_id   VARCHAR(50) PRIMARY KEY,
    first_name    VARCHAR(25) NOT NULL,
    last_name     VARCHAR(25) NOT NULL,
    email         TEXT,
    phone         VARCHAR (15),
    address       TEXT,
    date_joined   DATE NOT NULL,
    credit_score  INT,
    kyc_verified  BOOLEAN
);

SELECT * FROM customers;
```
### Table:accounts
``` sql
CREATE TABLE accounts(
    account_id     VARCHAR(50) PRIMARY KEY,
    customer_id    VARCHAR(50),
    account_type   VARCHAR(50),
    balance        DECIMAL(15,2),
    open_date      DATE,
    status         VARCHAR(50),
    interest_rate  DECIMAL(6,2),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

SELECT * FROM accounts;
```
### Table:transactions
``` sql
CREATE TABLE transactions(
    transaction_id      VARCHAR(50) PRIMARY KEY,
    account_id          VARCHAR(50),
    transaction_date    DATETIME,
    amount              DECIMAL(10,2),
    transaction_type    VARCHAR(50),
    description         TEXT,
    beneficiary_account TEXT,
    status              VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

SELECT * FROM transactions;
```
### Table:loans
``` sql
CREATE TABLE loans(
    loan_id           VARCHAR(50) PRIMARY KEY ,
    customer_id       VARCHAR(50),
    account_id        VARCHAR(50),  
    loan_type         VARCHAR(50),
    amount            DECIMAL(15,2),
    interest_rate     DECIMAL(6,2),
    start_date        DATE,
    term_months       INT,
    emi               DECIMAL(15,2),
    remaining_balance DECIMAL (15,2),
    status            VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

SELECT * FROM loans;
```
### Table:cards
``` sql
CREATE TABLE cards(
    card_id      VARCHAR(50) PRIMARY KEY,
    customer_id  VARCHAR(50),
    account_id   VARCHAR(50),
    card_type    VARCHAR(50),
    issue_date   DATE,
    expiry_date  DATE,
    cvv          VARCHAR(25),
    credit_limit DECIMAL(15,2),
    used_limit   DECIMAL(15,2),
    status       VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

SELECT * FROM cards;
```
## Key Queries

### Customer Analysis
#### 1. List customers with credit scores below 700 who have active loans.
``` sql
SELECT c.* ,l.status AS Loan_status
FROM customers c 
JOIN loans l 
ON c.customer_id=l.customer_id
WHERE 
        c.credit_score<700 
        AND LOWER(l.status)='active';
```
#### 2. Find customers who joined in 2021 but have no fixed deposit accounts. 
``` sql
SELECT *  
FROM customers c  
WHERE YEAR(c.date_joined)=2021
AND NOT EXISTS(
        SELECT 1 FROM accounts a
    WHERE a.customer_id=c.customer_id
    AND LOWER(a.account_type)='fixed deposit'
);
```
#### 3. Calculate the average account balance by customer age group (grouped by joining year).
``` sql
SELECT YEAR(c.date_joined) AS Year , ROUND(avg(a.balance),2) AS Average_account_balance
FROM customers c 
LEFT JOIN accounts a 
ON a.customer_id=c.customer_id
GROUP BY Year
ORDER BY Year ASC;
```
### Account Activity
#### 4. Identify dormant accounts with balances above ₹50,000.
``` sql
SELECT * FROM accounts
WHERE 
        LOWER(status)='dormant' 
        AND balance>50000;
```
#### 5. Show accounts with more than 10 transactions in July 2023.
``` sql
SELECT a.*, COUNT(t.transaction_id) AS Total_Transactions
FROM accounts a 
JOIN transactions t 
ON t.account_id=a.account_id
WHERE DATE(transaction_date) BETWEEN '2023-07-01' AND '2023-07-31'
GROUP BY a.account_id
HAVING Total_Transactions>10;
```
#### 6. Find accounts where the current balance is less than the average monthly withdrawal amount.
``` sql
SELECT * FROM accounts 
WHERE balance< ( SELECT AVG(amount) FROM transactions WHERE LOWER(transaction_type)='withdrawal');
```
### Transaction Patterns
#### 7. List all failed transfers with amounts exceeding ₹10,000.
``` sql
SELECT * FROM transactions
WHERE 
        LOWER(status)='failed'
    AND amount>10000;
```
#### 8. Calculate the day of week with highest transaction volumes.
``` sql
SELECT DAYNAME(transaction_date) AS Day_of_week, COUNT(*) AS Total_transactions FROM transactions
GROUP BY Day_of_week
ORDER BY Total_transactions DESC
LIMIT 2;
```
#### 9. Find accounts receiving salary deposits but with frequent ATM withdrawals.
``` sql
SELECT a.account_id , COUNT(CASE WHEN LOWER(t.transaction_type)='withdrawal' AND LOWER(t.description) LIKE '%atm%'  THEN 1 END) AS atm_withrawals
FROM accounts a 
JOIN transactions t 
ON t.account_id=a.account_id
WHERE LOWER(t.description) LIKE '%salary'
GROUP BY a.account_id
HAVING  atm_withrawals>2;
```
### Loan Management
#### 10. Identify loans where the remaining balance is less than 6 EMIs.
``` sql
SELECT * FROM loans 
WHERE remaining_balance<6*emi;
```
#### 11. Calculate interest income from fixed deposits for Q2 2023.
``` sql
SELECT SUM(amount) AS Interest_income FROM transactions
WHERE 
        LOWER(transaction_type)='interest'
    AND account_id IN (
                SELECT account_id FROM accounts WHERE LOWER(account_type) LIKE '%fixed deposit%')
        AND MONTH(transaction_date) IN (4,5,6);
```
#### 12. Find customers with multiple loan types (e.g., both home and personal loans).
``` sql
SELECT c.* , COUNT(DISTINCT l.loan_type) AS Total_Loan_types
FROM customers c 
JOIN loans l 
ON c.customer_id=l.customer_id
GROUP BY c.customer_id
HAVING Total_Loan_types>1;
```
### Card Usage
#### 13. List credit cards where used limit exceeds 75% of total limit.
``` sql
SELECT *,ROUND((used_limit/credit_limit)*100.0,2) AS Utilization_percntage FROM cards 
WHERE 
        LOWER(card_type)='credit'
    AND ROUND((used_limit/credit_limit)*100.0,2) >75.0;
```
#### 14. Find debit cards issued more than 3 years ago with no transactions in 2023.
``` sql
SELECT cd.*, COUNT(t.transaction_id) AS Total_transactions
FROM cards cd
JOIN accounts a
ON a.account_id=cd.account_id
JOIN transactions t 
ON a.account_id=t.account_id AND YEAR(transaction_date)=2023
WHERE LOWER(cd.card_type)='debit' AND cd.issue_date<=DATE_SUB(CURDATE(),INTERVAL 3 YEAR)
GROUP BY cd.card_id
HAVING Total_transactions=0;
```
### Financial Health
#### 15. Calculate debt-to-income ratio for loan customers (EMIs vs salary deposits).
``` sql
SELECT 
        c.customer_id, SUM(l.emi) AS Total_emi ,
        SUM(CASE WHEN LOWER(t.description) LIKE '%salary%' THEN t.amount ELSE 0 END ) AS Total_salary,
    ROUND (SUM(l.emi) /NULLIF(SUM(CASE WHEN LOWER(t.description) LIKE '%salary%' THEN t.amount ELSE 0 END ),0),2) AS debt_to_income_ratio
FROM customers c 
JOIN loans l 
ON l.customer_id=c.customer_id
JOIN accounts a 
ON a.customer_id=c.customer_id
JOIN transactions t 
ON t.account_id=a.account_id
GROUP BY c.customer_id;
```
#### 16. Identify customers with insufficient funds for upcoming EMIs.
``` sql
SELECT DISTINCT c.customer_id,a.account_id,a.balance,l.emi
FROM customers c 
JOIN loans l 
ON l.customer_id=c.customer_id
JOIN accounts a 
ON a.customer_id=c.customer_id
WHERE 
        a.balance<l.emi
        AND LOWER(l.status)='active';
```
### Operational Metrics
#### 17. Show the branch's top 5% customers by total relationship balance (accounts + FDs).
``` sql
SELECT * 
FROM ( 
        SELECT 
                c.customer_id,
                c.first_name,
        c.last_name,
        SUM(a.balance) AS Total_balance,
        RANK() OVER (ORDER BY SUM(a.balance) DESC) AS Rank_by_balance
        FROM customers c 
    JOIN accounts a 
    ON c.customer_id=a.customer_id
    GROUP BY c.customer_id
) AS ranked_customer
WHERE Rank_by_balance <=(SELECT CEIL(COUNT(*)*0.05) FROM customers);
```
#### 18. Calculate account activation rate (accounts used within 7 days of opening).
``` sql
SELECT ROUND(100.0*COUNT(DISTINCT a.account_id)/(SELECT COUNT(*) FROM accounts),2) AS activation_rate
FROM accounts a 
JOIN transactions t 
ON a.account_id=t.account_id
WHERE TIMESTAMPDIFF(DAY,a.open_date,t.transaction_date)<=7;
```
### Fraud Detection
#### 19. Find transactions where amount is >3 standard deviations from account's average.
``` sql
WITH Acountstats AS (
        SELECT 
                transaction_id,account_id,amount,
                AVG(amount) OVER (PARTITION BY account_id) AS avg_amount,
                STDDEV(amount) OVER (PARTITION BY account_id) AS standard_deviation_amount
        FROM transactions 
)
SELECT * FROM Acountstats
WHERE ABS(amount - avg_amount)>3*standard_deviation_amount;
```
#### 20. Identify accounts with round-number transactions (e.g., 10,000; 25,000) at odd hours.
``` sql
SELECT a.*,t.amount AS Transaction_amount,TIME(t.transaction_date) AS Time
FROM accounts a 
JOIN transactions t 
ON a.account_id=t.account_id
WHERE 
        t.amount LIKE '%000.00'
    AND HOUR(t.transaction_date) IN (23,24,1,2,3,4,5,6);
```