# 1. Create a database called credit_card_classification.
CREATE DATABASE credit_card_classification;

# 2. Create a table credit_card_data with the same columns as given in the csv file. Please make sure you use the correct data types for each of the columns.
CREATE TABLE credit_card_classification.credit_card_data (
	`customer_number` INT NOT NULL,
    `offer_accepted` VARCHAR(40) NOT NULL,
    `reward` VARCHAR(40) NOT NULL,
    `mailer_type` VARCHAR(40) NOT NULL,
    `income_level` VARCHAR(40) NOT NULL,
    `bank_accounts_open` INT NOT NULL,
    `overdraft_protection` VARCHAR(40) NOT NULL,
    `credit_rating` VARCHAR(40) NOT NULL,
    `credit_cards_held` INT NOT NULL,
    `homes_owned` INT NOT NULL,
    `household_size` INT NOT NULL,
    `own_your_home` VARCHAR(40) NOT NULL,
    `average_balance` FLOAT NOT NULL,
    `q1_balance` FLOAT NOT NULL,
    `q2_balance` FLOAT NOT NULL,
    `q3_balance` FLOAT NOT NULL,
    `q4_balance` FLOAT NOT NULL,
    PRIMARY KEY (`customer_number`));

# 3. Import the data from the csv file into the table. 

# 4. Select all the data from table credit_card_data to check if the data was imported correctly.
SELECT 
	* 
FROM 
	credit_card_data;

# 5. Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. 
ALTER TABLE 
	credit_card_data
DROP COLUMN
	q4_balance;
    
# Select all the data from the table to verify if the command worked. Limit your returned results to 10.
SELECT
	*
FROM
	credit_card_data
LIMIT
	10;
    
# 6. Use sql query to find how many rows of data you have.
SELECT
	COUNT(DISTINCT customer_number) AS number_of_rows
FROM
	credit_card_data;
    
# 7. Now we will try to find the unique values in some of the categorical columns:    
SELECT
	DISTINCT(offer_accepted)
FROM
	credit_card_data;
SELECT
	DISTINCT(reward)
FROM
	credit_card_data;
SELECT
	DISTINCT(mailer_type)
FROM
	credit_card_data;
SELECT
	DISTINCT(credit_cards_held)
FROM
	credit_card_data;
SELECT
	DISTINCT(household_size)
FROM
	credit_card_data;
            
# 8. Arrange the data in a decreasing order by the average_balance of the house. 
#    Return only the customer_number of the top 10 customers with the highest average_balances in your data.
SELECT
	customer_number
FROM
	credit_card_data
GROUP BY
	customer_number
ORDER BY
	average_balance DESC
LIMIT 10;

# 9. What is the average balance of all the customers in your data?
SELECT
	ROUND(AVG(average_balance),2) AS average_total_balance
FROM
	credit_card_data;
    
# 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data. 
#     Note wherever average_balance is asked, please take the average of the column average_balance:

	# a. What is the average balance of the customers grouped by Income Level? 
	#	 The returned result should have only two columns, income level and Average balance of the customers. Use an alias to change the name of the second column.
    SELECT
		income_level, ROUND(AVG(average_balance),2) AS average_balance_by_income_level
	FROM
		credit_card_data
	GROUP BY
		income_level
	ORDER BY
		average_balance_by_income_level DESC;
	
	# b. What is the average balance of the customers grouped by number_of_bank_accounts_open? 
	#	 The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.
	SELECT
		bank_accounts_open, ROUND(AVG(average_balance),2) AS average_balance_by_bank_accounts_open
	FROM
		credit_card_data
	GROUP BY
		bank_accounts_open
	ORDER BY
		bank_accounts_open ASC;
        
	# c. What is the average number of credit cards held by customers for each of the credit card ratings? 
    #	 The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
    SELECT
		credit_rating, ROUND(AVG(credit_cards_held),3) AS average_credit_cards_held_by_rating
	FROM
		credit_card_data
	GROUP BY
		credit_rating
	ORDER BY
		average_credit_cards_held_by_rating DESC;
	
    # d. Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? 
    #	 You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. 
    #	 Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
    SELECT
		bank_accounts_open, ROUND(AVG(credit_cards_held),3) AS average_number_of_credit_cards
	FROM
		credit_card_data
	GROUP BY
		bank_accounts_open
	ORDER BY
		bank_accounts_open ASC
	LIMIT
		50;
	# There seem to be no correlation between the variables, as the `2` has the lowest number of credit cards held, it should be second number held with negative or positive correlation.
    # The number held is a bit more high for `3 bank accounts open` but that could be due to causation rather than correlation.

