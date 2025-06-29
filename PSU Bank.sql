CREATE DATABASE PSU_Bank_db;
USE PSU_Bank_db;

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

INSERT INTO customers VALUES
	('CUST1001', 'Rajesh', 'Kumar', 'rajesh.k@example.com', '919876543210', '12 Gandhi Nagar, Delhi', '2020-05-15', 745, TRUE),
	('CUST1002', 'Priya', 'Sharma', 'priya.s@example.com', '919876543211', '34 MG Road, Bangalore', '2021-02-20', 812, TRUE),
	('CUST1003', 'Amit', 'Patel', 'amit.p@example.com', '919876543212', '56 Nehru Road, Mumbai', '2019-11-10', 680, FALSE),
	('CUST1004', 'Ananya', 'Reddy', 'ananya.r@example.com', '919876543213', '78 Brigade Road, Hyderabad', '2022-01-05', 720, TRUE),
	('CUST1005', 'Vikram', 'Singh', 'vikram.s@example.com', '919876543214', '90 Park Street, Kolkata', '2021-07-12', 790, TRUE);

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

INSERT INTO accounts VALUES
	('ACCT20230001', 'CUST1001', 'Savings', 125000.00, '2020-05-20', 'Active', 3.50),
	('ACCT20230002', 'CUST1001', 'Fixed Deposit', 500000.00, '2021-01-15', 'Active', 6.25),
	('ACCT20230003', 'CUST1002', 'Current', 78000.50, '2021-03-01', 'Active', 0.00),
	('ACCT20230004', 'CUST1003', 'Savings', 32000.75, '2019-11-25', 'Dormant', 3.50),
	('ACCT20230005', 'CUST1004', 'Savings', 245000.00, '2022-01-10', 'Active', 4.00),
	('ACCT20230006', 'CUST1005', 'Current', 150000.00, '2021-08-05', 'Active', 0.00),
	('ACCT20230007', 'CUST1005', 'Fixed Deposit', 1000000.00, '2022-03-18', 'Active', 6.75);

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

