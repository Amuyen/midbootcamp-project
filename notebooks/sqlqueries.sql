/*

1Create a database called credit_card_classification.
2Create a table credit_card_data with the same columns as given in the csv file. Please make sure you use the correct data types for each of the columns.
3Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
SHOW VARIABLES LIKE local_infile; -- This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, otherwise you should be good to go

SET GLOBAL local_infile = 1;
4Select all the data from table credit_card_data to check if the data was imported correctly.

5Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

6Use sql query to find how many rows of data you have.

7Now we will try to find the unique values in some of the categorical columns:

What are the unique values in the column Offer_accepted?
What are the unique values in the column Reward?
What are the unique values in the column mailer_type?
What are the unique values in the column credit_cards_held?
What are the unique values in the column household_size?

8Arrange the data in a decreasing order by the average_balance of the customer. Return only the customer_number of the top 10 customers with the highest average_balances in your data.

9What is the average balance of all the customers in your data?

10In this exercise we will use simple group_by to check the properties of some of the categorical variables in our data. Note wherever average_balance is asked, please take the average of the column average_balance:

What is the average balance of the customers grouped by Income Level? The returned result should have only two columns, income level and Average balance of the customers. Use an alias to change the name of the second column.
What is the average balance of the customers grouped by number_of_bank_accounts_open? The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.
What is the average number of credit cards held by customers for each of the credit card ratings? The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
Your managers are only interested in the customers with the following properties:

Credit rating medium or high
Credit cards held 2 or less
Owns their own home
Household size 3 or more
For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? Can you filter the customers who accepted the offers here?

11 Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. Write a query to show them the list of such customers. You might need to use a subquery for this problem.

12 Since this is something that the senior management is regularly interested in, create a view of the same query.

13 What is the number of people who accepted the offer vs number of people who did not?

14 Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?

15 In the database, which all types of communication (mailer_type) were used and with how many customers?

16 Provide the details of the customer that is the 11th least Q1_balance in your database.
*/
Create database credit_card_classification;

use credit_card_classification;

create table credit_card_data (customer_number int,
 offer_accepted varchar(3),
 reward varchar(20),
 mailer_type varchar(20),
 income_level varchar(20),
 number_of_bank_accounts_open tinyint,
 overdraft_protection varchar(3),
 credit_rating varchar(10),
 credit_cards_held tinyint,
 number_of_homes_owned tinyint,
 household_size tinyint,
 own_your_home varchar(3),
 average_balance float,
 q1_balance float,
 q2_balance float,
 q3_balance float,
 q4_balance float);

SHOW VARIABLES LIKE 'local_infile'; -- This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, otherwise you should be good to go

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\creditcardmarketing.csv'
INTO TABLE credit_card_data
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

select * from credit_card_data;

alter table credit_card_data
DROP column q4_balance;

select * from credit_card_data
limit 10;

select count(*) from credit_card_data;

select distinct(Offer_accepted) from credit_card_data;
select distinct(Reward) from credit_card_data;
select distinct(mailer_type) from credit_card_data;
select distinct(credit_cards_held) from credit_card_data;
select distinct(household_size) from credit_card_data;


select customer_number from credit_card_data
order by average_balance DESC
limit 10;

select avg(average_balance) from credit_card_data;

select income_level, avg(average_balance) as 'Average balance' from credit_card_data
group by income_level;

select number_of_bank_accounts_open, avg(average_balance) as 'Average balance' from credit_card_data
group by number_of_bank_accounts_open;

select  credit_rating, avg(credit_cards_held) as 'Average Number of Credit Cards' from credit_card_data
group by credit_rating;

select  number_of_bank_accounts_open, avg(credit_cards_held) from credit_card_data
group by number_of_bank_accounts_open;

select customer_number from credit_card_data
where credit_rating!='low' and credit_cards_held<3 and own_your_home='Yes' and household_size>2 and offer_accepted='Yes';

select customer_number from credit_card_data
where average_balance>(select avg(average_balance) from credit_card_data);

create view preferred_customers as
select customer_number from credit_card_data
where average_balance>(select avg(average_balance) from credit_card_data);


select count(*) as 'Number of customers', offer_accepted from credit_card_data
group by offer_accepted;


select (select avg(average_balance) from credit_card_data where credit_rating='Low') as 'Low rating average balance', 
(select avg(average_balance) from credit_card_data where credit_rating='High') as 'High rating average balance',
((select avg(average_balance) from credit_card_data where credit_rating='High')-(select avg(average_balance) from credit_card_data where credit_rating='Low')) as difference;

select mailer_type, count(*) as 'Number of Customers' from credit_card_data
group by mailer_type;

select * from (select * from credit_card_data
order by q1_balance
limit 11) T
order by q1_balance desc
limit 1