# 11. Your managers are only interested in the customers with the following properties:
#		- Credit rating medium or high
#		- Credit cards held 2 or less
#		- Owns their own home
#		- Household size 3 or more
#	 For the rest of the things, they are not too concerned. 
#	 Write a simple query to find what are the options available for them?
SELECT
	*
FROM
	credit_card_data
WHERE
	credit_rating IN ('medium', 'high') 
    AND credit_cards_held <= 2
	AND own_your_home = 'yes'
    AND household_size >= 3;
 
#	 Can you filter the customers who accepted the offers here?
SELECT
	*
FROM
	credit_card_data
WHERE
	credit_rating IN ('medium', 'high') 
    AND credit_cards_held <= 2
	AND own_your_home = 'yes'
    AND household_size >= 3
    AND offer_accepted = 'yes';
    
# 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. 
#	  Write a query to show them the list of such customers. You might need to use a subquery for this problem.
SELECT
	customer_number, average_balance
FROM
	credit_card_data
WHERE
	average_balance < (SELECT
							AVG(average_balance)
						FROM
							credit_card_data
						)
ORDER BY
	average_balance DESC;

# 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
CREATE VIEW customer_lower_than_avg_balance AS
SELECT
	customer_number, average_balance
FROM
	credit_card_data
WHERE
	average_balance < (SELECT
							AVG(average_balance)
						FROM
							credit_card_data
						)
ORDER BY
	average_balance DESC;
    
SELECT
	*
FROM
	customer_lower_than_avg_balance
LIMIT
	20;
    
# 14. What is the number of people who accepted the offer vs number of people who did not?     
SELECT
    COUNT(*) AS total_offers,
    SUM(CASE WHEN offer_accepted = 'yes' THEN 1 ELSE 0 END) AS number_of_accepted,
    SUM(CASE WHEN offer_accepted = 'no'THEN 1 ELSE 0 END) AS number_of_rejected
FROM credit_card_data;

# 15. Your managers are more interested in customers with a credit rating of high or medium. 
#	  What is the difference in average balances of the customers with high credit card rating and low credit card rating?
SELECT 
    MAX(avg_balance) AS high_credit_rating, 
    MIN(avg_balance) AS low_credit_rating, 
    ROUND((MAX(avg_balance) - MIN(avg_balance)),2) AS average_balance_difference
FROM
    (SELECT
		ROUND(AVG(average_balance),2) AS avg_balance
	FROM
		credit_card_data
	GROUP BY 
		credit_rating
	HAVING
		credit_rating <> 'Medium'
	) AS highs_and_lows;

# 16. In the database, which all types of communication (mailer_type) were used and with how many customers?
SELECT
	mailer_type, COUNT(customer_number) AS number_of_customer
 FROM
	credit_card_data
GROUP BY
	mailer_type;

# 17. Provide the details of the customer that is the 11th least Q1_balance in your database.
WITH balance_rank AS (
	SELECT 
	*, DENSE_RANK() OVER (ORDER BY q1_balance ASC) AS q1_balance_rank
FROM
	credit_card_data
	)
SELECT
	*
FROM
	credit_card_data c
INNER JOIN
	balance_rank b
USING (customer_number)
WHERE
	q1_balance_rank = 11;