INSERT INTO transactions VALUES
	('TXN20230601001', 'ACCT20230001', '2023-06-01 09:15:30', 10000.00, 'Deposit', 'Salary Credit', NULL, 'Completed'),
	('TXN20230601002', 'ACCT20230003', '2023-06-01 10:30:45', 25000.00, 'Withdrawal', 'ATM Withdrawal', NULL, 'Completed'),
	('TXN20230602001', 'ACCT20230005', '2023-06-02 14:22:10', 5000.00, 'Transfer', 'To ACCT20230001', 'ACCT20230001', 'Completed'),
	('TXN20230605001', 'ACCT20230002', '2023-06-05 11:05:15', 3125.00, 'Interest', 'Quarterly FD Interest', NULL, 'Completed'),
	('TXN20230608001', 'ACCT20230006', '2023-06-08 16:45:00', 20000.00, 'Withdrawal', 'Cheque Clearance', NULL, 'Pending'),
	('TXN20230610001', 'ACCT20230004', '2023-06-10 13:30:22', 1000.00, 'Deposit', 'Cash Deposit', NULL, 'Completed'),
	('TXN20230612001', 'ACCT20230007', '2023-06-12 10:15:33', 16875.00, 'Interest', 'Quarterly FD Interest', NULL, 'Completed'),
	('TXN20230615001', 'ACCT20230001', '2023-06-15 09:00:00', 15000.00, 'Withdrawal', 'Loan EMI', NULL, 'Completed'),
	('TXN20230615002', 'ACCT20230003', '2023-06-15 12:30:45', 50000.00, 'Deposit', 'Client Payment', NULL, 'Completed'),
	('TXN20230618001', 'ACCT20230005', '2023-06-18 15:20:10', 3000.00, 'Transfer', 'To ACCT20230003', 'ACCT20230003', 'Failed'),
	('TXN20230620001', 'ACCT20230006', '2023-06-20 14:05:00', 25000.00, 'Deposit', 'Cash Deposit', NULL, 'Completed'),
	('TXN20230622001', 'ACCT20230002', '2023-06-22 11:35:15', 500000.00, 'Withdrawal', 'FD Maturity', NULL, 'Completed'),
	('TXN20230625001', 'ACCT20230004', '2023-06-25 10:45:22', 2000.00, 'Deposit', 'Cash Deposit', NULL, 'Completed'),
	('TXN20230628001', 'ACCT20230007', '2023-06-28 16:30:33', 200000.00, 'Transfer', 'To ACCT20230005', 'ACCT20230005', 'Completed'),
	('TXN20230701001', 'ACCT20230001', '2023-07-01 09:15:30', 10000.00, 'Deposit', 'Salary Credit', NULL, 'Completed'),
	('TXN20230701002', 'ACCT20230003', '2023-07-01 10:30:45', 15000.00, 'Withdrawal', 'ATM Withdrawal', NULL, 'Completed'),
	('TXN20230702001', 'ACCT20230005', '2023-07-02 14:22:10', 7000.00, 'Transfer', 'To ACCT20230001', 'ACCT20230001', 'Completed'),
	('TXN20230705001', 'ACCT20230006', '2023-07-05 11:05:15', 35000.00, 'Deposit', 'Client Payment', NULL, 'Completed'),
	('TXN20230708001', 'ACCT20230002', '2023-07-08 16:45:00', 750000.00, 'Deposit', 'Fixed Deposit Renewal', NULL, 'Completed'),
	('TXN20230710001', 'ACCT20230004', '2023-07-10 13:30:22', 1500.00, 'Deposit', 'Cash Deposit', NULL, 'Completed'),
	('TXN20230712001', 'ACCT20230007', '2023-07-12 10:15:33', 50000.00, 'Withdrawal', 'Partial FD Break', NULL, 'Completed'),
	('TXN20230715001', 'ACCT20230001', '2023-07-15 09:00:00', 15000.00, 'Withdrawal', 'Loan EMI', NULL, 'Completed'),
	('TXN20230715002', 'ACCT20230003', '2023-07-15 12:30:45', 45000.00, 'Deposit', 'Client Payment', NULL, 'Completed'),
	('TXN20230718001', 'ACCT20230005', '2023-07-18 15:20:10', 4000.00, 'Transfer', 'To ACCT20230003', 'ACCT20230003', 'Completed'),
	('TXN20230720001', 'ACCT20230006', '2023-07-20 14:05:00', 20000.00, 'Deposit', 'Cash Deposit', NULL, 'Completed'),
	('TXN20230722001', 'ACCT20230002', '2023-07-22 11:35:15', 6250.00, 'Interest', 'Quarterly FD Interest', NULL, 'Completed'),
	('TXN20230725001', 'ACCT20230004', '2023-07-25 10:45:22', 2500.00, 'Deposit', 'Cash Deposit', NULL, 'Completed'),
	('TXN20230728001', 'ACCT20230007', '2023-07-28 16:30:33', 300000.00, 'Transfer', 'To ACCT20230005', 'ACCT20230005', 'Pending');

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

INSERT INTO loans VALUES
	('LOAN5001', 'CUST1001', 'ACCT20230001', 'Home', 5000000.00, 8.25, '2022-06-15', 240, 42777.00, 4800000.00, 'Active'),
	('LOAN5002', 'CUST1003', 'ACCT20230004', 'Personal', 250000.00, 12.50, '2023-01-10', 60, 5625.00, 225000.00, 'Active'),
	('LOAN5003', 'CUST1005', 'ACCT20230006', 'Auto', 800000.00, 9.75, '2022-11-20', 84, 12500.00, 650000.00, 'Active');
	
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

INSERT INTO cards VALUES
	('4123456789012345', 'CUST1001', 'ACCT20230001', 'Debit', '2020-05-25', '2025-05-31', '123', NULL, NULL, 'Active'),
	('5123456789012345', 'CUST1002', 'ACCT20230003', 'Credit', '2021-03-10', '2026-03-31', '456', 150000.00, 87500.50, 'Active'),
	('4123456789012346', 'CUST1004', 'ACCT20230005', 'Debit', '2022-01-15', '2027-01-31', '789', NULL, NULL, 'Active'),
	('5123456789012346', 'CUST1005', 'ACCT20230006', 'Credit', '2021-08-15', '2026-08-31', '321', 200000.00, 125000.00, 'Active');

SELECT c.* ,l.status AS Loan_status
FROM customers c 
JOIN loans l 
ON c.customer_id=l.customer_id
WHERE 
	c.credit_score<700 
	AND LOWER(l.status)='active';
    
SELECT *  
FROM customers c  
WHERE YEAR(c.date_joined)=2021
AND NOT EXISTS(
	SELECT 1 FROM accounts a
    WHERE a.customer_id=c.customer_id
    AND LOWER(a.account_type)='fixed deposit'
);

