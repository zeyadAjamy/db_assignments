-- Part A
-- Create a table of accounts
START Transaction;
CREATE TABLE accounts (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    credit INT NOT NULL,
    currency VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Generate and insert 3 accounts into the table, each account has 1000 Rub
INSERT INTO accounts (name, credit, currency) VALUES ('Account 1', 1000, 'RUB');
INSERT INTO accounts (name, credit, currency) VALUES ('Account 2', 1000, 'RUB');
INSERT INTO accounts (name, credit, currency) VALUES ('Account 3', 1000, 'RUB');

-- Set a savepoint for T1
SAVEPOINT t1;

-- T1: Account 1 sends 500 RUB to Account 3
UPDATE accounts SET credit = credit - 500 WHERE id = 1;
UPDATE accounts SET credit = credit + 500 WHERE id = 3;

-- Set a savepoint for T2
SAVEPOINT t2;

-- T2: Account 2 sends 700 RUB to Account 1
UPDATE accounts SET credit = credit - 700 WHERE id = 2;
UPDATE accounts SET credit = credit + 700 WHERE id = 1;

-- Set a savepoint for T3
SAVEPOINT t3;

-- T3: Account 2 sends 100 RUB to Account 3
UPDATE accounts SET credit = credit - 100 WHERE id = 2;
UPDATE accounts SET credit = credit + 100 WHERE id = 3;

-- Rollback to T1
ROLLBACK TO SAVEPOINT t1;

-- Print the credit for all accounts 
SELECT * FROM accounts;

-- Commit changes
COMMIT;

-- Part B
CREATE OR REPLACE PROCEDURE make_bank_transaction(from_id INTEGER, to_id INTEGER, amount FLOAT) 
LANGUAGE plpgsql
AS $$
DECLARE
    sender_rec RECORD;
    receiver_rec RECORD;
    fee INTEGER;
BEGIN
    SELECT * FROM accounts INTO sender_rec where accounts.id = from_id;
    SELECT * FROM accounts INTO receiver_rec where accounts.id = to_id;
    
    IF sender_rec.bank_name = receiver_rec.bank_name then
        fee := 0;
    ELSE
        fee := 30;
    END IF;

    IF sender_rec.credit > amount then
        UPDATE accounts SET credit = credit - (amount + fee) WHERE id = from_id;
        UPDATE accounts SET credit = credit + amount WHERE id = to_id;
        -- Fees should be saved in account 4 
        UPDATE accounts SET credit = credit + fee where accounts.id = 4;
    END IF;
END;
$$;

-- Add a new column to the table accounts
ALTER TABLE accounts ADD COLUMN bank_name VARCHAR(255);

-- Update the bank name for each account
UPDATE accounts SET bank_name = 'SberBank' WHERE id = 1 OR id = 3;
UPDATE accounts SET bank_name = 'Tinkoff' WHERE id = 2;

-- Create new record for fees
INSERT INTO accounts (id, name, credit, currency) VALUES (4, 'Account 4', 0, 'RUB');


START TRANSACTION;
-- Create Transactions:
-- T1: Account 1 send 500 RUB to Account 3
-- T2: Account 2 send 700 RUB to Account 1
-- T3: Account 2 send to 100 RUB to Account 3
SAVEPOINT b1;
CALL make_bank_transaction(1, 3, 500);
SAVEPOINT b2;
CALL make_bank_transaction(2, 1, 700);
SAVEPOINT b3;
CALL make_bank_transaction(2, 3, 100);

-- Return the amount Credit for all Account
SELECT * from accounts;

-- [OUTPUT]:
--  id |   name    | credit | currency | bank_name 
-- ----+-----------+--------+----------+-----------
--   1 | Account 1 |   1200 | RUB      | SberBank
--   2 | Account 2 |    140 | RUB      | Tinkoff
--   3 | Account 3 |   1600 | RUB      | SberBank
--   4 | Account 4 |     60 | RUB      | 
-- (4 rows)


-- Create Rollback for T1, T2, T3
ROLLBACK TO SAVEPOINT b1;

-- Commit the changes
COMMIT;

-- After rolling back the changes
SELECT name, credit from accounts;

-- [OUTPUT]:
--  id |   name    | credit | currency | bank_name 
-- ----+-----------+--------+----------+-----------
--   1 | Account 1 |   1000 | RUB      | SberBank
--   2 | Account 2 |   1000 | RUB      | Tinkoff
--   3 | Account 3 |   1000 | RUB      | SberBank
--   4 | Account 4 |      0 | RUB      | 
-- (4 rows)

--Part C

-- Create new table called Ledger to show all transactions:
CREATE TABLE ledger (
    id INT NOT NULL AUTO_INCREMENT,
    from_id INT NOT NULL,
    to_id INT NOT NULL,
    fee INT NOT NULL,
    amount INT NOT NULL,
    transaction_date_time TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

-- Modify Exercise 1 & 2 to save all transactions inside this table
CREATE OR REPLACE PROCEDURE make_bank_transaction(from_id INTEGER, to_id INTEGER, amount FLOAT)
LANGUAGE plpgsql
AS $$
DECLARE
    sender_rec RECORD;
    receiver_rec RECORD;
    fee INTEGER;
BEGIN
    SELECT * FROM accounts INTO sender_rec where accounts.id = from_id;
    SELECT * FROM accounts INTO receiver_rec where accounts.id = to_id;
    
    IF sender_rec.bank_name = receiver_rec.bank_name then
        fee := 0;
    ELSE
        fee := 30;
    END IF;

    IF sender_rec.credit > amount then
        UPDATE accounts SET credit = credit - (amount + fee) WHERE id = from_id;
        UPDATE accounts SET credit = credit + amount WHERE id = to_id;
        -- Fees should be saved in account 4 
        UPDATE accounts SET credit = credit + fee where accounts.id = 4;
        INSERT INTO ledger (from_id, to_id, fee, amount, transaction_date_time) VALUES (from_id, to_id, fee, amount, NOW());
    END IF;
END;