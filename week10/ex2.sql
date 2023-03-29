CREATE TABLE ex2 (
    username VARCHAR(255) NOT NULL,
    fullname VARCHAR(255) NOT NULL,
    balance FLOAT NOT NULL,
    group_id INTEGER NOT NULL,
)

-- Insert the following:
INSERT INTO ex2 (username, fullname, balance, group_id) VALUES ('jones', 'Alice Jones', 82, 1);
INSERT INTO ex2 (username, fullname, balance, group_id) VALUES ('bitdiddl', 'Ben Bitdiddle', 65, 1);
INSERT INTO ex2 (username, fullname, balance, group_id) VALUES ('mike', 'Michael Dole', 73, 2);
INSERT INTO ex2 (username, fullname, balance, group_id) VALUES ('alyssa', 'Alyssa P. Hacker', 79, 3);
INSERT INTO ex2 (username, fullname, balance, group_id) VALUES ('bbrown', 'Bob Brown', 100, 3);

-- 1. Test with Read committed and Repeatable read isolation levels:
-- We will start two different sessions in the PostgreSQL CLI, each running in its own terminal window.

-- Session 1:

-- Step 1
BEGIN;
SELECT * FROM account;

-- [Output]:
--  username  |      fullname      | balance | group_id
-- -----------+--------------------+---------+---------
--  jones     | Alice Jones        |      82 |       1
--  bitdiddl  | Ben Bitdiddle      |      65 |       1
--  mike      | Michael Dole       |      73 |       2
--  alyssa    | Alyssa P. Hacker   |      79 |       3
--  bbrown    | Bob Brown          |     100 |       3
-- (5 rows)

-- Session 2 (Terminal 2):
-- Step 2
BEGIN;
UPDATE account SET username = 'ajones' WHERE fullname = 'Alice Jones';

-- Step 4
SELECT * FROM account;

-- [Output]:
--  username |      fullname      | balance | group_id
-- ----------+--------------------+---------+---------
--  ajones   | Alice Jones        |      82 |       1
--  bitdiddl | Ben Bitdiddle      |      65 |       1
--  mike     | Michael Dole       |      73 |       2
--  alyssa   | Alyssa P. Hacker   |      79 |       3
--  bbrown   | Bob Brown          |     100 |       3
-- (5 rows)

-- The reason both sessions show the same information in Step 4 is that both sessions are using the Read Committed isolation level, which means that each query sees only the changes that have been committed by other transactions.

-- Step 5
COMMIT;

-- Now, both sessions see the updated value for Alice's username:

-- Session 1 (Terminal 1):
-- Step 6
BEGIN;
UPDATE account SET balance = balance + 10 WHERE fullname = 'Alice Jones';

-- Session 2 (Terminal 2):
-- Step 8
BEGIN;
UPDATE account SET balance = balance + 20 WHERE fullname = 'Alice Jones';

-- The output from Session 2 (Terminal 2) is blocked, waiting for Session 1 to release the lock on the account table. This is because Session 1 has already started a transaction and updated the row for Alice Jones, but has not yet committed the changes.

-- Step 9
COMMIT;

-- Now, we will repeat the exercise using the Repeatable Read isolation level.
-- Session 1 (Terminal 1):
-- Step 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM account WHERE group_id = 2;

-- [Output]:
-- Step 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM account WHERE group_id = 2;

-- [Output]:
--  username |    fullname    | balance | group_id
-- ----------+----------------+---------+---------
--  mike     | Michael Dole   |      73 |       2
-- (1 row)

-- Session 2 (Terminal 2):
-- Step 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE account SET group_id = 2 WHERE fullname = 'Bob Brown';

-- Step 4
SELECT * FROM account WHERE group_id = 2;

-- [Output]:
--  username |   fullname   | balance | group_id
-- ----------+--------------+---------+---------
--  mike     | Michael Dole |      73 |       2
--  bbrown   | Bob Brown    |     100 |       2
-- (2 rows)

-- In Step 4, both sessions see the same information because they are both using the Repeatable Read isolation level, which means that each transaction sees a snapshot of the database as it was when the transaction started.

-- Session 1 (Terminal 1):

-- Step 7
UPDATE account SET balance = balance + 15 WHERE group_id = 2;
COMMIT;

-- In Step 7, both sessions update the balance for accounts in group 2, but since they are both using the Repeatable Read isolation level, they do not see each other's changes until they commit their transactions.
-- When both transactions are committed, the changes made by both sessions are applied to the database. The final result depends on the order in which the transactions were committed, but in general, the result will be that the balance for accounts in group 2 has been increased by 30.