SELECT YEAR(c.date_joined) AS Year , ROUND(avg(a.balance),2) AS Average_account_balance
FROM customers c 
LEFT JOIN accounts a 
ON a.customer_id=c.customer_id
GROUP BY Year
ORDER BY Year ASC;

SELECT * FROM accounts
WHERE 
	LOWER(status)='dormant' 
	AND balance>50000;
    
SELECT a.*, COUNT(t.transaction_id) AS Total_Transactions
FROM accounts a 
JOIN transactions t 
ON t.account_id=a.account_id
WHERE DATE(transaction_date) BETWEEN '2023-07-01' AND '2023-07-31'
GROUP BY a.account_id
HAVING Total_Transactions>10;

SELECT * FROM accounts 
WHERE balance< ( SELECT AVG(amount) FROM transactions WHERE LOWER(transaction_type)='withdrawal');

SELECT * FROM transactions
WHERE 
	LOWER(status)='failed'
    AND amount>10000;
    
SELECT DAYNAME(transaction_date) AS Day_of_week, COUNT(*) AS Total_transactions FROM transactions
GROUP BY Day_of_week
ORDER BY Total_transactions DESC
LIMIT 2;

SELECT a.account_id , COUNT(CASE WHEN LOWER(t.transaction_type)='withdrawal' AND LOWER(t.description) LIKE '%atm%'  THEN 1 END) AS atm_withrawals
FROM accounts a 
JOIN transactions t 
ON t.account_id=a.account_id
WHERE LOWER(t.description) LIKE '%salary'
GROUP BY a.account_id
HAVING  atm_withrawals>2;

SELECT * FROM loans 
WHERE remaining_balance<6*emi;

SELECT SUM(amount) AS Interest_income FROM transactions
WHERE 
	LOWER(transaction_type)='interest'
    AND account_id IN (
		SELECT account_id FROM accounts WHERE LOWER(account_type) LIKE '%fixed deposit%')
	AND MONTH(transaction_date) IN (4,5,6);

SELECT c.* , COUNT(DISTINCT l.loan_type) AS Total_Loan_types
FROM customers c 
JOIN loans l 
ON c.customer_id=l.customer_id
GROUP BY c.customer_id
HAVING Total_Loan_types>1;

SELECT *,ROUND((used_limit/credit_limit)*100.0,2) AS Utilization_percntage FROM cards 
WHERE 
	LOWER(card_type)='credit'
    AND ROUND((used_limit/credit_limit)*100.0,2) >75.0;
    
SELECT cd.*, COUNT(t.transaction_id) AS Total_transactions
FROM cards cd
JOIN accounts a
ON a.account_id=cd.account_id
JOIN transactions t 
ON a.account_id=t.account_id AND YEAR(transaction_date)=2023
WHERE LOWER(cd.card_type)='debit' AND cd.issue_date<=DATE_SUB(CURDATE(),INTERVAL 3 YEAR)
GROUP BY cd.card_id
HAVING Total_transactions=0;

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

SELECT DISTINCT c.customer_id,a.account_id,a.balance,l.emi
FROM customers c 
JOIN loans l 
ON l.customer_id=c.customer_id
JOIN accounts a 
ON a.customer_id=c.customer_id
WHERE 
	a.balance<l.emi
	AND LOWER(l.status)='active';
    
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

SELECT ROUND(100.0*COUNT(DISTINCT a.account_id)/(SELECT COUNT(*) FROM accounts),2) AS activation_rate
FROM accounts a 
JOIN transactions t 
ON a.account_id=t.account_id
WHERE TIMESTAMPDIFF(DAY,a.open_date,t.transaction_date)<=7;

WITH Acountstats AS (
	SELECT 
		transaction_id,account_id,amount,
		AVG(amount) OVER (PARTITION BY account_id) AS avg_amount,
		STDDEV(amount) OVER (PARTITION BY account_id) AS standard_deviation_amount
	FROM transactions 
)
SELECT * FROM Acountstats
WHERE ABS(amount - avg_amount)>3*standard_deviation_amount;

SELECT a.*,t.amount AS Transaction_amount,TIME(t.transaction_date) AS Time
FROM accounts a 
JOIN transactions t 
ON a.account_id=t.account_id
WHERE 
	t.amount LIKE '%000.00'
    AND HOUR(t.transaction_date) IN (23,24,1,2,3,4,5,6);