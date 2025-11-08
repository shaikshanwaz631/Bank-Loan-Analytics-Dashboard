use bankloans;

CREATE TABLE bank_transactions (
  `Customer ID` VARCHAR(100),
  `Customer Name` VARCHAR(100),
  `Account Number` BIGINT,
  `Transaction Date` DATE,
  `Transaction Type` VARCHAR(20),
  `Amount` DECIMAL(15,2),
  `Balance` DECIMAL(15,2),
  `Description` VARCHAR(255),
  `Branch` VARCHAR(100),
  `Transaction Method` VARCHAR(50),
  `Currency` VARCHAR(10),
  `Bank Name` VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bank_transactions.csv'
INTO TABLE bank_transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  `Customer ID`,
  `Customer Name`,
  `Account Number`,
  `Transaction Date`,
  `Transaction Type`,
  `Amount`,
  `Balance`,
  `Description`,
  `Branch`,
  `Transaction Method`,
  `Currency`,
  `Bank Name`
);

select * from bank_transactions;

SELECT COUNT(*) AS Total_Transactions FROM bank_transactions;


-- -----------------------
-- Total Credit Amount
select concat(Format(sum(Amount)/1000000,2),"M") as Total_Credit_Amount 
from bank_transactions 
where `Transaction Type` = "Credit";
-- ---------------------
-- Total Debit Amount
SELECT concat(format(SUM(`Amount`)/1000000,2),"M") AS Total_Debit_Amount
FROM bank_transactions
WHERE `Transaction Type` = 'Debit';

-- ----------------------
-- Net Balance Change
SELECT 
  SUM(CASE WHEN `Transaction Type`='Credit' THEN `Amount` ELSE -`Amount` END) AS Net_Balance_Change
FROM bank_transactions;

-- ---------------------
-- Average Transaction Amount
SELECT AVG(`Amount`) AS Average_Transaction_Amount FROM bank_transactions;

-- ----------------------
-- Customer-Wise Summary
SELECT 
  `Customer Name`,
  COUNT(*) AS Total_Transactions,
  SUM(CASE WHEN `Transaction Type`='Credit' THEN `Amount` ELSE 0 END) AS Total_Credits,
  SUM(CASE WHEN `Transaction Type`='Debit' THEN `Amount` ELSE 0 END) AS Total_Debits,
  ROUND(SUM(CASE WHEN `Transaction Type`='Credit' THEN `Amount` ELSE -`Amount` END),2) AS Net_Change
FROM bank_transactions
GROUP BY `Customer Name`
ORDER BY Net_Change DESC;

-- ---------------------
-- Branch-Wise Performance
SELECT 
  `Branch`,
  SUM(`Amount`) AS Total_Amount,
  COUNT(*) AS Transaction_Count
FROM bank_transactions
GROUP BY `Branch`
ORDER BY Total_Amount DESC;

-- ---------------------
-- Bank-Wise Transactions
SELECT 
  `Bank Name`,
  COUNT(*) AS Transaction_Count,
  SUM(`Amount`) AS Total_Transaction_Amount
FROM bank_transactions
GROUP BY `Bank Name`
 ORDER BY Total_Transaction_Amount DESC;




